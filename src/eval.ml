
open Ast
open Classes
open Types
open Util

(**
  Contains the simple algorithm for determining
  the maximum depth required of any particular record
  field type. This is later used to ensure that the
  universe of types encountered in any program is
  sufficiently small by limiting the depths to those
  necessary for matching.
*)
module Matching = struct
    
  (**
    Our result value, a mapping
    from each record shape to
    the depths needed for each of its fields.
  *)
  type shape_depth_t =
    int ID_Map.t ID_Set_Map.t

  (**
    We work in the state monad mainly
    for convenience so as not to thread
    our map manually through.
  *)
  module State = State_Util(struct
    type t = shape_depth_t
  end)

  open State.Syntax

  open Traversable_Util(Lists)
  open Lists.Make_Traversable(State)

  (**
    Given the [shape] of the record,
    update our requirements such that each of its
    fields has at least the depth required
    by [field_depths]. 
  *)
  let update_depths shape field_depths =
    State.modify @@ ID_Set_Map.update shape
      begin function
      | None -> Some(field_depths)
      | Some(depths') ->
        let max = ID_Map.union
          (fun _ c1 c2 -> Some(max c1 c2))
          depths' field_depths
        in Some(max)
      end

  (**
    Walk the AST for a particular {{!Layout.Types.simple_type} simple_type},
    keeping track of the overal depth of the type
    and associating any record types we encounter
    with the new depth witnessed.
  *)
  let rec visit_type : simple_type -> int State.t =
    function
    | TRec record ->
      let shape = record |> List.map fst |> ID_Set.of_list in
      let* field_depths = record |> traverse
        (fun (lbl, ty) -> let+ depth = visit_type ty in (lbl, depth)) in
      let field_depths' = field_depths |> List.to_seq |> ID_Map.of_seq in
      let rec_depth = field_depths |> List.map snd |> List.fold_left max 0 in
      let+ () = update_depths shape field_depths'
      in
        (1 + rec_depth)

    | TUniv -> State.pure 0
    | _     -> State.pure 1

  (**
    Walk the AST for each body of a clause in an expression,
    checking for record definitions, match patterns,
    and subexpressions in the form of match branches and
    function bodies.
  *)
  let rec visit_body =
    function
    | BVal (VFun (_, expr)) -> visit_expr expr

    | BVal (VRec record) ->
      let shape = record |> List.map fst |> ID_Set.of_list in
      let field_depths =
        record |> List.map (fun (lbl, _) -> (lbl, 0))
               |> List.to_seq
               |> ID_Map.of_seq
      in update_depths shape field_depths

    | BMatch (_, branches) ->
      State.map ignore (branches |> traverse
        (fun (ty, expr) ->
          visit_type ty >>
          visit_expr expr))

    | _ -> State.pure ()
  
  (**
    Visit the {{!Layout.Ast.body} body} associated with the clause.
  *)
  and visit_clause (Cl (_, body)) = visit_body body

  (**
    Walk over the AST of the expression, visiting
    each {{!Layout.Ast.clause} clause}.
  *)
  and visit_expr expr =
    traverse visit_clause expr >>
    State.pure ()
        
  (**
    Given the depths for each record shape in [by_shape],
    return a new depth requirement for each such that
    any record's depth {i also} satisfies that required by
    subtypes of that record (i.e. one with a subset of its fields).
  *)
  let incorporate_subtypes by_shape =
    let shapes = List.map fst (ID_Set_Map.bindings by_shape) in
    let update_sub_shapes = shapes |> traverse
      (fun shape ->
        let open Set_Util(ID_Set) in
        (powerset shape
          |> List.filter_map (fun s -> ID_Set_Map.find_opt s by_shape)
          |> traverse (update_depths shape)
        ) >> State.pure ())
    in
    fst (update_sub_shapes ID_Set_Map.empty)

  (**
    The main function exported by this module.
    From the provided [ast], compute the required
    depths needed for matching, and also incorporate
    subtype information to provide a sound, complete
    set of constraints.
  *)
  let find_required_depths (ast : Ast.expr) =
    let by_shape = fst (visit_expr ast ID_Set_Map.empty) in
    incorporate_subtypes by_shape

end

(**
  A simple interpreter outfitted with a value-tagging
  scheme which allows tracking the flow of data between
  program points. This data flow captures the dependency
  graph we need in order to propagate the type information
  gathered.
*)
module FlowTracking = struct

  (**
    Exceptions which may be thrown during interpretation.
    Under normal circumstances, none should occur; they
    indicate that the input program is malformed in some way.
  *)
  type exn +=
    | Open_Expression
    | Type_Mismatch
    | Match_Fallthrough
    | Empty_Expression

  open Types

  (**
    The type of tag which we augment our RValue type with
    to facilitate the construction of the flow graph. 
  *)
  type flow_tag =
    | Original
    (** 
      Indicating values which result from an arithmetic or
      logical operator, and so do not depend on any program point.
    *)
    | Source of Ast.ident
    (**
      Indicating values which have most recently passed through
      the program point contained by [Source].
    *)

  (**
    RValues paired with their data source.
  *)
  module RValue = RValue(WriterF(struct
    type t = flow_tag
  end));;

  open RValue

  (**
    The runtime type of the rvalue, computed
    only as deeply as is required by the shape depths provided.
  *)
  let type_of_shape (shape_depths : Matching.shape_depth_t) rv =
    match Wrapper.extract rv with
    | RInt _ -> TInt
    | RBool b -> if b then TTrue else TFalse
    | RFun (_, _, _) -> TFun
    | RRec record ->
        let record' = ID_Set.of_list (List.map fst record) in
        match ID_Set_Map.find_opt record' shape_depths with
        | None -> type_of ~depth:1 rv (* This case shouldn't occur in reality. *)
        | Some(field_depths) ->
          TRec (record |> List.map (fun (lbl, rv) ->
            let depth = ID_Map.find lbl field_depths in
            (lbl, type_of ~depth rv)))

  (**
    The type used for our state.
  *)
  type flow_state =
    {
      env       : rvalue env; (** foo *)
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
    State.gets (fun s -> s.env)

  let type_of' rv : simple_type State.t =
    let+ depths = State.gets (fun s -> s.shape_depths) in
    canonicalize_simple @@ type_of_shape depths rv

  let use_env env' =
    State.control
      (fun s    -> { s  with env = env'  })
      (fun s s' -> { s' with env = s.env })

  let lookup id : rvalue State.t =
    let+ env = get_env in
    match List.assoc_opt id env with
    | None    -> raise Open_Expression
    | Some(v) -> v

  let lookup' id = Wrapper.extract <$> lookup id

  let register_flow dest rval : unit State.t =
    let (origin, _) = rval in
    let update_dflow f =
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
      data_flow = update_dflow s.data_flow;
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

  type type_data =
    {
      type_ids : simple_type list Int_Map.t;
      pp_types : int ID_Map.t;
    }

  type tag_state =
    {
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
  

  module State = RWS_Util
    (struct type t = type_data end)
    (UnitM)
    (struct type t = tag_state end)
  

  open State
  open Syntax
  
  open Traversable_Util(Lists)
  open Make_Traversable(State)
  
  
  let type_id_of pp =
    let+ pp_types = asks (fun s -> s.pp_types) in
    ID_Map.find pp pp_types  

  let type_of' pp =
    let* tid = type_id_of pp in
    let+ type_ids = asks (fun s -> s.type_ids) in
    (tid, Int_Map.find tid type_ids)

  let type_of pp = snd <$> type_of' pp

  let tag_type (Tag tag) =
    let+ type_ids = asks (fun s -> s.type_ids) in
    let ty = type_ids |> Int_Map.find tag.t_id in
    List.nth ty tag.u_id

  let tags_of_type t_id =
    let+ type_ids = asks (fun s -> s.type_ids) in
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
      let open! Make_Traversable(Lists) in
      sequence records (* transpose the list of lists *)
      |> List.map (fun r -> ID_Map.of_seq (List.to_seq r))
    in
    let* ppt_id, ppt = type_of' pp in
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
    let (tag_state, _, ()) =
      visit_expr expr { type_ids; pp_types; }
      {
        record_tables = ID_Map.empty;
        match_tables = ID_Map.empty;
      }
    in
      tag_state

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
  let Tagging.{ record_tables; match_tables; } =
    Tagging.compute_tag_tables pp_types type_ids test_case in
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




module TaggedEvaluator = struct

  type exn +=
    | Open_Expression
    | Type_Mismatch
    | Match_Fallthrough
    | Empty_Expression

  module RValue = RValue(WriterF(struct
    type t = Types.type_tag
  end))

  open RValue
  
  type eval_state =
    {
      env: rvalue env;
    }

  type eval_envt =
    full_analysis

  module State = RWS_Util
    (struct type t = eval_envt end)
    (UnitM)
    (struct type t = eval_state end)

  open State
  open Syntax

  module Lists = Traversable_Util(Lists)
  open Lists.Make_Traversable(State)


  let protect e f v =
    try f v with | Match_failure (_, _, _) -> raise e

  let ( let$ ) v f =
    protect Type_Mismatch f v

  let ( let$+ ) v f =
    protect Type_Mismatch f <$> v

  let ( let$* ) v f =
    v >>= protect Type_Mismatch f

  let type_tag_of' pp ty : (simple_type * type_tag) State.t =
    let+ { pp_types; type_ids; _ } = ask in
    let pp_tid = ID_Map.find pp pp_types in
    let pp_tys = Int_Map.find pp_tid type_ids in
    let pp_uid, pp_ty = 
      pp_tys |> List.mapi (fun i t -> (i, t))
             |> List.find (fun (_, t) -> Types.is_instance_simple t ty)
    in pp_ty, Tag { t_id = pp_tid; u_id = pp_uid; }
    
  
  let type_tag_of pp ty : type_tag State.t =
    snd <$> type_tag_of' pp ty

  let tagged pp ty rv' : rvalue State.t =
    let+ tag = type_tag_of pp ty in
    (tag, rv')

  let tagged' pp b rv' : rvalue State.t =
    if b then
      tagged pp TTrue rv'
    else
      tagged pp TFalse rv'

  let type_of_tag (Tag tag) : simple_type State.t =
    let+ { type_ids; _ } = ask in
    let ty = Int_Map.find tag.t_id type_ids in
    List.nth ty tag.u_id

  let lookup id : rvalue State.t =
    let+ env = gets (fun s -> s.env) in
    match List.assoc_opt id env with
    | None    -> raise Open_Expression
    | Some(v) -> v

  let use_env env' (ma : 'a State.t) : 'a State.t =
    control
      (fun _ -> { env = env' })
      (fun s _ -> s)
      ma


  let eval_value pp =
    function
    | VInt i -> tagged pp TInt   @@ RInt i
    | VTrue  -> tagged pp TTrue  @@ RBool true
    | VFalse -> tagged pp TFalse @@ RBool false
    
    | VFun (id, expr) ->
      let* env = gets (fun s -> s.env) in
      tagged pp TFun @@ RFun (env, id, expr)

    | VRec record ->
      let* record' =
        record |> traverse (fun (lbl, id) -> let+ rv = lookup id in (lbl, rv)) 
      in
      let field_tags =
        record' |> List.to_seq
                |> Seq.map (fun (lbl, rv) -> (lbl, fst rv))
                |> ID_Map.of_seq
      in
      let+ { record_tables; _ } = ask in
      let record_table = ID_Map.find pp record_tables in
      let tag = Field_Tags_Map.find field_tags record_table in
      (tag, RRec record')


  let [@warning "-8"] eval_proj id lbl =
    let$+ (_, RRec record) = lookup id in
    match List.assoc_opt lbl record with
    | None     -> raise Type_Mismatch
    | Some(v)  -> v
  
  let [@warning "-8"] eval_op pp =
    function
    | OPlus (i1, i2) ->
      let$* (_, RInt r1) = lookup i1 in
      let$* (_, RInt r2) = lookup i2 in
      tagged pp TInt @@ RInt (r1 + r2)

    | OMinus (i1, i2) ->
      let$* (_, RInt r1) = lookup i1 in
      let$* (_, RInt r2) = lookup i2 in
      tagged pp TInt @@ RInt (r1 - r2)

    | OLess (i1, i2) ->
      let$* (_, RInt r1) = lookup i1 in
      let$* (_, RInt r2) = lookup i2 in
      let r3 = (r1 < r2) in
      tagged' pp r3 @@ RBool r3

    | OEquals (i1, i2) ->
      let$* (_, RInt r1) = lookup i1 in
      let$* (_, RInt r2) = lookup i2 in
      let r3 = (r1 = r2) in
      tagged' pp r3 @@ RBool r3

    | OAnd (i1, i2) ->
      let$* (_, RBool r1) = lookup i1 in
      let$* (_, RBool r2) = lookup i2 in
      let r3 = (r1 && r2) in
      tagged' pp r3 @@ RBool r3

    | OOr (i1, i2) ->
      let$* (_, RBool r1) = lookup i1 in
      let$* (_, RBool r2) = lookup i2 in
      let r3 = (r1 || r2) in
      tagged' pp r3 @@ RBool r3

    | ONot i1 ->
      let$* (_, RBool r1) = lookup i1 in
      let r2 = not r1 in
      tagged' pp r2 @@ RBool r2

  let rec eval_clause (Cl (pp, body)) =
    match body with
    | BVar id -> lookup id
    | BVal v            -> eval_value pp v
    | BOpr o            -> eval_op pp o
    | BProj (id, lbl)   -> eval_proj id lbl
    | BApply (id1, id2) -> eval_apply id1 id2
    | BMatch (id, branches) -> eval_match pp id branches

  and [@warning "-8"] eval_apply id1 id2 =
    let$* (_, RFun (env, id, expr)) = lookup id1 in
    let* v2 = lookup id2 in
    use_env ((id, v2) :: env) @@ eval_t expr

  and eval_match pp id branches =
    let$* { match_tables; _ } = ask in
    let match_table = ID_Map.find pp match_tables in
    let* (tag, _) = lookup id in
    let branch = Type_Tag_Map.find tag match_table in
    eval_t (snd @@ List.nth branches branch)

  and eval_t expr : rvalue State.t =
    match expr with
    | [] -> raise Empty_Expression
    | Cl (pp, _) as cl :: cls ->
    let* body_value = eval_clause cl in
    let* () = State.modify (fun s -> { s with
      env = (pp, body_value) :: s.env;
    })
    in if cls = []
    then State.pure body_value
    else eval_t cls

  let eval expr analysis =
    let (s, _, a) = eval_t expr analysis { env = []; }
    in (s, RValue.unwrap_rvalue a)

end


