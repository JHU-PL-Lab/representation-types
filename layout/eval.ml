
module Ast' = Ast.Ast'
open Classes
open Types
open Util


module Matching = struct

  open Ast'

  module State = State_Util(struct
    type t = int ID_Map.t ID_Set_Map.t 
  end)
  
  module Lists = struct
    include Traversable_Util(Lists)
    include Make_Traversable(State)
  end

  open Lists
  open State
  open Syntax


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
      let* field_depths = record |> Lists.traverse
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

    | _ -> pure 1
  
  let rec visit_body =
    function
    | BVal (VFun (_, expr)) -> visit_expr expr

    | BVal (VRec record) ->
      let shape = record |> List.map fst |> ID_Set.of_list in
      let field_depths =
        record |> List.map (fun (lbl, _) -> (lbl, 1))
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
          |> List.map (update_depths shape)
          |> sequence
        ) >> pure ())
    in 
    fst (update_sub_shapes ID_Set_Map.empty)

  let find_required_depths (ast : Ast'.expr) =
    let by_shape = fst (visit_expr ast ID_Set_Map.empty) in
    incorporate_subtypes by_shape

end




type exn +=
  | Open_Expression
  | Type_Mismatch
  | Match_Fallthrough
  | Empty_Expression


module FlowEvaluator = struct

  open Ast'
  open Types

  type flow_tag =
    | Original
    | Source of Ast'.ident

  module RValues = RValue(WriterF(struct
    type t = flow_tag
  end));;

  open RValues

  type flow_state =
    {
      env       : rvalue env;
      flow      : ID_Set.t ID_Map.t;
      type_flow : Type_Set.t ID_Map.t;
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

  let retag_rvalue id (_, rval') =
    (Source(id), rval')

  let get_env : rvalue env State.t
    = fun s -> (s, s.env)

  let use_env env' =
    State.control
      (fun s    -> {s  with env = env'  })
      (fun s s' -> {s' with env = s.env })

  let lookup id : rvalue State.t =
    let+ env = get_env in
    match List.assoc_opt id env with
    | None    -> raise Open_Expression
    | Some(v) -> v

  let lookup' id = RValueWrapper.extract <$> lookup id

  let register_flow dest rval : unit State.t =
    let (origin, _) = rval in
    let update_flow f =
      match origin with
      | Original    -> f
      | Source(src) -> ID_Map.update dest
        (function
        | Some (os) -> Some (ID_Set.add src os)
        | None      -> Some (ID_Set.singleton src)
        ) f
    in
    let update_tflow f =
      let t = type_of rval in
      ID_Map.update dest
        (function
        | Some (ts) -> Some (Type_Set.add t ts)
        | None      -> Some (Type_Set.singleton t)
        ) f
    in
    State.modify (fun s -> { s with
      flow      = update_flow  s.flow;
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
      let$* (_, RFun (env, id, expr)) = lookup id1 in
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
      flow = ID_Map.empty;
      type_flow = ID_Map.empty;
    }

end


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
  
