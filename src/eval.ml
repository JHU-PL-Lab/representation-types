(**
  An interpreter based on the tagging scheme
  implemented here.
*)

open Ast
open Classes
open Types
open Util


let random_input ~upper_bound : int Seq.t =
  Seq.unfold (fun () -> Some(Random.int upper_bound, ())) ()

let repeated_input i : int Seq.t =
  let rec inf () = Seq.Cons (i, inf) in inf


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
  | End_of_input
  | Interpreters_Out_Of_Step
  

(**
  The interpreter which uses runtime type tag information
  to reduce overhead in pattern matching.
*)
module TaggedEvaluator = struct


  (**
    RValues paired with a {{!Types.type_tag} type_tag}
  *)
  module RValue = RValue(WriterF(struct
    type t = Types.type_tag
  end))

  open RValue
  
  (**
    The only state we need in this case
    is the runtime environment,
    and a means of handling input expressions.
  *)
  type eval_state =
    {
      env   : rvalue env;
      input : int Seq.t;
    }

  (**
    We also will require other inputs
    in the form of a {!full_analysis} of the expression.
  *)
  type eval_envt =
    {
      analysis : Analysis.full_analysis;
    }

  (**
    Again we use Reader-Writer-State to easily
    combine state and inputs into one system.
  *)
  module State = RWS_Util
    (struct type t = eval_envt end)
    (UnitM)
    (struct type t = eval_state end)

  open State.Syntax

  open Traversable_Util(Lists)
  open Make_Traversable(State)

  (**
    Helper function to throw the desired exception
    when a {!Match_failure} occurs, to simplify the control
    flow when defining the operator semantics, etc.
  *)
  let protect e f v =
    try f v with | Match_failure (_, _, _) -> raise e

  (** {!protect} in the form of a let-operator. *)
  let ( let$ ) v f =
    protect Type_Mismatch f v

  (** 
    {!protect} + mapping over a monadic action. 
    (like {{!Layout.Classes.Functor_Util.Syntax.val-let+} let+}) 
  *)
  let ( let$+ ) (v : _ State.t) f : _ State.t =
    protect Type_Mismatch f <$> v

  (** 
    {!protect} + binding a monadic action. 
    (like {{!Layout.Classes.Monad_Util.Syntax.val-let*} let*})
  *)
  let ( let$* ) (v : _ State.t) (f : _ -> _ State.t) : _ State.t =
    v >>= protect Type_Mismatch f


  (**
    The runtime type of the avalue, computed
    only as deeply as is required by the shape depths provided.
    Nondeterministic in the case of records!
  *)
  let rec type_of ?(depth=(Int.max_int)) (rv : rvalue)  : simple_type State.t =
    canonicalize_simple <$>
    if depth = 0 then State.pure TUniv else
    match Wrapper.extract rv with
    | RInt _         -> State.pure TInt
    | RBool true     -> State.pure TTrue
    | RBool false    -> State.pure TFalse
    | RFun (_, _, _) -> State.pure TFun
    | RRec record ->
        let* { field_depths; _ } = State.asks (fun s -> s.analysis) in
        let+ record' = record
          |> ID_Map.bindings
          |> traverse (fun (lbl, rv') -> 
            let depth' = ID_Map.find lbl field_depths in
            let+ ty = type_of ~depth:(min depth' (depth - 1)) rv' in
              (lbl, ty)
          ) 
        in
          TRec ( record' )

  
  (**
    Use the {!full_analysis} to look up the
    {!Types.type_tag} and associated {!Types.simple_type}
    which is assigned to a particular program point.
  *)
  let type_tag_of ty : type_tag State.t =
    let+ { type_to_id; _ } = State.asks (fun s -> s.analysis.inferred_types) in
    Tag (Type_Map.find ty type_to_id)

    (* let pp_uid  = ID_Map.find pp pp_to_union_id in
    let pp_tids = Int_Map.find pp_uid id_to_union |> Int_Set.elements in
    let pp_tys  = pp_tids |> List.map (fun tid -> Int_Map.find tid id_to_type) in
    let pp_uid, pp_ty =
      pp_tys |> List.mapi (fun i t -> (i, t))
             |> List.find (fun (_, t) -> Types.is_instance_simple t ty)
    in Tag { t_id = pp_tid; u_id = pp_uid; }
     *)

  (**
    Assign the correct tag to an (untagged) {!rvalue}
    given that it will be going to a particular
    program point with a particular runtime type.
  *)
  let tagged ty (rv' : rvalue_spec) : rvalue State.t =
    let+ tag = type_tag_of ty in
    (tag, rv')

  (**
    Assign the correct boolean type tag to
    the {!rvalue} depending on the actual value it holds.
  *)
  let tagged' b rv' : rvalue State.t =
    if b then
      tagged TTrue rv'
    else
      tagged TFalse rv'

  (**
    Look up the {!Types.simple_type} associated
    with the given {!Types.type_tag}.
  *)
  let type_of_tag (Tag tag) : simple_type State.t =
    let+ { id_to_type; _ } = State.asks (fun s -> s.analysis.inferred_types) in
    Int_Map.find tag id_to_type

  (**
    Look up an rvalue by name in the environment.
  *)
  let lookup (id : ident) : rvalue State.t =
    let+ env = State.gets (fun s -> s.env) in
    match List.assoc_opt id env with
    | None    -> raise Open_Expression
    | Some(v) -> v

  (**
    Given a new environment to operate in,
    run the provided stateful action within it,
    then revert the environment.
  *)
  let use_env env' : 'a State.t -> 'a State.t =
    State.control
      (fun s    -> { s  with env = env'  })
      (fun s s' -> { s' with env = s.env })

  (**
    Get an integer as input using the
    provided input strategy.
  *)
  let get_input : rvalue State.t =
    let* { input; _ } = State.get in
    match input () with
    | Seq.Nil -> raise End_of_input
    | Seq.Cons (i, input') ->
    let* () = State.modify (fun s -> { s with input=input' }) in
    tagged TInt (RInt i)


  (**
    Compute the runtime (tagged) value of an {!Ast.value}
    given the current program point.
  *)
  let eval_value pp : Ast.value -> rvalue State.t =
    function
    | VInt i -> tagged TInt   @@ RInt i
    | VTrue  -> tagged TTrue  @@ RBool true
    | VFalse -> tagged TFalse @@ RBool false
    
    | VFun (id, expr) ->
      let* env = State.gets (fun s -> s.env) in
      tagged TFun @@ RFun (env, id, expr)

    | VRec record ->
      let* record' =
        record |> traverse (fun (lbl, id) -> let+ rv = lookup id in (lbl, rv)) 
      in
      let record' = record' |> List.to_seq |> ID_Map.of_seq in
      let field_tags = ID_Map.map fst record' in
      let+ { record_tables; _ } = State.asks (fun s -> s.analysis.tag_tables) in
      let tag = record_tables
        |> ID_Map.find pp
        |> Field_Tags_Map.find field_tags
      in
      (tag, RRec record')

  (**
    Evaluate a particular record {{!Ast.body.BProj} projection}.
  *)
  let [@warning "-8"] eval_proj id lbl =
    let$+ (_, RRec record) = lookup id in
    match ID_Map.find_opt lbl record with
    | None     -> raise Type_Mismatch
    | Some(v)  -> v
  
  (**
    Evaluate (and tag properly) the result of an {!Ast.operator}.
  *)
  let [@warning "-8"] eval_op pp =
    function
    | OPlus (i1, i2) ->
      let$* (_, RInt r1) = lookup i1 in
      let$* (_, RInt r2) = lookup i2 in
      tagged TInt @@ RInt (r1 + r2)

    | OMinus (i1, i2) ->
      let$* (_, RInt r1) = lookup i1 in
      let$* (_, RInt r2) = lookup i2 in
      tagged TInt @@ RInt (r1 - r2)

    | OLess (i1, i2) ->
      let$* (_, RInt r1) = lookup i1 in
      let$* (_, RInt r2) = lookup i2 in
      let r3 = (r1 < r2) in
      tagged' r3 @@ RBool r3

    | OEquals (i1, i2) ->
      let$* (_, RInt r1) = lookup i1 in
      let$* (_, RInt r2) = lookup i2 in
      let r3 = (r1 = r2) in
      tagged' r3 @@ RBool r3

    | OAnd (i1, i2) ->
      let$* (_, RBool r1) = lookup i1 in
      let$* (_, RBool r2) = lookup i2 in
      let r3 = (r1 && r2) in
      tagged' r3 @@ RBool r3

    | OOr (i1, i2) ->
      let$* (_, RBool r1) = lookup i1 in
      let$* (_, RBool r2) = lookup i2 in
      let r3 = (r1 || r2) in
      tagged' r3 @@ RBool r3

    | ONot i1 ->
      let$* (_, RBool r1) = lookup i1 in
      let r2 = not r1 in
      tagged' r2 @@ RBool r2

    | OAppend (i1, i2) ->
      let$* (t1, RRec r1) = lookup i1 in
      let$* (t2, RRec r2) = lookup i2 in
      let+ { append_tables; _ } = State.asks (fun s -> s.analysis.tag_tables) in
      let tag = append_tables
        |> ID_Map.find pp
        |> Type_Tag_Pair_Map.find (t1, t2)
      in tag, RRec 
        (ID_Map.union (fun _ _ rv2 -> Some(rv2)) r1 r2)

  (**
    Evaluate a single {!Ast.clause} in the expression.
  *)
  let rec eval_clause (Cl (pp, body)) =
    match body with
    | BVar id -> lookup id
    | BVal v            -> eval_value pp v
    | BOpr o            -> eval_op pp o
    | BProj (id, lbl)   -> eval_proj id lbl
    | BApply (id1, id2) -> eval_apply id1 id2
    | BMatch (id, branches) -> eval_match pp id branches
    | BInput -> get_input

  (**
    Evaluate a function {{!Ast.body.BApply} application}.
  *)
  and [@warning "-8"] eval_apply id1 id2 =
    let$* (_, RFun (env, id, expr)) = lookup id1 in
    let* v2 = lookup id2 in
    use_env ((id, v2) :: env) @@ eval_t expr

  (**
    Evaluate (using tag lookup tables)
    a particular {{!Ast.body.BMatch} match} expression.

    The program point has to be supplied too so we
    can retrieve the necessary match table entry.
  *)
  and eval_match pp id branches =
    let* { match_tables; _ } = State.asks (fun s -> s.analysis.tag_tables) in
    let* (tag, _) as rv = lookup id in
    let* typ = type_of rv in
    let tag_branch = match_tables
      |> ID_Map.find pp
      |> Type_Tag_Map.find tag
    in
    let typ_branch =
      try branches
        |> List.mapi (fun i (pat, _) -> (i, pat))
        |> List.find (fun (_, pat) -> is_subtype_simple typ pat)
        |> fst
      with
      | Not_found -> raise Match_Fallthrough
    in
    if tag_branch == typ_branch then
      eval_t (snd @@ List.nth branches tag_branch)
    else
      raise Interpreters_Out_Of_Step

  (**
    Evaluate an {!Ast.expr} in a tagged fashion.
  *)
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

  (**
    Entry point to the other evaluation functions;
    this sets up and unwraps the {!State} monad and
    the tags in the resulting rvalue.
  *)
  let eval expr input analysis : eval_state * Ast.rvalue' =
    let (s, _, a) = eval_t expr { analysis } { env = []; input }
    in (s, RValue.unwrap a)

end


