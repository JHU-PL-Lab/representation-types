
module Lens = Lens
module Types = Types
module Classes = Classes
module Ast = Ast

(* open Types *)
open Classes

module Ast' = Ast.Make(Identity)(Identity)
module RValue' = Ast'.RValue(Identity)


type exn +=
  | Open_Expression
  | Type_Mismatch
  | Match_Fallthrough
  | Empty_Expression


module FlowEvaluator = struct

  open Ast'
  open Types

  module Flow_map = Map.Make(String)

  let pp_flow_map pp_val fmt flow =
    Format.pp_print_char fmt '{';
    Format.pp_print_cut fmt ();
    Flow_map.iter (fun k v ->
      Format.pp_print_string fmt k;
      Format.pp_print_string fmt " -> ";
      pp_val fmt v;
      Format.pp_print_char fmt ',';
      Format.pp_print_cut fmt ()) flow;
    Format.pp_print_char fmt '}'


  type flow_tag =
    | Original
    | Source of ident
  

  module RValues = RValue(WriterF(struct
    type t = flow_tag
  end));;
  
  open RValues

  type flow_state =
    {
      env       : rvalue env;
      flow      : ident list Flow_map.t;
      type_flow : simple_type list Flow_map.t;
    }

  module State = MonadUtil( State(struct type t = flow_state end) )
  open State.Syntax  

  open TraversableUtil(Lists)
  open Make_Traversable(State)


  let ( let$ ) v f = 
    try f v     with | Match_failure (_, _, _) -> raise Type_Mismatch
  
  let ( let$+ ) v f =
    try f <$> v with | Match_failure (_, _, _) -> raise Type_Mismatch

  let ( let$* ) v f =
    try v >>= f with | Match_failure (_, _, _) -> raise Type_Mismatch


  let original rval' : rvalue State.t =
    State.pure (Original, rval')

  let retag_rvalue id (_, rval') =
    (Source(id), rval')

  let get_env : rvalue env State.t
    = fun s -> (s, s.env)

  let control f f' (sa : 'a State.t) : 'a State.t =
    fun s ->
      let (s', a) = sa (f s) in
        (f' s s', a)
  
  let modify f : unit State.t =
    fun s -> (f s, ())

  let use_env env' =
    control
      (fun s    -> {s  with env = env'  })
      (fun s s' -> {s' with env = s.env })

  let lookup id : rvalue State.t =
    let+ env = get_env in
    match List.assoc_opt id env with
    | None    -> raise Open_Expression
    | Some(v) -> v

  let register_flow dest rval : unit State.t =
    let (origin, _) = rval in
    let update_flow f =
      match origin with
      | Original    -> f
      | Source(src) -> Flow_map.update dest
        (function
        | Some (os) -> Some (src :: os)
        | None      -> Some [src]
        ) f
    in
    let update_tflow f =
      Flow_map.update dest
        (function
        | Some (ts) -> Some (type_of rval :: ts)
        | None      -> Some [type_of rval]
        ) f
    in
    modify (fun s -> { s with
      flow      = update_flow  s.flow;
      type_flow = update_tflow s.type_flow;
    })

  let eval_value v : rvalue State.t =
    match v with
    | VInt i -> original @@ RInt i
    | VTrue  -> original @@ RBool true
    | VFalse -> original @@ RBool false
    
    | VFun (id, expr) ->
      (let* env = get_env in
        original @@ RFun (env, id, expr))

    | VRec (record)  -> 
      let* record' = traverse
        (fun (lbl, id) -> let+ rv = lookup id in (lbl, rv))
        record
      in
        original @@ RRec record'


  let [@warning "-8"] eval_op o : rvalue State.t =
    try match o with
    | OPlus (i1, i2) -> 
        let+ (_, RInt r1) = lookup i1 
        and+ (_, RInt r2) = lookup i2
        in (Original, RInt (r1 + r2))
    
    | OMinus (i1, i2) -> 
        let+ (_, RInt r1) = lookup i1 
        and+ (_, RInt r2) = lookup i2
        in (Original, RInt (r1 - r2))
    
    | OLess (i1, i2) -> 
        let+ (_, RInt r1) = lookup i1 
        and+ (_, RInt r2) = lookup i2
        in (Original, RBool (r1 < r2))
    
    | OEquals (i1, i2) -> 
        let+ (_, RInt r1) = lookup i1 
        and+ (_, RInt r2) = lookup i2
        in (Original, RBool (r1 = r2))
    
    | OAnd (i1, i2) -> 
        let+ (_, RBool r1) = lookup i1 
        and+ (_, RBool r2) = lookup i2
        in (Original, RBool (r1 && r2))
    
    | OOr (i1, i2) -> 
        let+ (_, RBool r1) = lookup i1 
        and+ (_, RBool r2) = lookup i2
        in (Original, RBool (r1 || r2))
    
    | ONot (i1)  -> 
        let+ (_, RBool r1) = lookup i1
        in (Original, RBool (not r1))
    with
    | Match_failure (_, _, _) -> raise Type_Mismatch

  let [@warning "-8"] eval_proj id lbl : rvalue State.t =
    let$+ (_, RRec record) = lookup id in
    match List.assoc_opt lbl record with
    | None      -> raise Type_Mismatch
    | Some(v')  -> v'
    

  let rec eval_apply id1 id2 =
    begin [@warning "-8"]
      let$* (_, RFun (env', id, expr)) = lookup id1 in
      let* v2 = lookup id2 in
      let* () = register_flow id v2
      in
        use_env ((id, v2) :: env') @@ eval_f expr
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
      let* body_value = eval_body body in
      let* () = register_flow id body_value in
      let* () = modify (fun s -> { s with
        env = (id, retag_rvalue id body_value) :: s.env;
      })
      in if cls = []
        then State.pure body_value
        else eval_f cls

  let eval expr =
    eval_f expr {
      env = [];
      flow = Flow_map.empty;
      type_flow = Flow_map.empty;
    }

end;;



(*

  Flow Interpreter Tests

*)

module Tests = struct

  open Ast'

  (* basic operations *)
  let e1 = [
    Cl ("x1", BVal (VInt 10));
    Cl ("x2", BVal (VInt 20));
    Cl ("x3", BOpr (OPlus ("x1", "x2")));
  ]

  (* closures *)
  let e2 = [
    Cl ("f1", BVal (VFun ("a1",[
      Cl ("f2", BVal (VFun ("a2", [
        Cl ("r1", BOpr (OPlus ("a1", "a2")));
      ])));
    ])));

    Cl ("x1", BVal (VInt 10));
    Cl ("x2", BVal (VInt 20));
    Cl ("x3", BVal (VInt 200));

    Cl ("f3", BApply ("f1", "x1"));

    Cl ("x4", BApply ("f3", "x2"));
    Cl ("x5", BApply ("f3", "x3"));
  ]

  (* records *)
  let e3 = [
    Cl ("t", BVal VTrue);
    Cl ("f", BVal VFalse);

    Cl ("x1", BVal (VRec [("a", "t"); ("b", "f")]));
    Cl ("x2", BVal (VRec [("x", "x1")]));

    Cl ("x3", BProj ("x2", "x"));
    Cl ("x4", BProj ("x3", "b"));
  ]

end