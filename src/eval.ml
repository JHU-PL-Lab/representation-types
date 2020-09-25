
(**
  Primary analysis tools and evaluators.
*)

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
    from each record field to
    the depths needed for its type in order
    to perform pattern matching reliably.
  *)
  type field_depth_t = int ID_Map.t

  (**
    We work in the state monad mainly
    for convenience so as not to thread
    our map manually through.
  *)
  module State = State_Util(struct
    type t = field_depth_t
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
  let update_depths field_depths : unit State.t =
    State.modify @@ 
      ID_Map.union
        (fun _ c1 c2 -> Some(max c1 c2))
        field_depths

  (**
    Walk the AST for a particular {{!Layout.Types.simple_type} simple_type},
    keeping track of the overal depth of the type
    and associating any record types we encounter
    with the new depth witnessed.
  *)
  let rec visit_type : simple_type -> int State.t =
    function
    | TRec record ->
      let* field_depths = record |> traverse (fun (lbl, ty) -> 
        let+ depth = visit_type ty in (lbl, depth)) 
      in
      let field_depths' = field_depths |> List.to_seq |> ID_Map.of_seq in
      let rec_depth = field_depths |> List.map snd |> List.fold_left max 0 in
      let+ () = update_depths field_depths'
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
  let rec visit_body : Ast.body -> unit State.t =
    function
    | BVal (VFun (_, expr)) -> visit_expr expr

    | BVal (VRec record) ->
      let field_depths =
        record |> List.map (fun (lbl, _) -> (lbl, 0))
               |> List.to_seq
               |> ID_Map.of_seq
      in update_depths field_depths

    | BMatch (_, branches) ->
      State.map ignore (
        branches |> traverse
          (fun (ty, expr) ->
            visit_type ty *>
            visit_expr expr)
      )

    | _ -> State.pure ()
  
  (**
    Visit the {{!Layout.Ast.body} body} associated with the clause.
  *)
  and visit_clause (Cl (_, body)) : unit State.t = 
    visit_body body

  (**
    Walk over the AST of the expression, visiting
    each {{!Layout.Ast.clause} clause}.
  *)
  and visit_expr expr : unit State.t =
    traverse visit_clause expr *>
    State.pure ()
        
  (**
    The main function exported by this module.
    From the provided [ast], compute the required
    depths needed for matching, and also incorporate
    subtype information to provide a sound, complete
    set of constraints.
  *)
  let find_required_depths (ast : Ast.expr) =
    fst (visit_expr ast ID_Map.empty)

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
    | Original (** Indicating values which have no program point source. *)
    | Source of Ast.ident (** Indicating values which have the source associated. *)

  (**
    RValues paired with a {{!flow_tag} flow_tag}
  *)
  module Wrapper = WriterF(struct
    type t = flow_tag
  end)

  type nonrec avalue = context Ast.avalue Wrapper.t
  type nonrec avalue_spec = context Ast.avalue

  (**
    For use in the cache. A mapping from the call context
    to the set of closure environments to be used.

    We also include the program point
    idenfitying the function in the AST which
    the environment we look up should be associated with,
    so that we don't combine bogus function/environment pairs.
    
    Note this is subtly different from always using a k >= 1
    for the context size; it essentially allows looking forward
    to what the _next_ context will be once we call the function.
  *)
  module Context_Map = Map.Make(struct
    type t = ident * context
    let compare = Stdlib.compare
  end)

  (**
    For use in the cache. 
    
    We track the environments which
    have been seen at a callsite, and can abort if we've already
    tried the current environment and have not updated the store
    in the meantime.
  *)
  module Env_Set = Set.Make(struct
    type t = avalue ID_Map.t
    let compare = Stdlib.compare
  end)

  (**
    The type used for our state.

    We cache all function call program point return values
    in order to allow recursion to terminate properly even
    on abstract values/matching.
  *)
  type flow_state =
    {
      data_flow : ID_Set.t ID_Map.t;          (** The data dependency graph *)
      type_flow : Type_Set.t ID_Map.t;        (** Runtime type observations *)
      field_depths : Matching.field_depth_t;  (** The match depths used     *)
      sensitivity : int;
        (** `k` parameter to determine context sensitivity *)
    }

  (**
    The type of each individual thread's
    state in execution (essentially, state which is local
    to the stack and used depth-first)
  *)
  type thread_state =
    {
      cache : Env_Set.t Context_Map.t;
        (** Cache of function call & record environments *)

      seens : (int * Env_Set.t) Context_Map.t;
        (** Memory of already-processed closure environments *)

      version : int;
        (** Lets us know when the cache is invalidated *)

      context : context;     (** The call stack. *)
      env : avalue ID_Map.t; (** Values in scope. *)
    }

  module AState = NCoWS_Util
    (struct type t = flow_state   end)
    (struct type t = thread_state end)
    (ListMonoid(Strings))
  
  open AState.Syntax

  module Lists = struct
    include Lists
    include Traversable_Util(Lists)
    include Make_Traversable(AState)
  end

  module ID_Map = struct
    include ID_Map
    include Traversable_Util(Maps(ID_Map))
    include Make_Traversable(AState)
  end

  (** 
    {!protect} + mapping over a monadic action. 
    (like {{!Layout.Classes.Functor_Util.Syntax.val-let+} let+}) 
  *)
  let ( let$+ ) v f : _ AState.t =
    v >>= (fun v ->
      try AState.pure (f v) with
      Match_failure _ ->
        AState.raise Type_Mismatch
    )

  (** 
    {!protect} + binding a monadic action. 
    (like {{!Layout.Classes.Monad_Util.Syntax.val-let*} let*})
  *)
  let ( let$* ) v (f : _ -> _ AState.t) : _ AState.t =
    v >>= (fun v ->
      try f v with
      Match_failure _ ->
        AState.raise Type_Mismatch
    )

  (** 
    Convenience operator to tag an {!avalue} with the {!constructor-Original} tag. 
  *)
  let original (av : avalue_spec) : avalue AState.t =
    AState.pure (Original, av)

  (**
    Convenience operator to re-tag an {!avalue} with the given {!constructor-Source}.
  *)
  let retag_avalue id : avalue -> avalue =
    fun (_, av) -> (Source(id), av)

  
  (**
    Convenience operator to resolve a single record field to
    a nondeterministic possibility, for projection.
  *)
  let resolve_field (ctx, id) : avalue AState.t =
    let* { cache; _ } = AState.get' in
    let* env = 
      Context_Map.find ("$", ctx) cache
      |> Env_Set.elements
      |> AState.pures
    in
      ID_Map.find_opt id env 
      |> AState.of_option
      
  (**
    Convenience operator to resolve a record to a particular
    nondeterministic possibility, mostly to get its type.
  *)
  let resolve_record (av : avalue) : avalue ID_Map.t AState.t =
    match Wrapper.extract av with
    | ARec arec -> ID_Map.traverse resolve_field arec  
    | _ -> AState.raise Type_Mismatch

  (**
    Convenience operator to project a record field.
  *)
  let project_field (av : avalue) lbl : avalue AState.t =
    match Wrapper.extract av with
    | ARec arec ->
        let* field = ID_Map.find_opt lbl arec |> AState.of_option in
        resolve_field field

    | _ ->
      AState.raise Type_Mismatch


  (**
    The runtime type of the avalue, computed
    only as deeply as is required by the shape depths provided.
    Nondeterministic in the case of records!
  *)
  let rec type_of ?(depth=Int.max_int) (av : avalue)  : simple_type AState.t =
    canonicalize_simple <$>
    if depth = 0 then AState.pure TUniv else
    match Wrapper.extract av with
    | AInt _         -> AState.pure TInt
    | ABool `T       -> AState.pure TTrue
    | ABool `F       -> AState.pure TFalse
    | AFun (_, _, _) -> AState.pure TFun
    | ARec record ->
        let* { field_depths; _ } = AState.get in
        let+ record' = record 
          |> ID_Map.mapi (fun lbl field ->
            let depth' = ID_Map.find lbl field_depths in
            let* av' = resolve_field field in
              type_of ~depth:(min depth' (depth - 1)) av') 
          |> ID_Map.sequence
        in
          TRec ( ID_Map.bindings record' )  



  (**
    Look up an avalue by name in the environment
  *)
  let lookup id : avalue AState.t =
    let* { env; _ } = AState.get' in
    match ID_Map.find_opt id env with
    | Some(v) -> AState.pure v
    | None -> 
        AState.tell [Format.sprintf "lookup failed: %s" id] *> 
        AState.raise Open_Expression

  (**
    Look up an avalue, and then {{!Layout.Classes.Comonad.extract} unwrap} it
    so we don't have to pattern match on the tag etc.
  *)
  let lookup' id : avalue_spec AState.t = 
    Wrapper.extract <$> lookup id

  (**
    Helper to add the current environment to the set of
    witnessed environments for a particular closure id.
    For records, the id used is "$" so as not to conflict.
  *)
  let register_env_for id : unit AState.t =
    let* { env; context; cache; _ } = AState.get' in
    let envs', already_seen =
      match Context_Map.find_opt (id, context) cache with
      | None      -> Env_Set.singleton env, false
      | Some envs -> Env_Set.add env envs, Env_Set.mem env envs
    in
    AState.tell [
      Format.asprintf "env for %s @[<h>%a@] already seen: %s"
        id 
        Ast.pp_context context
        (string_of_bool already_seen);
      Format.sprintf "number of envs for %s: %d" id (Env_Set.cardinal envs');
    ] *>
    AState.modify' (fun t -> { t with
      version =
        if already_seen 
        then t.version 
        else t.version + 1;

      cache = t.cache |>
        Context_Map.add (id, context) envs'
    })

  

  let rec take k =
    function
    | x::xs when k > 0 -> x :: take (k - 1) xs
    | _ -> []


  let enter_closure pp ctx (id, av) (ma : 'a AState.t) : 'a AState.t =
    let* { sensitivity; _ } = AState.get in
    AState.yield *>
    let* { version; cache; seens; context; _ } = AState.get' in
    Format.printf "%s %a (%d)@." id pp_context context version;
    AState.tell [
      Format.sprintf "looking up env for %s" id
    ] *>
    let* closure =
      Context_Map.find_opt (id, ctx) cache
      |> Option.value ~default:(Env_Set.empty)
      |> Env_Set.elements
      |> AState.pures
    in
    let env = ID_Map.add id av closure in
    let context = take sensitivity (pp :: context) in
    AState.tell [
      Format.asprintf "call env for %s in @[<h>%a@]"
        id Ast.pp_context context
    ] *>
    match Context_Map.find_opt (id, ctx) seens with
    | None ->
        ma |> AState.control'
        (fun t -> { t with
          env; context;
          seens = t.seens
            |> Context_Map.add (id, ctx) (t.version, Env_Set.singleton env);
        })
        (fun t t' -> { t with
          version = t'.version;
          cache = t'.cache;
        })

    | Some (v, _) when v < version ->
        ma |> AState.control'
        (fun t -> { t with
          env; context;
          seens = t.seens
            |> Context_Map.add (id, ctx) (t.version, Env_Set.singleton env);
        })
        (fun t t' -> { t with
          version = t'.version;
          cache = t'.cache;
        })
        
    | Some (_, envs) when not (Env_Set.mem env envs) ->
        ma |> AState.control'
        (fun t -> { t with
          env; context;  
          seens = t.seens
            |> Context_Map.add (id, ctx) (t.version, Env_Set.add env envs);
        })
        (fun t t' -> { t with
          version = t'.version;
          cache = t'.cache;
        })

    | _ ->
      AState.tell [Format.sprintf "cut off eval for %s\n" id] *>
      AState.empty

  (**
    Perform any updates to the dependency graph and
    type observations which should result from
    the provided program point receiving the given
    rvalue as input.
  *)
  let register_flow dest (av : avalue) : unit AState.t =
    let (origin, _) = av in
    let update_dflow flow =
      match origin with
      | Original    -> flow
      | Source(src) -> flow |> ID_Map.update dest
        (function
        | Some (os) -> Some (ID_Set.add src os)
        | None      -> Some (ID_Set.singleton src)
        )
    in
    let update_tflow rt f =
      f |> ID_Map.update dest
        (function
        | Some (ts) -> Some (Type_Set.add rt ts)
        | None      -> Some (Type_Set.singleton rt)
        )
    in
    AState.ignore @@
    let* rt = type_of av in
    AState.modify (fun s -> {s with 
      data_flow = update_dflow s.data_flow;
      type_flow = update_tflow rt s.type_flow;
    })

  (**
    Convert a given {!type-Layout.Ast.value} into an rvalue
  *)
  let eval_value v : avalue AState.t =
    match v with
    | VInt 0             -> original @@ AInt `Z
    | VInt i when i > 0  -> original @@ AInt `P
    | VInt _ (* i < 0 *) -> original @@ AInt `N

    | VTrue  -> original @@ ABool `T
    | VFalse -> original @@ ABool `F

    | VFun (id, expr) ->
        let* () = register_env_for id in
        let* { context; _ } = AState.get' in
        original @@ AFun (context, id, expr)

    | VRec record ->
        let* () = register_env_for "$" in
        let* { context; _ } = AState.get' in
        let record' = record
          |> List.to_seq
          |> ID_Map.of_seq
          |> ID_Map.map (fun id -> (context, id)) 
        in
        original @@ ARec record'

  (**
    Evaluate a given {!type-Layout.Ast.operator} expression.
  *)
  let [@warning "-8"] eval_op o : avalue AState.t =
    match o with
    | OPlus (i1, i2) ->
        let$* AInt r1 = lookup' i1 in
        let$* AInt r2 = lookup' i2 in
        begin match r1, r2 with
        | a, `Z | `Z, a -> original @@ AInt a
        | `P, `P        -> original @@ AInt `P
        | `N, `N        -> original @@ AInt `N
        | _ -> AState.pures 
          [AInt `N; AInt `Z; AInt `P] >>= original
        end

    | OMinus (i1, i2) ->
        let$* AInt r1 = lookup' i1 in
        let$* AInt r2 = lookup' i2 in
        begin match r1, r2 with
        | a, `Z | `Z, a -> original @@ AInt a
        | `P, `N        -> original @@ AInt `P
        | `N, `P        -> original @@ AInt `N
        | _ -> AState.pures 
          [AInt `N; AInt `Z; AInt `P] >>= original
        end

    | OLess (i1, i2) ->
        let$* AInt r1 = lookup' i1 in
        let$* AInt r2 = lookup' i2 in
        begin match r1, r2 with
        | `N, `Z | `N, `P | `Z, `P          -> original @@ ABool `T
        | `Z, `N | `P, `N | `P, `Z | `Z, `Z -> original @@ ABool `F
        | _ -> AState.pures [ABool `T; ABool `F] >>= original
        end

    | OEquals (i1, i2) ->
        let$* AInt r1 = lookup' i1 in
        let$* AInt r2 = lookup' i2 in
        begin match r1, r2 with
        | `Z, `Z -> original @@ ABool `T
        | `N, `P | `P, `N
        | `Z, `P | `P, `Z
        | `Z, `N | `N, `Z -> original @@ ABool `F
        | _ -> AState.pures [ABool `T; ABool `F] >>= original
        end

    | OAnd (i1, i2) ->
        let$* ABool r1 = lookup' i1 in
        let$* ABool r2 = lookup' i2 in
        begin match r1, r2 with
        | `T, r -> original @@ ABool r
        | `F, _ -> original @@ ABool `F
        end

    | OOr (i1, i2) ->
        let$* ABool r1 = lookup' i1 in
        let$* ABool r2 = lookup' i2 in
        begin match r1, r2 with
        | `F, r -> original @@ ABool r
        | `T, _ -> original @@ ABool `T
        end

    | ONot (i1)  ->
        let$* ABool r1 = lookup' i1 in
        begin match r1 with
        | `T -> original @@ ABool `F
        | `F -> original @@ ABool `T
        end

    | OAppend (id1, id2) ->
        let$* ARec _r1 = lookup' id1 in
        let$* ARec _r2 = lookup' id2 in
        original @@ ARec (
          ID_Map.union (fun _ _av1 av2 -> Some(av2)) _r1 _r2
        )

  (**
    Evaluate a {{!Layout.Ast.body.BProj} projection} expression.
  *)
  let [@warning "-8"] eval_proj id lbl : avalue AState.t =
    let$* ARec record = lookup' id in
    match ID_Map.find_opt lbl record with
    | None       -> AState.raise Type_Mismatch
    | Some field -> resolve_field field
    

  (**
    Evaluate an {{!Layout.Ast.body.BApply} application} expression.
  *)
  let rec eval_apply pp id1 id2 =
    begin [@warning "-8"]
      let$* AFun (ctx, id, expr) = lookup' id1 in
      let* v2 = lookup id2 in
      let* () = register_flow id v2
      in
        enter_closure pp ctx 
          (id, retag_avalue id v2)
          (eval_f expr)
    end

  (**
    Evaluate the {{!Layout.Ast.body} body} of a clause.
  *)
  and eval_body pp =
    function
    | BVar id -> lookup id
    | BVal v -> eval_value v
    | BOpr o -> eval_op o
    | BProj (id, lbl) -> eval_proj id lbl
    | BApply (id1, id2) -> eval_apply pp id1 id2

    | BMatch (id, branches) ->
        let* v1 = lookup id in
        let* ty = AState.unique (type_of v1) in
        let* branch = AState.unique @@
          match
            branches
            |> List.find_opt (fun (pat, _) -> is_subtype_simple ty pat)
          with
          | None -> AState.raise Match_Fallthrough
          | Some((_, expr')) -> AState.pure expr'
        in
        Format.printf ": %a ~> %d@." pp_simple_type ty (Hashtbl.hash branch);
        eval_f branch

  (**
    Evaluate an {{!Layout.Ast.expr} expression}.
  *)
  and eval_f (expr : Ast.expr) =
    match expr with
    | [] -> raise Empty_Expression
    | Cl (id, body) :: cls ->
    (* Format.printf "%s\n" id; *)
    let* body_value  = eval_body id body in
    let  body_value' = retag_avalue id body_value in
    let* () = register_flow id body_value in
    let* () = AState.modify' (fun t -> { t with
      env = ID_Map.add id body_value' t.env;
    })
    in if cls = []
    then AState.pure body_value'
    else eval_f cls

  (**
    Entrypoint to the other evaluation functions;
    This sets up the initial state as required
    (Including calling {!Matching.find_required_depths}).
  *)
  let eval ?(k=0) expr =

    AState.eval (eval_f expr) {
      data_flow = ID_Map.empty;
      type_flow = ID_Map.empty;
      field_depths = Matching.find_required_depths expr;
      sensitivity = k;
    } {
      version = 0;
      cache = Context_Map.empty;
      seens = Context_Map.empty;
      env = ID_Map.empty;
      context = [];
    }

end

(**
  A small module to enclose the functionality
  required regarding unification of program point types
  and closure over the data dependency graph.
  In so doing we also create a representation of union types
  in the form of ordered sets of {!Types.simple_type}s.
*)
module Typing = struct

  type fold_t = {
    next_tid: int;
    next_uid: int;
    
    type_to_id: int Type_Map.t;
    id_to_type: simple_type Int_Map.t;

    union_to_id: int Int_Set_Map.t;
    id_to_union: Int_Set.t Int_Map.t;
  }

  (**
    Given an existing assignment of
    union types (in the form of {!Util.Type_Set.t}) to program
    points, produces a pair of mappings
    - from type IDs ({!int}s) to union types ({!Util.Type_Set.t}),
    - from program points to type IDs.
  *)
  let assign_unique_type_ids
    (type_flow : Type_Set.t ID_Map.t) =
    let initial = {
      next_tid = 1;
      next_uid = 1;

      type_to_id  = Type_Map.singleton    TUniv         0;
      union_to_id = Int_Set_Map.singleton Int_Set.empty 0;

      id_to_type  = Int_Map.singleton 0 TUniv;
      id_to_union = Int_Map.singleton 0 Int_Set.empty;

    } in
    initial |> ID_Map.fold (fun _ ts s ->
      let (is, s) = (Int_Set.empty, s) |> Type_Set.fold
        (fun ty (ts', s) ->
          match Type_Map.find_opt ty s.type_to_id with
          | Some(i) -> Int_Set.add i ts', s
          | None    -> Int_Set.add s.next_tid ts',
            { s with
              next_tid   = s.next_tid + 1;
              type_to_id = Type_Map.add ty s.next_tid s.type_to_id;
              id_to_type = Int_Map.add s.next_tid ty s.id_to_type;  
            }
        ) ts
      in
      match Int_Set_Map.find_opt is s.union_to_id with
      | Some(_) -> s
      | None ->
        { s with
          next_uid    = s.next_uid + 1;
          union_to_id = Int_Set_Map.add is s.next_uid s.union_to_id;
          id_to_union = Int_Map.add s.next_uid is s.id_to_union;
        }
    ) type_flow


  (**
    Simple type closure treating the dependency graph
    as undirected. This takes in the data dependencies
    and the observed types, and produces a more generalized
    mapping of program points to union types which ensures
    the types will be compatible across dependent program points.

    This simple algorithm merely performs union-find over
    every edge in the graph, building up a set of simple
    types in the process.
  *)
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


  type inferred_types_t = { 
    type_to_id: int Type_Map.t;
    id_to_type: simple_type Int_Map.t;

    union_to_id: int Int_Set_Map.t;
    id_to_union: Int_Set.t Int_Map.t;

    pp_to_union_id: int ID_Map.t;
  }

  (**
    Given type and data dependency information, 
    compute the dependency closure and thereby a pair of mappings from
    - type IDs ({!int}s) to {i ordered} unions ({!Types.simple_type}{!type-list}s)
    - program points to type IDs.

    The ordering of the union lists defines the tag which will
    be assigned to each {!Types.simple_type} which is a member.
  *)
  let assign_program_point_types
    (data_flow : ID_Set.t ID_Map.t)
    (type_flow : Type_Set.t ID_Map.t) =
    let type_flow' = type_flow_closure data_flow type_flow in
    let { type_to_id;  id_to_type; union_to_id; id_to_union; _ } 
      : fold_t = assign_unique_type_ids type_flow' 
    in
    let convert_type_set ts =
      Type_Set.fold (fun ty is ->
          Int_Set.add (Type_Map.find ty type_to_id) is) ts Int_Set.empty
    in
    {
      type_to_id;  id_to_type;
      union_to_id; id_to_union;
      
      pp_to_union_id =
        ID_Map.map (fun t -> Int_Set_Map.find
          (convert_type_set t) union_to_id) type_flow'
    }

end

(**
  Once a universe of ordered union types has been established,
  this module pre-computes tables for performing O(1) record
  re-tagging and match branch choices. These provide (some of) the primary
  runtime speed improvements over the untagged interpretation strategy.
*)
module Tagging = struct

  (**
    The data we build up and output. Here, the state monad
    is used for convenience to form a very general fold over
    the AST to find all match and record usages.
  *)
  type tag_state =
    {
      match_tables : int Type_Tag_Map.t ID_Map.t;
      (**
        For each match program point: 
        a mapping from union type tag to branch taken.
      *)
      
      record_tables : type_tag Field_Tags_Map.t ID_Map.t;
      (**
        For each record construction program point:
        a mapping from per-field union type tags
        to the resulting union type tag for the record.
      *)
      
      append_tables : type_tag Type_Tag_Pair_Map.t ID_Map.t;
      (**
        For each record append program point:
        a mapping from the lhs and rhs type tags to
        the resulting record's appropriate type tag.
      *)
    }
  

  (**
    Using the Reader-Writer-State monad stack
    for convenience of separating the input
    and state data types. We don't need the Writer
    functionality so we stub in the unit monoid.
  *)
  module State = RWS_Util
    (struct type t = Typing.inferred_types_t end)
    (UnitM)
    (struct type t = tag_state end)

  open State.Syntax
  
  open Traversable_Util(Lists)
  open Make_Traversable(State)
  
  (**
    Lookup the union ID associated to a program point.
  *)
  let union_id_of (pp : ident) : int State.t =
    let+ pp_unions = State.asks (fun s -> s.pp_to_union_id) in
    (*
      If the program point has no assigned type,
      it effectively is of type bottom, since no value
      ever entered that program point at runtime.
      This implies our representation of the "bottom"
      type is merely the empty union type.
      We reserve type ID 0 for this purpose.
    *)
    ID_Map.find_opt pp pp_unions 
    |> Option.value ~default:0

  (**
    Lookup the union id and associated set of type ids
    for a particular program point.
  *)
  let union_of' (pp : ident) : (int * Int_Set.t) State.t =
    let* uid = union_id_of pp in
    let+ { id_to_union; _ } = State.ask in
    (uid, Int_Map.find uid id_to_union)
  
  (**
    Lookup the union of types associated with
    a program point.
  *)
  let union_of (pp : ident) : Int_Set.t State.t = 
    snd <$> union_of' pp

  (**
    Get the unique {!Types.simple_type} associated
    with the given type tag.
  *)
  let type_of_tag (Tag tag) : simple_type State.t =
    let+ { id_to_type; _ } = State.ask in
    id_to_type |> Int_Map.find tag

  (**
    Get a list of all tags which represent
    entries in the union type specified by an ID.
  *)
  let tags_of_union (uid : union_id) : type_tag list State.t =
    let+ { id_to_union; _ } = State.ask in
    id_to_union
      |> Int_Map.find uid
      |> Int_Set.elements
      |> List.map (fun tid -> Tag tid)

  (** 
    A helper function for finding the first
    index within a list which satisfies a criterion.
    If no index does, the [default] is returned.
  *)
  let first_where ~default f tys ty =
    tys |> List.mapi (fun i t -> (i, t))
        |> List.find_opt (fun (_, t) -> f ty t)
        |> Option.map fst
        |> Option.value ~default
        
  (**
    Finds the first index within a list of patterns
    which the given simple type would match.
  *)
  let find_matching tys ty =
    first_where is_subtype_simple tys ty

  (**
    Finds the first index within a union type
    which the given simple type is an instance of.
  *)
  let find_retagging tys ty =
    first_where is_instance_simple tys ty


  (**
    Traverse each of the clauses in the expression
    to find record constructors and match usages.
  *)
  let rec visit_expr e : unit State.t =
    traverse visit_clause e *>
    State.pure ()

  (**
    Determine whether the clause is of interest.
    Clauses which are record constructions,
    match statements, or function values are interesting
    as they contain and/or are directly a place
    for us to produce a lookup table.
  *)
  and visit_clause (Cl (pp, body)) =
    match body with
    | BVal (VRec record)    -> process_record pp record
    | BVal (VFun (_, expr)) -> visit_expr expr

    | BOpr (OAppend (i1, i2)) -> process_append pp i1 i2

    | BMatch (id, branches) ->
        traverse (fun (_, expr) -> visit_expr expr) branches *>
        process_match pp id branches

    | _ -> State.pure ()

  (**
    Create the record append lookup table
    for the given program point and appended records.
  *)
  and [@warning "-8"] process_append (pp : ident) (i1 : ident) (i2 : ident) =
    let* ppu_id = union_id_of pp
    and+ i1u_id = union_id_of i1
    and+ i2u_id = union_id_of i2 in

    let* pp_tags = tags_of_union ppu_id
    and+ i1_tags = tags_of_union i1u_id
    and+ i2_tags = tags_of_union i2u_id in

    let* pp_types = traverse type_of_tag pp_tags in

    let* tag_maps = i1_tags |> traverse (fun t1 ->
      let* TRec ty1 = type_of_tag t1 in
      let ty1' = ty1 |> List.to_seq |> ID_Map.of_seq in

      i2_tags |> traverse (fun t2 ->
        let+ TRec ty2 = type_of_tag t2 in
        let ty2' = ty2 |> List.to_seq |> ID_Map.of_seq in
        
        let ty' = TRec (
          ID_Map.union (fun _ _ t2 -> Some(t2)) ty1' ty2'
          |> ID_Map.bindings
        ) in
        
        let t_ix = find_retagging pp_types ty' ~default:(-1) in
        if t_ix != -1 then
          Type_Tag_Pair_Map.singleton (t1, t2) (List.nth pp_tags t_ix)
        else
          Type_Tag_Pair_Map.empty
      )

    ) in
    let table = tag_maps
      |> List.flatten
      |> List.fold_left
      (Type_Tag_Pair_Map.union (fun _ _ _ -> None)) (* safe, these are disjoint *)
        Type_Tag_Pair_Map.empty
    in
    State.modify (fun s -> { s with 
      append_tables = s.append_tables
        |> ID_Map.add pp table
    })


  (**
    Create the record construction lookup table
    for the given program point and record definition.
  *)
  and process_record (pp : ident) (record : (label * ident) list) =
    let* records = record 
      |> traverse (fun (lbl, elt) ->
          let* elt_uid  = union_id_of elt in
          let+ elt_tags = tags_of_union elt_uid in
          List.map (fun tag -> (lbl, tag)) elt_tags)
    in
    let records =
      let open! Make_Traversable(Lists) in
      sequence records (* transpose the list of lists *)
      |> List.map (fun r -> ID_Map.of_seq (List.to_seq r))
    in
    let* pp_uid = union_id_of pp in
    let* pp_tags = tags_of_union pp_uid in
    let* pp_types = traverse type_of_tag pp_tags in
    let* field_maps =
      records |> traverse @@ fun record ->
        let+ rty =
          ID_Map.bindings record |> traverse (fun (lbl, tag) ->
            let+ ty = type_of_tag tag in (lbl, ty)) 
        in
        let t_ix = find_retagging ~default:(-1) pp_types (TRec rty) in
        if t_ix != -1 then
          Field_Tags_Map.singleton record (List.nth pp_tags t_ix)
        else
          Field_Tags_Map.empty
    in
    let field_map =
      field_maps |> List.fold_left
        (Field_Tags_Map.union (fun _ _ _ -> None)) (* safe, the maps are disjoint. *)
        Field_Tags_Map.empty
    in
    State.modify (fun s -> { s with 
      record_tables = s.record_tables
        |> ID_Map.add pp field_map
    })

  (**
    Create the match branch lookup table 
    for the given match expression.
  *)
  and process_match (pp : ident) (id : ident) branches : unit State.t =
    let* id_uid = union_id_of id in
    let* id_tags = tags_of_union id_uid in
    let branch_tys = List.map fst branches in
    let* branch_maps =
      id_tags |> traverse (fun tag ->
        let+ ty = type_of_tag tag in
        Type_Tag_Map.singleton tag (find_matching ~default:(-1) branch_tys ty)) in
    let branch_map =
      branch_maps |> List.fold_left
        (Type_Tag_Map.union (fun _ _ _ -> None)) (* safe, the maps are disjoint. *)
        Type_Tag_Map.empty 
    in
    State.modify (fun s -> { s with
      match_tables = s.match_tables
        |> ID_Map.add pp branch_map
    })
  
  (**
    Given an expression and type information for it,
    compute all the necessary record and match related
    lookup tables for a tagged runtime.
  *)
  let compute_tag_tables inferred_types (expr : Ast.expr) =
    let (tag_state, _, ()) =
      visit_expr expr inferred_types
      {
        record_tables = ID_Map.empty;
        append_tables = ID_Map.empty;
        match_tables = ID_Map.empty;
      }
    in
      tag_state

end


(**
  A record of all the data which is collected
  over each of the previous phases of analysis.
*)
type full_analysis =
  {
    flow : FlowTracking.flow_state;       (** Data dependencies. *)
    results: FlowTracking.avalue list;    (** Abstract Interpreter Output. *)
    log: string list;                     (** Debug log. *)
    inferred_types: Typing.inferred_types_t; (** Inferred types. *)
    match_tables: int Type_Tag_Map.t ID_Map.t; (** Match lookup tables. *)
    record_tables: type_tag Field_Tags_Map.t ID_Map.t; (** Record lookup tables. *)
    append_tables : type_tag Type_Tag_Pair_Map.t ID_Map.t; (** Record append tables. *)
  }

(**
  Run each phase of analysis on the provided test case,
  returning the collection of results.
*)
let full_analysis_of ?(k=0) test_case =
  let (flow, log, results, _) = FlowTracking.eval ~k test_case in
  let inferred_types = Typing.assign_program_point_types
      flow.data_flow flow.type_flow
  in
  let Tagging.{ record_tables; match_tables; append_tables; } =
    Tagging.compute_tag_tables inferred_types test_case in
  {
    flow;
    log;
    results;
    inferred_types;
    match_tables;
    record_tables;
    append_tables;
  }
  

(**
  The interpreter which uses runtime type tag information
  to reduce overhead in pattern matching.
*)
module TaggedEvaluator = struct

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
    | Interpreters_Out_Of_Step

  (**
    RValues paired with a {{!Types.type_tag} type_tag}
  *)
  module RValue = RValue(WriterF(struct
    type t = Types.type_tag
  end))

  open RValue
  
  (**
    The only state we need in this case
    is the runtime environment.
  *)
  type eval_state =
    {
      env: rvalue env;
    }

  (**
    We also will require other inputs
    in the form of a {!full_analysis} of the expression.
  *)
  type eval_envt =
    full_analysis

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
        let* { field_depths; _ } = State.asks (fun s -> s.flow) in
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
    let+ { type_to_id; _ } = State.asks (fun s -> s.inferred_types) in
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
    let+ id_to_type = State.asks (fun s -> s.inferred_types.id_to_type) in
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
      (fun _ -> { env = env' })
      (fun s _ -> s)

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
      let+ { record_tables; _ } = State.ask in
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
      let+ { append_tables; _ } = State.ask in
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
    let$* { match_tables; _ } = State.ask in
    let* (tag, _) as rv = lookup id in
    let* typ = type_of rv in
    let tag_branch = match_tables
      |> ID_Map.find pp
      |> Type_Tag_Map.find tag
    in
    let typ_branch = branches
      |> List.mapi (fun i (pat, _) -> (i, pat))
      |> List.find (fun (_, pat) -> is_subtype_simple typ pat)
      |> fst
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
  let eval expr analysis : eval_state * Ast.rvalue' =
    let (s, _, a) = eval_t expr analysis { env = []; }
    in (s, RValue.unwrap a)

end


