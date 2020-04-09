
open Ast
open Classes
open Types
open Util


module Matching = struct

  module State = State_Util(struct
    type t = int ID_Map.t ID_Set_Map.t
  end)

  open Traversable_Util(Lists)
  open Make_Traversable(State)

  open State
  open Syntax

  type shape_depth_t =
    int ID_Map.t ID_Set_Map.t


  let update_depths shape field_depths =
    modify @@ ID_Set_Map.update shape
      begin function
      | None -> Some(field_depths)
      | Some(depths') ->
        let max = ID_Map.union
          (fun _ c1 c2 -> Some(max c1 c2))
          depths' field_depths
        in Some(max)
      end

  let rec visit_type =
    function
    | TRec record ->
      let shape = record |> List.map fst |> ID_Set.of_list in
      let* field_depths = record |> traverse
        (fun (lbl, ty) -> let+ depth = visit_type ty in (lbl, depth)) in
      let field_depths' = field_depths |> List.to_seq |> ID_Map.of_seq in
      let rec_depth = field_depths |> List.map snd |> List.fold_left max 0 in
      let+ () = modify @@
        ID_Set_Map.update shape
          (function
          | None -> Some(field_depths')
          | Some(cts) -> Some(ID_Map.union
                (fun _ c1 c2 -> Some(max c1 c2)) cts field_depths'))
      in
        (1 + rec_depth)

    | TUniv -> pure 0
    | _ -> pure 1

  let rec visit_body =
    function
    | BVal (VFun (_, expr)) -> visit_expr expr

    | BVal (VRec record) ->
      let shape = record |> List.map fst |> ID_Set.of_list in
      let field_depths =
        record |> List.map (fun (lbl, _) -> (lbl, 0))
               |> List.to_seq
               |> ID_Map.of_seq
      in
      modify @@ ID_Set_Map.update shape
        (function
        | None -> Some(field_depths)
        | Some(cts) -> Some(cts))

    | BMatch (_, branches) ->
      map ignore (branches |> traverse
        (fun (ty, expr) ->
          visit_type ty >>
          visit_expr expr))

    | _ -> pure ()

  and visit_clause (Cl (_, body)) = visit_body body

  and visit_expr expr =
    traverse visit_clause expr >>
    pure ()


  let incorporate_subtypes by_shape =
    let shapes = List.map fst (ID_Set_Map.bindings by_shape) in
    let update_sub_shapes = shapes |> traverse
      (fun shape ->
        let open Set_Util(ID_Set) in
        (powerset shape
          |> List.filter_map (fun s -> ID_Set_Map.find_opt s by_shape)
          |> traverse (update_depths shape)
        ) >> pure ())
    in
    fst (update_sub_shapes ID_Set_Map.empty)

  let find_required_depths (ast : Ast.expr) =
    let by_shape = fst (visit_expr ast ID_Set_Map.empty) in
    incorporate_subtypes by_shape

end


module FlowTracking = struct

  type exn +=
    | Open_Expression
    | Type_Mismatch
    | Match_Fallthrough
    | Empty_Expression

  open Types

  type flow_tag =
    | Original
    | Source of Ast.ident

  module RValue = RValue(WriterF(struct
    type t = flow_tag
  end));;

  open RValue

  let type_of_shape (shape_depths : Matching.shape_depth_t) rv =
    match Wrapper.extract rv with
    | RInt _ -> TInt
    | RBool b -> if b then TTrue else TFalse
    | RFun (_, _, _) -> TFun
    | RRec record ->
        let record' = ID_Set.of_list (List.map fst record) in
        match ID_Set_Map.find_opt record' shape_depths with
        | None -> type_of ~depth:1 rv
        | Some(field_depths) ->
          TRec (record |> List.map (fun (lbl, rv) ->
            let depth = ID_Map.find lbl field_depths in
            (lbl, type_of ~depth rv)))

  type flow_state =
    {
      env       : rvalue env;
      data_flow : ID_Set.t ID_Map.t;
      type_flow : Type_Set.t ID_Map.t;
      shape_depths : Matching.shape_depth_t;
    }

  module State = State_Util(struct type t = flow_state end)
  open State.Syntax

  open Traversable_Util(Lists)
  open Make_Traversable(State)


  let protect e f v =
    try f v with | Match_failure (_, _, _) -> raise e

  let ( let$ ) v f =
    protect Type_Mismatch f v

  let ( let$+ ) v f =
    protect Type_Mismatch f <$> v

  let ( let$* ) v f =
    v >>= protect Type_Mismatch f


  let original rval' : rvalue State.t =
    State.pure (Original, rval')

  let retag_rvalue id : rvalue -> rvalue =
    fun (_, rval') -> (Source(id), rval')

  let get_env : rvalue env State.t =
      fun s -> (s, s.env)

  let type_of' rv : simple_type State.t =
    fun s ->
      (s, canonicalize_simple @@ type_of_shape s.shape_depths rv)

  let use_env env' =
    State.control
      (fun s    -> {s  with env = env'  })
      (fun s s' -> {s' with env = s.env })

  let lookup id : rvalue State.t =
    let+ env = get_env in
    match List.assoc_opt id env with
    | None    -> raise Open_Expression
    | Some(v) -> v

  let lookup' id = Wrapper.extract <$> lookup id

  let register_flow dest rval : unit State.t =
    let (origin, _) = rval in
    let update_flow f =
      match origin with
      | Original    -> f
      | Source(src) -> f |> ID_Map.update dest
        (function
        | Some (os) -> Some (ID_Set.add src os)
        | None      -> Some (ID_Set.singleton src)
        )
    in
    let* rt = type_of' rval in
    let update_tflow f =
      f |> ID_Map.update dest
        (function
        | Some (ts) -> Some (Type_Set.add rt ts)
        | None      -> Some (Type_Set.singleton rt)
        )
    in
    State.modify (fun s -> { s with
      data_flow = update_flow  s.data_flow;
      type_flow = update_tflow s.type_flow;
    })

  let eval_value v : rvalue State.t =
    match v with
    | VInt i -> original @@ RInt i
    | VTrue  -> original @@ RBool true
    | VFalse -> original @@ RBool false

    | VFun (id, expr) ->
      let* env = get_env in
        original @@ RFun (env, id, expr)

    | VRec (record)  ->
      let* record' = record |> traverse (fun (lbl, id) ->
        let+ rv = lookup id in (lbl, rv))
      in
        original @@ RRec record'


  let [@warning "-8"] eval_op o : rvalue State.t =
    match o with
    | OPlus (i1, i2) ->
        let$* RInt r1 = lookup' i1 in
        let$* RInt r2 = lookup' i2 in
          original @@ RInt (r1 + r2)

    | OMinus (i1, i2) ->
        let$* RInt r1 = lookup' i1 in
        let$* RInt r2 = lookup' i2 in
          original @@ RInt (r1 - r2)

    | OLess (i1, i2) ->
        let$* RInt r1 = lookup' i1 in
        let$* RInt r2 = lookup' i2 in
          original @@ RBool (r1 < r2)

    | OEquals (i1, i2) ->
        let$* RInt r1 = lookup' i1 in
        let$* RInt r2 = lookup' i2 in
          original @@ RBool (r1 = r2)

    | OAnd (i1, i2) ->
        let$* RBool r1 = lookup' i1 in
        let$* RBool r2 = lookup' i2 in
          original @@ RBool (r1 && r2)

    | OOr (i1, i2) ->
        let$* RBool r1 = lookup' i1 in
        let$* RBool r2 = lookup' i2 in
          original @@ RBool (r1 || r2)

    | ONot (i1)  ->
        let$* RBool r1 = lookup' i1 in
         original @@ RBool (not r1)


  let [@warning "-8"] eval_proj id lbl : rvalue State.t =
    let$+ RRec record = lookup' id in
    match List.assoc_opt lbl record with
    | None     -> raise Type_Mismatch
    | Some(v)  -> v


  let rec eval_apply id1 id2 =
    begin [@warning "-8"]
      let$* RFun (env, id, expr) = lookup' id1 in
      let* v2 = lookup id2 in
      let* () = register_flow id v2
      in
        use_env ((id, retag_rvalue id v2) :: env) @@ eval_f expr
    end

  and eval_body =
    function
    | BVar id -> lookup id
    | BVal v -> eval_value v
    | BOpr o -> eval_op o
    | BProj (id, lbl) -> eval_proj id lbl
    | BApply (id1, id2) -> eval_apply id1 id2

    | BMatch (id, branches) ->
        let* v1 = lookup id in
        let branch = List.find_opt
          (fun (pat, _) -> matches pat v1) branches in
        match branch with
        | None -> raise Match_Fallthrough
        | Some((_, expr')) -> eval_f expr'

  and eval_f expr =
    match expr with
    | [] -> raise Empty_Expression
    | Cl (id, body) :: cls ->
    let* body_value  = eval_body body in
    let  body_value' = retag_rvalue id body_value in
    let* () = register_flow id body_value in
    let* () = State.modify (fun s -> { s with
      env = (id, body_value') :: s.env;
    })
    in if cls = []
    then State.pure body_value'
    else eval_f cls

  let eval expr =
    eval_f expr {
      env = [];
      data_flow = ID_Map.empty;
      type_flow = ID_Map.empty;
      shape_depths = Matching.find_required_depths expr;
    }

end


module Typing = struct

  let assign_unique_type_ids
    (type_flow : Type_Set.t ID_Map.t) =
    let open struct
      module Type_Set_Set = Set.Make(Type_Set)
      type fold_t = {
        next_id: int;
        type_ids: int Type_Set_Map.t;
        ids_type: Type_Set.t Int_Map.t;
      }
    end in
    let initial = {
      next_id = 0;
      type_ids = Type_Set_Map.empty;
      ids_type = Int_Map.empty;
    } in
    let { type_ids; ids_type; _ } =
      initial |> ID_Map.fold (fun _ ts s ->
        match Type_Set_Map.find_opt ts s.type_ids with
        | Some(_) -> s
        | None -> {
            next_id = s.next_id + 1;
            type_ids = Type_Set_Map.add ts s.next_id s.type_ids;
            ids_type = Int_Map.add s.next_id ts s.ids_type;
          }
      ) type_flow

    in (type_ids, ids_type)


  let type_flow_closure
    (data_flow : ID_Set.t   ID_Map.t)
    (type_flow : Type_Set.t ID_Map.t) =
      let tflow_uf = ID_Map.map Union_find.make_distinct type_flow in
      tflow_uf |> ID_Map.iter (fun id uf ->
        let data_src = ID_Map.find_opt id data_flow in
        let data_src = Option.value data_src ~default:ID_Set.empty in
        data_src |> ID_Set.iter (fun src ->
          match ID_Map.find_opt src tflow_uf with
          | Some(src_uf) -> Union_find.union Type_Set.union uf src_uf
          | None         -> ()));
      tflow_uf |> ID_Map.map Union_find.find


  let assign_program_point_types
    (data_flow : ID_Set.t ID_Map.t)
    (type_flow : Type_Set.t ID_Map.t) =
    let type_flow' = type_flow_closure data_flow type_flow in
    let (type_ids, ids_type) = assign_unique_type_ids type_flow' in
    (
      Int_Map.map Type_Set.elements ids_type, 
      ID_Map.map (fun t -> Type_Set_Map.find t type_ids) type_flow'
    )

end


module Tagging = struct

  type tag_state =
    {
      type_ids : simple_type list Int_Map.t;
      pp_types : int ID_Map.t;

      (*
        for each match program point: 
        a mapping from union type tag to branch taken.
      *)
      match_tables : int Type_Tag_Map.t ID_Map.t;
      
      (*
        for each record construction program point:
        a mapping from per-field union type tags
        to the resulting union type tag for the record.
      *)
      record_tables : type_tag Field_Tags_Map.t ID_Map.t;
    }

  module State = State_Util(struct
    type t = tag_state
  end)

  open State
  open Syntax
  
  open Traversable_Util(Lists)
  open Make_Traversable(State)
  
  
  let type_id_of pp =
    let+ pp_types = (fun s -> s.pp_types) <$> get in
    ID_Map.find pp pp_types  
    
  let type_of pp =
    let* tid = type_id_of pp in
    let+ type_ids = (fun s -> s.type_ids) <$> get in
    Int_Map.find tid type_ids

  let tag_type (Tag tag) =
    let+ type_ids = (fun s -> s.type_ids) <$> get in
    let ty = type_ids |> Int_Map.find tag.t_id in
    List.nth ty tag.u_id

  let tags_of_type t_id =
    let+ type_ids = (fun s -> s.type_ids) <$> get in
    type_ids
      |> Int_Map.find t_id
      |> List.mapi (fun u_id _ -> Tag { t_id; u_id; })


  let first_where ~default f tys ty =
    tys |> List.mapi (fun i t -> (i, t))
        |> List.find_opt (fun (_, t) -> f ty t)
        |> Option.map fst
        |> Option.value ~default
        
  let find_matching tys ty =
    first_where is_subtype_simple tys ty

  let find_retagging tys ty =
    first_where is_instance_simple tys ty

  let rec visit_expr e =
    traverse visit_clause e >>
    pure ()

  and visit_clause (Cl (pp, body)) =
    match body with
    | BVal (VRec record)    -> process_record pp record
    | BVal (VFun (_, expr)) -> visit_expr expr
    | BMatch (id, branches) ->
        traverse (fun (_, expr) -> visit_expr expr) branches >>
        process_match pp id branches
    | _ -> pure ()

  and process_record pp record =
    let* records = record 
      |> traverse @@ fun (lbl, elt) ->
          let* elt_tid  = type_id_of elt in
          let+ elt_tags = tags_of_type elt_tid in
          List.map (fun tag -> (lbl, tag)) elt_tags
    in
    let records =
      let open Make_Traversable(Lists) in
      sequence records (* transpose the list of lists *)
      |> List.map (fun r -> r |> List.to_seq |> ID_Map.of_seq)
    in
    let* ppt_id = type_id_of pp in
    let* ppt = type_of pp in
    let* field_maps =
      records |> traverse @@ fun record ->
        let+ rty =
          ID_Map.bindings record |> traverse (fun (lbl, tag) ->
            let+ ty = tag_type tag in (lbl, ty)) 
        in
        let result_u_id = find_retagging ~default:(-1) ppt (TRec rty) in
          Field_Tags_Map.singleton record
            (Tag { t_id = ppt_id; u_id = result_u_id })
    in
    let field_map =
      field_maps |> List.fold_left
        (Field_Tags_Map.union (fun _ _ _ -> None)) (* safe, the maps are disjoint. *)
        Field_Tags_Map.empty
    in
    modify (fun s -> { s with 
      record_tables = s.record_tables
        |> ID_Map.add pp field_map
    })

  and process_match pp id branches =
    let* id_tid = type_id_of id in
    let* id_tags = tags_of_type id_tid in
    let branch_tys = List.map fst branches in
    let* branch_maps =
      id_tags |> traverse (fun tag ->
        let+ ty = tag_type tag in
        Type_Tag_Map.singleton tag (find_matching ~default:(-1) branch_tys ty)) in
    let branch_map =
      branch_maps |> List.fold_left
        (Type_Tag_Map.union (fun _ _ _ -> None)) (* safe, the maps are disjoint. *)
        Type_Tag_Map.empty 
    in
    modify (fun s -> { s with
      match_tables = s.match_tables
        |> ID_Map.add pp branch_map
    })
  

  let compute_tag_tables pp_types type_ids expr =
    let (tag_state, ()) =
      visit_expr expr {
        type_ids; pp_types;
        record_tables = ID_Map.empty;
        match_tables = ID_Map.empty;
      }
    in
      tag_state.record_tables,
      tag_state.match_tables

end

type full_analysis =
  {
    flow : FlowTracking.flow_state;
    result: RValue'.rvalue;
    pp_types: int ID_Map.t;
    type_ids: simple_type list Int_Map.t;
    match_tables: int Type_Tag_Map.t ID_Map.t;
    record_tables: type_tag Field_Tags_Map.t ID_Map.t;
  }

let full_analysis_of test_case =
  let (flow, rval) = FlowTracking.eval test_case in
  let result = FlowTracking.RValue.unwrap_rvalue rval in
  let (type_ids, pp_types) = 
    Typing.assign_program_point_types
      flow.data_flow flow.type_flow in
  let record_tables, match_tables =
    Tagging.compute_tag_tables
      pp_types type_ids test_case in
  {
    flow;
    result;
    pp_types;
    type_ids;
    match_tables;
    record_tables;
  }
  
(*
  The environment from interpretation
  takes up way too much space when used
  interactively via utop etc., so this
  version just gets rid of it for convenience.
*)
let full_analysis_of' test_case =
  let f = full_analysis_of test_case in
  { f with
    flow = { f.flow with
      env = []
    }
  }