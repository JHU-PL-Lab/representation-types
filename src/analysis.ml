(**
  Primary analysis tools.
*)

open Ast
open Classes
open Types
open Util


(**
  Exceptions which may be thrown during analysis.
  Under normal circumstances, none should occur; they
  indicate that the input program is malformed in some way.
*)
type exn +=
  | Open_Expression
  | Type_Mismatch
  | Match_Fallthrough
  | Empty_Expression

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
      State.pure () <* (
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
  Another simple analysis which enumerates the variables
  captured by all closures in the program, so that code
  generation can know what and when to store values
  inside the allocated closure structs.
*)
module Closures = struct

  (**
    A description of how a variable in scope is accessed.
  *)
  type variable_kind =
    | Local 
      (** 
        Variables which are either arguments to the current function,
        or allocated on the stack. Both have the same access syntax.
      *)
    | Available
      (**
        Variables which could be accessed from the captured environment
        within the current closure, but are not necessarily yet.
      *)
    | Captured
      (**
        Variables which need to be put into the closure for this function.
        This is a subset of those which are `Available`. 
      *)
    [@@deriving show { with_path = false }, eq, ord]

  type scope = variable_kind ID_Map.t

  (**
    The main result of this module, detailing which variables are
    in scope in each closure (named by their program point) and
    whether these variables are locally allocated or fetched from
    the lexically captured environment. We also collect for each
    closure what the final program point is, so that we can use
    this later to get the return type of the closure itself.
  *)
  type closure_info =
    {
      scope: scope;
      return: ident;
    }

  type closure_info_map = closure_info ID_Map.t

  type closure_state =
    {
      info: closure_info ID_Map.t;
      curr_scope: scope;
      curr_pp: ident;
    }

  (**
    For convenience to fold over the AST.
  *)
  module State = State_Util(struct
    type t = closure_state
  end)
  
  open State.Syntax
  
  open Traversable_Util(Lists)
  open Lists.Make_Traversable(State)

  let add_local id =
    State.modify (fun s -> { s with
      curr_scope = s.curr_scope |> ID_Map.add id Local;
      curr_pp    = id;
    })

  let use_var id =
    State.modify (fun s -> { s with
      curr_scope = s.curr_scope
        |> ID_Map.update id
          (function
          | Some Available -> Some Captured
          | Some other     -> Some other (* local variables stay local, captured stay captured. *)
          | _ -> raise Open_Expression
          )
    })

  let rec visit_expr expr =
    traverse visit_clause expr *>
    State.pure ()

  and visit_clause (Cl (id, body)) =
    visit_body id body *>
    add_local id

  and visit_body pp =
    function
    | BApply (i1, i2)
    | BOpr
      ( OPlus   (i1, i2)
      | OMinus  (i1, i2)
      | OLess   (i1, i2)
      | OEquals (i1, i2)
      | OAnd    (i1, i2)
      | OOr     (i1, i2)
      | OAppend (i1, i2)) ->
        use_var i1 *>
        use_var i2
        
    | BVar i1
    | BOpr (ONot i1) ->
        use_var i1

    | BMatch (id, branches) ->
        use_var id *>
        (branches |> List.map snd |> traverse visit_expr) *>
        State.pure ()

    | BVal (VRec rs) ->
        traverse use_var (List.map snd rs) *>
        State.pure ()

    | BVal (VFun (id, expr)) ->
        State.control
          (fun s    -> { s with 
             curr_scope = ID_Map.map (fun _ -> Available) s.curr_scope
          })
          (fun s s' -> { s' with 
            curr_pp = s.curr_pp;
            info = s'.info
              |> ID_Map.add pp { scope = s'.curr_scope; return = s'.curr_pp };
              
            curr_scope =
              ID_Map.merge
                (fun _ k1 k2 -> match k1, k2 with
                | Some Available, Some Captured -> Some Captured
                | Some other, _ -> Some other
                | _ -> None
                ) 
                s.curr_scope 
                s'.curr_scope;
          })
          begin
            add_local id *>
            visit_expr expr
          end
    
    | _ ->
      State.pure ()

  let get_closure_info expr =
    let (s, ()) = visit_expr expr { 
      curr_scope = ID_Map.empty;
      curr_pp    = "";
      info       = ID_Map.empty;
    } in
    s.info 
      |> ID_Map.add "__main" { scope = s.curr_scope; return = s.curr_pp }

end





(**
  A simple interpreter outfitted with a value-tagging
  scheme which allows tracking the flow of data between
  program points. This data flow captures the dependency
  graph we need in order to propagate the type information
  gathered.
*)
module FlowTracking = struct

  open Types

  (**
    The type of tag which we augment our RValue type with
    to facilitate the construction of the flow graph. 
  *)
  type flow_tag =
    | Original            (** Indicating values which have no program point source. *)
    | Source of Ast.ident (** Indicating values which have the source associated. *)
    [@@deriving show { with_path = false }, eq, ord]

  (**
    RValues paired with a {{!flow_tag} flow_tag}
  *)
  module Wrapper = WriterF(struct
    type t = flow_tag 
  end)

  type avalue_spec = context Ast.avalue [@@deriving eq, ord, show]
  type avalue      = flow_tag * avalue_spec [@@deriving eq, ord, show]

  (**
    A mapping from the call context
    to the closure/environment to be used.

    This helps finitize the state space of the interpretation.
  *)
  module Context_Map = Map.Make(struct
    type t = context [@@deriving ord]
  end)

  (**
    A set of abstracted values.
    Because the set of all abstract values is finite by design,
    so is the set of all Avalue_Set.t values. 

    In this abstract flow-tagging paradigm, single avalues
    are hardly used, as all environments and operations contain
    and operate upon these sets, as part of ensuring a complete
    sound analysis.
  *)
  module Avalue_Set = Set.Make(struct
    type t = avalue [@@deriving ord]
  end)

  let pp_aset =
    let open Set_Pretty(Avalue_Set) in
    pp_set pp_avalue

  (** Convenience alias *)
  type aset = Avalue_Set.t

  (**
    The type used for our state.

    We cache all function call program point return values
    in order to allow recursion to terminate properly even
    on abstract values/matching.
  *)
  type interp_state =
    {
      (* flow tracking related state *)
      data_flow    : ID_Set.t   ID_Map.t;     (** The data dependency graph *)
      type_flow    : Type_Set.t ID_Map.t;     (** Runtime type observations *)

      (* abstract cache state *)
      env_cache    : aset ID_Map.t Context_Map.t; (** Map from context to abstract environment *)
      env_version  : int Context_Map.t; (** Map from context to monotonically increasing integer, for cache invalidation *)
      
      pp_cache     : aset ID_Map.t;     (** Map from (memoized) program points to their last result set *)
      pp_version   : int ID_Map.t;      (** Map from (memoized) program points to the last used env version *)

      context      : context; (** Holds the current execution context (callsite program point stack)  *)
      version      : int;     (** Holds a number which increments every time we update an environment *)
    }

  (**
    The type used for holding our interpretation-related
    parameters, such as sensitivity, potential inlining during analysis,
    and whatever else might come up.
  *)
  type interp_parameters =
    {
      field_depths : Matching.field_depth_t;  (** The match depths used  *)
      sensitivity  : int;   (** `k` parameter to determine context sensitivity *)
      inlining     : int;   (** Akin to `k`, but preserves first `n` levels of context *)
    }

  (**
    The main state monad (+ reader/writer for immutable input and logging).
  *)
  module AState = RWS_Util
    (struct type t = interp_parameters end)
    (UnitM)
    (struct type t = interp_state end)

  (**
    The type of log results accumulated during execution of the
    abstract interpreter.
  *)
  type log_t = unit

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

  module Seqs = struct
    include Seqs
    include Traversable_Util(Seqs)
    include Make_Traversable(AState)
  end

  let aset_of v = Avalue_Set.singleton v

  (**
    Map a simple function operating on single abstract values
    to work on sets of abstract values instead. If any particular
    function call fails, it will be excluded from the resulting set.
  *)
  let ( let$+ ) v f = 
    let+ v = v in
    Avalue_Set.filter_map (fun v' -> 
        try Some(f v') with _ -> None) v

  (**
    Compute a simple function over a set of abstract values,
    where the function can be defined in terms of single value cases.
    If any particular case of calling the function throws an exception,
    it will simply propagate an empty set, and so not include that branch.
  *)
  let ( let$* ) v f =
    let* v = v in
    let+ asets = Avalue_Set.to_seq v
      |> Seqs.traverse (fun v' -> try f v' with _ -> AState.pure Avalue_Set.empty)
    in
      Seq.fold_left Avalue_Set.union Avalue_Set.empty asets

  (** 
    Convenience operator to tag an {!avalue} with the {!constructor-Original} tag. 
  *)
  let original (av : avalue_spec) : aset AState.t =
    AState.pure @@ Avalue_Set.singleton (Original, av)

  let original' (avs : avalue_spec list) : aset AState.t =
    avs |> List.map (fun av -> (Original, av))
        |> Avalue_Set.of_list
        |> AState.pure
  
  (**
    Convenience operator to re-tag an {!avalue} with the given {!constructor-Source}.
  *)
  let retag_avalue src : avalue -> avalue =
    fun (_, av) -> (src, av)

  let retag_aset src : aset -> aset =
    Avalue_Set.map (retag_avalue src)


  (**
    Look up an aset by name in the environment (with provided context)
  *)
  let lookup ctx id : aset AState.t =
    let+ { env_cache; _ } = AState.get in
    let env = Option.value (Context_Map.find_opt ctx env_cache) ~default:(ID_Map.empty) in
      Option.value (ID_Map.find_opt id env) ~default:(Avalue_Set.empty)

  (**
    Look up an aset by name in the environment (with the current default context)
  *)
  let lookup' id : aset AState.t =
    let* { context; _ } = AState.get in
    lookup context id

  (**
    Convenience operator to resolve a record to a particular
    nondeterministic possibility, mostly to get its type.
  *)
  let resolve_record (av: avalue) : avalue ID_Map.t list AState.t =
    match Wrapper.extract av with
    | ARec arec ->
      let+ map_of_lists = arec.fields_pp
        |> ID_Map.mapi (fun field field_pp ->
          let field_ctx = ID_Map.find field_pp arec.pp_envs in
          let+ field_val = lookup field_ctx field in
          field_val |> Avalue_Set.to_seq |> List.of_seq)
        |> ID_Map.sequence
      in
      let open! ID_Map.Make_Traversable(Lists) in
      sequence map_of_lists

    | _ -> 
      raise Type_Mismatch

  
  (**
    Convenience operator to project a record field.
  *)
  let project_field lbl (av: avalue) : aset AState.t =
    match Wrapper.extract av with
    | ARec arec ->
        let field_id  = ID_Map.find lbl arec.fields_id in
        let field_pp  = ID_Map.find lbl arec.fields_pp in
        let field_ctx = ID_Map.find field_pp arec.pp_envs in
        lookup field_ctx field_id
    | _ ->
      raise Type_Mismatch


  (**
    The runtime type of the avalue, computed
    only as deeply as is required by the shape depths provided.
    Nondeterministic in the case of records!
  *)
  let rec type_of ?(depth=Int.max_int) (av: aset) : Type_Set.t AState.t =
    let pure_single ty = AState.pure (Type_Set.singleton ty) in
    if depth = 0 then pure_single TUniv else
    let avalue_seq = Avalue_Set.to_seq av in
    let+ type_seq = avalue_seq |> Seqs.traverse (fun av ->
      match Wrapper.extract av with
      | AInt _         -> pure_single TInt
      | ABool `T       -> pure_single TTrue
      | ABool `F       -> pure_single TFalse
      | AFun (_, _, _) -> pure_single TFun
      | ARec arec ->
          let* { field_depths; _ } = AState.ask in
          let+ record = arec.fields_pp
            |> ID_Map.mapi (fun field _ ->
              let depth' = ID_Map.find field field_depths in
              let* av' = project_field field av in
              let+ type_set = type_of ~depth:(min depth' (depth - 1)) av' in
              type_set
                |> Type_Set.to_seq
                |> List.of_seq (* <- see below *)
                (* 
                  I wish I didn't have to do this conversion back to lists,
                  but unfortunately since they aren't a parametric type
                  OCaml's Set types can't be Traversable (or else I'd use them instead).
                *)
              ) 
            |> ID_Map.sequence
          in
          let open! ID_Map.Make_Traversable(Lists) in
          record
            |> sequence (* gets cartesian product of each field's possible types *)
            |> List.map (fun id_map ->
              canonicalize_simple @@  
                TRec (ID_Map.bindings id_map))
            |> Type_Set.of_list
    ) in
    Seq.fold_left
      Type_Set.union
      Type_Set.empty
      type_seq

  (**
    Perform any updates to the dependency graph and
    type observations which should result from
    the provided program point receiving the given
    avalue(s) as input.
  *)
  let register_flow dest aset : unit AState.t =
    let sources = aset 
      |> Avalue_Set.to_seq 
      |> Seq.filter_map (fun av ->
        let (origin, _) = av in
        match origin with
        | Original   -> None
        | Source src -> Some src
      )
      |> ID_Set.of_seq
    in
    let* () = AState.modify (fun s -> { s with 
      data_flow = s.data_flow
        |> ID_Map.update dest
        (function
        | Some src -> Some (ID_Set.union sources src)
        | None     -> Some sources
        );
    })
    in
    let* rt = type_of aset in
    AState.modify (fun s -> {s with 
      type_flow = s.type_flow
        |> ID_Map.update dest
        (function
        | Some ts -> Some (Type_Set.union rt ts)
        | None    -> Some rt
        );
    })

  let prune_context ctx : context AState.t =
    let+ { sensitivity; _ } = AState.ask in
    take sensitivity ctx

  let fresh_version : int AState.t =
    let* { version; _ } = AState.get in
    let+ () = AState.modify (fun s -> {s with version = version+1}) in
    version

  let add_to_env ctx id aset : unit AState.t =
    let* { env_cache; env_version; _ } = AState.get in
    match Context_Map.find_opt ctx env_cache with
    | None -> 
        let* v = fresh_version in
        AState.modify (fun s -> { s with 
          env_cache   = Context_Map.add ctx (ID_Map.singleton id aset) env_cache;
          env_version = Context_Map.add ctx v env_version;
        })
    | Some(env) ->
    match ID_Map.find_opt id env with
    | None ->
        let* v = fresh_version in
        AState.modify (fun s -> { s with
          env_cache   = Context_Map.add ctx (ID_Map.add id aset env) env_cache;
          env_version = Context_Map.add ctx v env_version; 
        })
    | Some(aset') ->
    let combined = Avalue_Set.union aset aset' in
    if Avalue_Set.equal combined aset' then
      AState.pure ()
    else
      let* v = fresh_version in
      AState.modify (fun s -> { s with
        env_cache   = Context_Map.add ctx (ID_Map.add id combined env) env_cache;
        env_version = Context_Map.add ctx v env_version;
      })

  let add_to_env' id aset : unit AState.t =
    let* { context; _ } = AState.get in
    add_to_env context id aset


  let add_all_to_env ctx ctx' : unit AState.t =
    let* { env_cache; _ } = AState.get in
    let env = Context_Map.find_opt ctx env_cache
      |> Option.value ~default:ID_Map.empty
    in
    let* _ = env 
      |> ID_Map.mapi (add_to_env ctx') 
      |> ID_Map.sequence 
    in
    AState.pure ()


  let call_closure ctx pp id aset (ma : aset AState.t) : aset AState.t =
    let* ctx' = prune_context (pp :: ctx) in
    
    (*
      Merge current environment into new one,
      allowing closure semantics to work.
    *)
    let* () = add_all_to_env ctx ctx' in

    let* () = add_to_env ctx' id aset in
    let* { env_version; pp_version; pp_cache; _ } = AState.get in
    let env_v = Context_Map.find ctx' env_version in
    match ID_Map.find_opt pp pp_version with
    | Some(pp_v) when pp_v = env_v ->
        AState.pure (Option.value ~default:Avalue_Set.empty @@ ID_Map.find_opt pp pp_cache) (* memoize this call *) 
    | _ ->
        let* () = register_flow id aset in
        let* a = ma |> AState.control
          (fun s    -> { s with 
              context    = ctx';
              pp_version = ID_Map.add pp env_v pp_version; 
          })
          (fun s s' -> { s' with 
              context = s.context;
          })
        in
        let+ () = AState.modify (fun s -> { s with
          pp_cache = s.pp_cache |> ID_Map.update pp
            (function
            | None    -> Some a
            | Some a' -> Some (Avalue_Set.union a a')
            );
        })
        in a

  let call_closure' pp id aset ma =
    let* { context; _ } = AState.get in
    call_closure context pp id aset ma

  (**
    Convert a given {!type-Layout.Ast.value} into an aset
  *)
  let eval_value pp v : avalue AState.t =
    match v with
    | VInt 0             -> AState.pure (Original, AInt `Z)
    | VInt i when i > 0  -> AState.pure (Original, AInt `P)
    | VInt _ (* i < 0 *) -> AState.pure (Original, AInt `N)

    | VTrue  -> AState.pure (Original, ABool `T)
    | VFalse -> AState.pure (Original, ABool `F)

    | VFun (id, expr) ->
        let+ { context; _ } = AState.get in
        Original, AFun (context, id, expr)

    | VRec record ->
        let+ { context; _ } = AState.get in
        let record_map = record |> List.to_seq |> ID_Map.of_seq in
        let record_pp = record_map |> ID_Map.map (fun _ -> pp) 
        in
        Original, ARec {
          fields_id = record_map;
          fields_pp = record_pp;
          pp_envs = ID_Map.singleton pp context;
        }

  (**
    Evaluate a given {!type-Layout.Ast.operator} expression.
  *)
  let [@warning "-8"] eval_op o : aset AState.t =
    match o with
    | OPlus (i1, i2) ->
        let$* _, AInt r1 = lookup' i1 in
        let$* _, AInt r2 = lookup' i2 in
        begin match r1, r2 with
        | a, `Z | `Z, a -> original @@ AInt a
        | `P, `P        -> original @@ AInt `P
        | `N, `N        -> original @@ AInt `N
        | _ -> original' [AInt `N; AInt `Z; AInt `P]
        end

    | OMinus (i1, i2) ->
        let$* _, AInt r1 = lookup' i1 in
        let$* _, AInt r2 = lookup' i2 in
        begin match r1, r2 with
        | a, `Z | `Z, a -> original @@ AInt a
        | `P, `N        -> original @@ AInt `P
        | `N, `P        -> original @@ AInt `N
        | _ -> original' [AInt `N; AInt `Z; AInt `P]
        end

    | OLess (i1, i2) ->
        let$* _, AInt r1 = lookup' i1 in
        let$* _, AInt r2 = lookup' i2 in
        begin match r1, r2 with
        | `N, `Z | `N, `P | `Z, `P          -> original @@ ABool `T
        | `Z, `N | `P, `N | `P, `Z | `Z, `Z -> original @@ ABool `F
        | _ -> original' [ABool `T; ABool `F]
        end

    | OEquals (i1, i2) ->
        let$* _, AInt r1 = lookup' i1 in
        let$* _, AInt r2 = lookup' i2 in
        begin match r1, r2 with
        | `Z, `Z -> original @@ ABool `T
        | `N, `P | `P, `N
        | `Z, `P | `P, `Z
        | `Z, `N | `N, `Z -> original @@ ABool `F
        | _ -> original' [ABool `T; ABool `F]
        end

    | OAnd (i1, i2) ->
        let$* _, ABool r1 = lookup' i1 in
        let$* _, ABool r2 = lookup' i2 in
        begin match r1, r2 with
        | `T, r -> original @@ ABool  r
        | `F, _ -> original @@ ABool `F
        end

    | OOr (i1, i2) ->
        let$* _, ABool r1 = lookup' i1 in
        let$* _, ABool r2 = lookup' i2 in
        begin match r1, r2 with
        | `F, r -> original @@ ABool  r
        | `T, _ -> original @@ ABool `T
        end

    | ONot (i1)  ->
        let$* _, ABool r1 = lookup' i1 in
        begin match r1 with
        | `T -> original @@ ABool `F
        | `F -> original @@ ABool `T
        end

    | OAppend (id1, id2) ->
        let$* _, ARec r1 = lookup' id1 in
        let$* _, ARec r2 = lookup' id2 in
        let merge m1 m2 = ID_Map.union (fun _ _ v2 -> Some(v2)) m1 m2 in
        original @@ ARec {
          fields_id = merge r1.fields_id r2.fields_id;
          fields_pp = merge r1.fields_pp r2.fields_pp;
          pp_envs   = merge r1.pp_envs   r2.pp_envs;  
        }

  (**
    Evaluate a {{!Layout.Ast.body.BProj} projection} expression.
  *)
  let [@warning "-8"] eval_proj id lbl : aset AState.t =
    let$* (_, ARec _) as av = lookup' id in
    project_field lbl av
    

  (**
    Evaluate an {{!Layout.Ast.body.BApply} application} expression.
  *)
  let rec eval_apply pp id1 id2 =
    begin [@warning "-8"]
      let$* _, AFun (ctx, id, expr) = lookup' id1 in
      let*  arg = lookup' id2 in
      call_closure ctx pp id arg
        (eval_f expr)
    end

  (**
    Evaluate the {{!Layout.Ast.body} body} of a clause.
  *)
  and eval_body pp =
    function
    | BVar id -> lookup' id
    | BVal v -> Avalue_Set.singleton <$> eval_value pp v
    | BOpr o -> eval_op o
    | BProj (id, lbl) -> eval_proj id lbl
    | BApply (id1, id2) -> eval_apply pp id1 id2
    
    | BInput -> original' @@ [AInt `N; AInt `Z; AInt `P]

    | BMatch (id, branches) ->
        let* v1 = lookup' id in
        let* tys = type_of v1 in
        let branches = tys 
          |> Type_Set.to_seq
          |> Seq.filter_map (fun ty ->
            branches
              |> List.find_opt (fun (pat, _) -> is_subtype_simple ty pat) 
          )
          |> List.of_seq
          |> List.sort_uniq compare (* TODO: make sure `compare` makes sense... I think so though *)
        in
        let+ results = branches |> Lists.traverse (fun (_, expr) -> eval_f expr) in
        List.fold_left
          Avalue_Set.union
          Avalue_Set.empty 
          results

  (**
    Evaluate an {{!Layout.Ast.expr} expression}.
  *)
  and eval_f (expr : Ast.expr) =
    match expr with
    | [] -> raise Empty_Expression
    | Cl (id, body) :: cls ->
    let* body_value  = eval_body id body in
    let* () = register_flow id body_value in
    let body_value' = retag_aset (Source id) body_value in
    let* () = add_to_env' id body_value' in 
    match cls with
    | [] -> AState.pure body_value'
    | _  -> eval_f cls

  (**
    Entrypoint to the other evaluation functions;
    This sets up the initial state as required
    (Including calling {!Matching.find_required_depths}).
  *)
  let eval ?(k=0) field_depths expr =
    eval_f expr {
      sensitivity  = k;
      inlining = 0;
      field_depths;
    } {
      data_flow = ID_Map.empty;
      type_flow = ID_Map.empty;
      
      env_cache   = Context_Map.empty;
      env_version = Context_Map.empty;

      pp_cache    = ID_Map.empty;
      pp_version  = ID_Map.empty;

      context = [];
      version = 0;
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
  let assign_unique_type_ids (type_flow : Type_Set.t ID_Map.t) =
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
  type tag_tables =
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
    (struct type t = tag_tables end)

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
      let* ty1 = type_of_tag t1 in
      let ty1 = match ty1 with
      | TRec ty1 -> ty1
      | _ -> raise Type_Mismatch
      in
      let ty1' = ty1 |> List.to_seq |> ID_Map.of_seq in

      i2_tags |> traverse (fun t2 ->
        let+ ty2 = type_of_tag t2 in
        let ty2 = match ty2 with
        | TRec ty2 -> ty2
        | _ -> raise Type_Mismatch
        in
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
    flow           : FlowTracking.interp_state; (** Data dependencies. *)
    results        : FlowTracking.aset;         (** Abstract Interpreter Output. *)
    log            : FlowTracking.log_t;        (** Debug log. *)
    field_depths   : Matching.field_depth_t;    (** Required depth for each record field *)
    inferred_types : Typing.inferred_types_t;   (** Inferred types. *)
    tag_tables     : Tagging.tag_tables;        (** Lookup tables for computing type tags fast *)
    closures       : Closures.closure_info_map  (** Information about captured values and returns of closures *)
  }

(**
  Run each phase of analysis on the provided test case,
  returning the collection of results.
*)
let full_analysis_of ?(k=0) expr =
  let field_depths = Matching.find_required_depths expr in
  let closures = Closures.get_closure_info expr in
  let (flow, log, results) = FlowTracking.eval ~k field_depths expr in
  let inferred_types = Typing.assign_program_point_types flow.data_flow flow.type_flow in
  let tag_tables = Tagging.compute_tag_tables inferred_types expr in
  {
    flow;
    log;
    results;
    field_depths;
    inferred_types;
    tag_tables;
    closures;
  }
  
