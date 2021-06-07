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
  A helper module to compute a mapping from program point
  names to their clauses (for example to lookup their exact definition.)
*)
module Clauses = struct

  let rec visit_clause cl map =
    let Cl (pp, body) = cl in
    let map' = ID_Map.add pp body map in
    match body with
    | BVal (VFun (_, expr)) -> visit_expr expr map'
    | BMatch (_, branches) ->
        List.fold_left (fun map (_, expr)-> visit_expr expr map) map' branches
    | _ ->
        map'

  and visit_expr expr map =
    List.fold_left
      (fun map cl -> visit_clause cl map) map expr

  let pp_to_body expr =
    let cs = ID_Map.empty in
    visit_expr expr cs

end



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
    | TRec (_, record) ->
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
        Variables which are allocated on the stack.
      *)
    | Argument
      (**
        Variables which are arguments to the current procedure.
        These may be pointers, or may not.
      *)
    | Self_closure
      (**
        The variable representing the current closure itself,
        which is always available for use as a recursion entry point.
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
      name: ident;
      scope: scope;
      return: ident;
      argument: ident option;
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

  let add_var kind id =
    State.modify (fun s -> { s with
      curr_scope = s.curr_scope |> ID_Map.add id kind;
      curr_pp    = id;
    })

  let use_var id =
    State.modify (fun s -> { s with
      curr_scope = s.curr_scope
        |> ID_Map.update id
          (function
          | Some Available -> Some Captured
          | Some other     -> Some other (* local variables stay local, captured stay captured. *)
          | _ ->
            begin
              Format.eprintf "Variable %s not found in scope: %a\n" id (pp_id_map pp_variable_kind) s.curr_scope;
              raise Open_Expression
            end
          )
    })

  let rec visit_expr expr =
    traverse visit_clause expr *>
    State.pure ()

  and visit_clause (Cl (id, body)) =
    visit_body id body *>
    begin
      Format.eprintf "adding_local_var %s (%a)\n" id pp_body' body;
      add_var Local id
    end

  and visit_body pp =
    function
    | BApply (i1, i2)
    | BOpr
      ( OPlus   (i1, i2)
      | OMinus  (i1, i2)
      | OTimes  (i1, i2)
      | OLess   (i1, i2)
      | OEquals (i1, i2)
      | OAnd    (i1, i2)
      | OOr     (i1, i2)
      | OAppend (i1, i2)) ->
        use_var i1 *>
        use_var i2

    | BVar i1
    | BOpr (ONot i1 | ONeg i1) ->
        use_var i1

    | BProj (i1, _) ->
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
            info = begin
              let new_info = {
                name     = pp;
                scope    = s'.curr_scope;
                return   = s'.curr_pp;
                argument = Some(id);
              }
              in
              s'.info
                |> ID_Map.add pp new_info
                |> ID_Map.add id new_info
            end;

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
            add_var Self_closure pp *>
            add_var Argument id *>
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
    s.info |> ID_Map.add "__main" {
      name     = "__main";
      scope    = s.curr_scope;
      return   = s.curr_pp;
      argument = None;
    }

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

  type avalue  = context Ast.avalue [@@deriving eq, ord, show]

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
  type tset = Type_Set.t

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
      env_cache    : (tset * aset) ID_Map.t Context_Map.t; (** Map from context to typed abstract environment *)
      env_version  : int Context_Map.t; (** Map from context to monotonically increasing integer, for cache invalidation *)

      type_cache   : simple_type Type_Map.t; (** Map from record names to shallow-ized record type memo *)

      pp_cache     : (tset * aset) ID_Map.t; (** Map from (memoized) program points to their last result set *)
      pp_version   : int ID_Map.t; (** Map from (memoized) program points to the last used env version *)

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

  (**
    Map a simple function operating on single abstract values
    to work on sets of abstract values instead. If any particular
    function call fails, it will be excluded from the resulting set.
  *)
  let ( let$+ ) v f =
    let+ (_t, v) = v in
    Avalue_Set.filter_map (fun v' ->
        try Some(f v') with _ -> None) v

  (**
    Compute a simple function over a set of abstract values,
    where the function can be defined in terms of single value cases.
    If any particular case of calling the function throws an exception,
    it will simply propagate an empty set, and so not include that branch.
  *)
  let ( let$* ) v f =
    let* (_t, v) = v in
    let+ asets = Avalue_Set.to_seq v
      |> Seqs.traverse (fun v' -> try f v' with _ -> AState.pure Avalue_Set.empty)
    in
      Seq.fold_left Avalue_Set.union Avalue_Set.empty asets




  (**
    Convenience operator to pair a pure value with a
    monadic computation (usually for pairing a source
    program point with a set of avalues).
  *)
  let with_src id ma =
    (fun a -> (id, a)) <$> ma

  let project_pp_of id lbl =
    id ^ "." ^ lbl

  (**
    Convenience operator to tag an {!avalue} with the {!constructor-Original} tag.
  *)
  let aset_of (av : avalue) : aset AState.t =
    av |> Avalue_Set.singleton
       |> AState.pure

  let aset_of_list (avs : avalue list) : aset AState.t =
    avs |> Avalue_Set.of_list
        |> AState.pure

  (**
    Look up an aset by name in the environment (with provided context)
  *)
  let lookup ctx id : (tset * aset) AState.t =
    let+ { env_cache; _ } = AState.get in
    let env = Option.value (Context_Map.find_opt ctx env_cache) ~default:(ID_Map.empty) in
      Option.value (ID_Map.find_opt id env) ~default:(Type_Set.empty, Avalue_Set.empty)

  (**
    Look up an aset by name in the environment (with the current default context)
  *)
  let lookup' id : (tset * aset) AState.t =
    let* { context; _ } = AState.get in
    lookup context id

  (*
    (**
      Convenience operator to resolve a record to a particular
      nondeterministic possibility, mostly to get its type.
    *)
    let resolve_record : avalue ->  avalue ID_Map.t list AState.t =
      function
      | ARec arec ->
        let+ map_of_lists = arec.fields_pp
          |> ID_Map.mapi (fun field field_pp ->
            let field_ctx = ID_Map.find field_pp arec.pp_envs in
            let+ (_, field_val) = lookup field_ctx field in
            field_val |> Avalue_Set.to_seq |> List.of_seq)
          |> ID_Map.sequence
        in
        let open! ID_Map.Make_Traversable(Lists) in
        sequence map_of_lists

      | _ ->
        raise Type_Mismatch
  *)


  (**
    Convenience operator to project a record field.
  *)
  let project_field lbl : avalue -> (tset * aset) AState.t =
    function
    | ARec arec ->
        begin try
          let field_id  = ID_Map.find lbl arec.fields_id in
          let field_pp  = ID_Map.find lbl arec.fields_pp in
          let field_ctx = ID_Map.find field_pp arec.pp_envs in
          lookup field_ctx field_id
        with
          | Not_found -> AState.pure
            (Type_Set.empty, Avalue_Set.empty)
        end

    | _ ->
      raise Type_Mismatch


  let rec shallow_type_of ?(remove_names=false) ?(depth=Int.max_int) ty =
    if depth <= 0 then AState.pure TUniv else
    match ty with
    | TRec (name, record) ->
      let* { field_depths; _ } = AState.ask in
      let name' = if remove_names then None else name in
      let+ record' = record
        |> Lists.traverse begin fun (field, field_ty) ->
          let depth' = ID_Map.find field field_depths in
          let+ ty' = shallow_type_of ~remove_names:true ~depth:(min depth' (depth - 1)) field_ty in
          (field, ty')
        end
      in TRec (name', record')
    | other ->
        AState.pure other

  let shallow_type_of ty =
    match ty with
    | TRec (_, _) ->
        let* { type_cache; _ } = AState.get in
        begin match Type_Map.find_opt ty type_cache with
        | Some(memoized_type) ->
            AState.pure memoized_type
        | exception _ | None ->
            let* sty = shallow_type_of ty in
            AState.modify (fun s -> { s with type_cache = Type_Map.add ty sty s.type_cache }) $>
            sty
        end

    | other ->
        AState.pure other

  (**
    The runtime type of the avalue, computed
    only as deeply as is required by the shape depths provided.
    Nondeterministic in the case of records!
  *)
  let type_of (av: aset) : Type_Set.t AState.t =
    let pure_single ty = AState.pure (Type_Set.singleton ty) in
    let avalue_seq = Avalue_Set.to_seq av in
    let+ type_seq = avalue_seq |> Seqs.traverse @@ fun av ->
      match av with
      | ABool `T       -> pure_single TTrue
      | ABool `F       -> pure_single TFalse
      | AInt _         -> pure_single TInt
      | AFun (_, _, _) -> pure_single TFun
      | ARec arec ->
          let* record = arec.fields_pp
            |> ID_Map.mapi begin fun field _ ->
              let+ (tys, _) = project_field field av in
              tys
                |> Type_Set.to_seq
                |> List.of_seq
                (* NOTE:
                  I wish I didn't have to do this conversion back to lists,
                  but unfortunately since OCaml's Set types aren't a parametric type
                  they can't be Traversable (or else I'd use them instead).
                *)
            end
            |> ID_Map.sequence
          in
          let open! ID_Map.Make_Traversable(Lists) in
          let+ record = record
            |> sequence (* gets cartesian product of each field's possible types *)
            |> Lists.traverse (fun id_map ->
              shallow_type_of @@
              canonicalize_simple @@
                TRec (Some arec.name, ID_Map.bindings id_map))
          in
            record |> Type_Set.of_list
    in
    Seq.fold_left
      Type_Set.union
      Type_Set.empty
      type_seq

  let with_type aset =
    let+ tset = type_of aset in
    (tset, aset)

  (**
    Perform any updates to the dependency graph and
    type observations which should result from
    the provided program point receiving the given
    avalue(s) as input.
  *)
  let register_data_flow dest src : unit AState.t =
    AState.modify (fun s -> { s with
      data_flow = s.data_flow
        |> ID_Map.update dest
        (function
        | Some srcs -> Some (ID_Set.add src srcs)
        | None      -> Some (ID_Set.singleton src)
        );
    })

  let register_type_flow dest tset : unit AState.t =
    AState.modify (fun s -> {s with
      type_flow = s.type_flow
        |> ID_Map.update dest
        (function
        | Some ts -> Some (Type_Set.union tset ts)
        | None    -> Some tset
        );
    })



  let prune_context ctx : context AState.t =
    let+ { sensitivity; _ } = AState.ask in
    take sensitivity ctx

  let fresh_version : int AState.t =
    let* { version; _ } = AState.get in
    Format.eprintf "version(%d)@." version;
    let+ () = AState.modify (fun s -> {s with version = version+1}) in
    version

  let add_to_env ctx id (tset, aset) : unit AState.t =
    let* { env_cache; env_version; _ } = AState.get in
    match Context_Map.find_opt ctx env_cache with
    | None ->
        let* v = fresh_version   in
        AState.modify (fun s -> { s with
          env_cache    = Context_Map.add ctx (ID_Map.singleton id (tset, aset)) env_cache;
          env_version  = Context_Map.add ctx v env_version;
        })
    | Some(env) ->
    match ID_Map.find_opt id env with
    | None ->
        let* v = fresh_version in
        AState.modify (fun s -> { s with
          env_cache   = Context_Map.add ctx (ID_Map.add id (tset, aset) env) env_cache;
          env_version = Context_Map.add ctx v env_version;
        })
    | Some((tset', aset')) ->
      if Avalue_Set.subset aset aset' && Type_Set.subset tset tset' then
        AState.pure ()
      else
      let combined_aset = Avalue_Set.union aset aset' in
      let combined_tset = Type_Set.union tset tset' in
      let* v = fresh_version in
      AState.modify (fun s -> { s with
        env_cache   = Context_Map.add ctx (ID_Map.add id (combined_tset, combined_aset) env) env_cache;
        env_version = Context_Map.add ctx v env_version;
      })

  let add_to_env' id (tset, aset) : unit AState.t =
    let* { context; _ } = AState.get in
    add_to_env context id (tset, aset)


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


  let call_closure ctx pp id src (tset, aset) (ma : (label * tset * aset) AState.t) : (tset * aset) AState.t =
    let* ctx' = prune_context (pp :: ctx) in
    (*
      Merge current environment into new one,
      allowing closure semantics to work.
    *)
    let* () = add_all_to_env ctx ctx' in
    let* () = add_to_env ctx' id (tset, aset) in
    let* { env_version; pp_version; pp_cache; _ } = AState.get in
    let env_v = Context_Map.find ctx' env_version in
    match ID_Map.find_opt pp pp_version with
    | Some(pp_v) when pp_v = env_v ->
      begin
        AState.pure (
          ID_Map.find_opt pp pp_cache
          |> Option.value ~default:(Type_Set.empty, Avalue_Set.empty)
        ) (* memoize this call *)
      end
    | _ ->
      begin
        let* () = register_data_flow id src in
        let* () = register_type_flow id tset in
        let* final_pp, tset, aset = ma |> AState.control
          (fun s    -> { s with
              context    = ctx';
              pp_version = ID_Map.add pp env_v pp_version;
          })
          (fun s s' -> { s' with
              context = s.context;
          })
        in
        let* () = register_data_flow pp final_pp in
        let* () = AState.modify (fun s -> { s with
          pp_cache = s.pp_cache |> ID_Map.update pp
            (function
            | None          -> Some (tset, aset)
            | Some (t', a') -> Some (Type_Set.union tset t', Avalue_Set.union aset a')
            );
        })
        in
        AState.gets
          (fun s -> ID_Map.find pp s.pp_cache)
      end

  let call_closure' pp id src aset ma =
    let* { context; _ } = AState.get in
    call_closure context pp id src aset ma

  (**
    Convert a given {!type-Layout.Ast.value} into an aset
  *)
  let eval_value pp v : aset AState.t =
    match v with
    | VInt 0             -> aset_of (AInt `Z)
    | VInt i when i > 0  -> aset_of (AInt `P)
    | VInt _ (* i < 0 *) -> aset_of (AInt `N)

    | VTrue  -> aset_of (ABool `T)
    | VFalse -> aset_of (ABool `F)

    | VFun (id, expr) ->
      let* { context; _ } = AState.get in
      aset_of @@ AFun (context, id, expr)

    | VRec record ->
        let* { context; _ } = AState.get in
        let record_map = record |> List.to_seq |> ID_Map.of_seq in
        let* () = record
          |> Lists.traverse_ (fun (lbl, id) ->
            let* (tset, _) = lookup context id in
            register_type_flow (project_pp_of pp lbl) tset *>
            register_data_flow (project_pp_of pp lbl) id
          )
        in
        let record_pp = record_map |> ID_Map.map (fun _ -> pp)
        in aset_of @@ ARec {
          name      = pp;
          fields_id = record_map;
          fields_pp = record_pp;
          pp_envs   = ID_Map.singleton pp context;
        }

  (**
    Evaluate a given {!type-Layout.Ast.operator} expression.
  *)
  let [@warning "-8"] eval_op pp o : aset AState.t =
    match o with
    | OPlus (i1, i2) ->
        let$* AInt r1 = lookup' i1 in
        let$* AInt r2 = lookup' i2 in
        begin match r1, r2 with
        | a, `Z | `Z, a -> aset_of @@ AInt a
        | `P, `P        -> aset_of @@ AInt `P
        | `N, `N        -> aset_of @@ AInt `N
        | _ -> aset_of_list [AInt `N; AInt `Z; AInt `P]
        end

    | OMinus (i1, i2) ->
        let$* AInt r1 = lookup' i1 in
        let$* AInt r2 = lookup' i2 in
        begin match r1, r2 with
        | a, `Z | `Z, a -> aset_of @@ AInt a
        | `P, `N        -> aset_of @@ AInt `P
        | `N, `P        -> aset_of @@ AInt `N
        | _ -> aset_of_list [AInt `N; AInt `Z; AInt `P]
        end

    | OTimes (i1, i2) ->
        let$* AInt r1 = lookup' i1 in
        let$* AInt r2 = lookup' i2 in
        begin match r1, r2 with
        | _, `Z   | `Z, _   -> aset_of @@ AInt `Z
        | `P, `N  | `N, `P  -> aset_of @@ AInt `N
        | _ -> aset_of @@ AInt `P
        end

    | ODivide (i1, i2) ->
        let$* AInt r1 = lookup' i1 in
        let$* AInt r2 = lookup' i2 in
        begin match r1, r2 with
        | `Z, _  -> aset_of @@ AInt `Z
        | _, `Z  -> AState.pure Avalue_Set.empty
        | `P, `N  | `N, `P
          -> aset_of_list [AInt `N; AInt `Z]
        | _
          -> aset_of_list [AInt `P; AInt `Z]
        end

    | OLess (i1, i2) ->
        let$* AInt r1 = lookup' i1 in
        let$* AInt r2 = lookup' i2 in
        begin match r1, r2 with
        | `N, `Z | `N, `P | `Z, `P          -> aset_of @@ ABool `T
        | `Z, `N | `P, `N | `P, `Z | `Z, `Z -> aset_of @@ ABool `F
        | _ -> aset_of_list [ABool `T; ABool `F]
        end

    | OEquals (i1, i2) ->
        let$* AInt r1 = lookup' i1 in
        let$* AInt r2 = lookup' i2 in
        begin match r1, r2 with
        | `Z, `Z -> aset_of @@ ABool `T
        | `N, `P | `P, `N
        | `Z, `P | `P, `Z
        | `Z, `N | `N, `Z -> aset_of @@ ABool `F
        | _ -> aset_of_list [ABool `T; ABool `F]
        end

    | OModulo (i1, i2) ->
        let$* AInt r1 = lookup' i1 in
        let$* AInt r2 = lookup' i2 in
        begin match r1, r2 with
        | `Z, _  -> aset_of @@ AInt `Z
        | _, `Z  -> AState.pure Avalue_Set.empty
        | `N, _  -> aset_of_list [AInt `N; AInt `Z]
        | `P, _  -> aset_of_list [AInt `P; AInt `Z]
        end

    | ONeg i1 ->
        let$* AInt r1 = lookup' i1 in
        begin match r1 with
        | `N -> aset_of (AInt `P)
        | `Z -> aset_of (AInt `Z)
        | `P -> aset_of (AInt `N)
        end

    | OAnd (i1, i2) ->
        let$* ABool r1 = lookup' i1 in
        let$* ABool r2 = lookup' i2 in
        begin match r1, r2 with
        | `T, r -> aset_of @@ ABool  r
        | `F, _ -> aset_of @@ ABool `F
        end

    | OOr (i1, i2) ->
        let$* ABool r1 = lookup' i1 in
        let$* ABool r2 = lookup' i2 in
        begin match r1, r2 with
        | `F, r -> aset_of @@ ABool  r
        | `T, _ -> aset_of @@ ABool `T
        end

    | ONot (i1)  ->
        let$* ABool r1 = lookup' i1 in
        begin match r1 with
        | `T -> aset_of @@ ABool `F
        | `F -> aset_of @@ ABool `T
        end

    | OAppend (id1, id2) ->
        let$* ARec r1 = lookup' id1 in
        let$* ARec r2 = lookup' id2 in
        let merge m1 m2 = ID_Map.union (fun _ _ v2 -> Some(v2)) m1 m2 in
        let fields_named_id = ID_Map.merge
          (fun _ v1 v2 -> match v1, v2 with
          | _, Some v2 -> Some (r2.name, v2)
          | Some v1, _ -> Some (r1.name, v1)
          | _ -> None
          ) r1.fields_id r2.fields_id
        in
        let fields_id = ID_Map.map snd fields_named_id  in
        let fields_pp = merge r1.fields_pp r2.fields_pp in
        let pp_envs   = merge r1.pp_envs   r2.pp_envs   in
        let* () =
          fields_named_id
          |> ID_Map.mapi (fun lbl (name, id) ->
              let lbl_pp  = ID_Map.find lbl fields_pp in
              let lbl_env = ID_Map.find lbl_pp pp_envs in
              let* (tset, _aset) = lookup lbl_env id in
              register_type_flow (project_pp_of name lbl) tset *>
              register_type_flow (project_pp_of pp lbl)   tset *>
              register_data_flow (project_pp_of pp lbl) (project_pp_of name lbl)
          )
          |> ID_Map.sequence_
        in
        aset_of @@ ARec {
          name = pp; fields_id; fields_pp; pp_envs;
        }

  (**
    Evaluate a {{!Layout.Ast.body.BProj} projection} expression.
  *)
  let eval_proj pp id lbl : (tset * aset) AState.t =
    let* (_, aset) = lookup' id in
    let+ projections = aset
      |> Avalue_Set.to_seq
      |> Seqs.traverse begin function
        | ARec arec as av ->
          let* (tset, aset) = project_field lbl av in
          let project_pp = project_pp_of arec.name lbl in
          register_data_flow pp project_pp   *>
          register_type_flow project_pp tset $>
          Some((tset, aset))
        | _ ->
          AState.pure None
      end
    in
    projections
    |> Seq.filter_map (fun x -> x)
    |> Seq.fold_left
      (fun (tt, aa) (tset, aset) -> (Type_Set.union tset tt, Avalue_Set.union aset aa))
      (Type_Set.empty, Avalue_Set.empty)





  (**
    Evaluate an {{!Layout.Ast.body.BApply} application} expression.
  *)
  let rec eval_apply pp id1 id2 =
    let* (_, aset) = lookup' id1 in
    let+ calls = aset
      |> Avalue_Set.to_seq
      |> Seqs.traverse begin function
        | AFun (ctx, id, expr) ->
          let* arg = lookup' id2 in
          let+ result = call_closure ctx pp id id2 arg (eval_f expr) in
          Some result
        | _ ->
          AState.pure None
      end
    in
    calls
    |> Seq.filter_map (fun x -> x)
    |> Seq.fold_left
      (fun (tt, aa) (tset, aset) -> (Type_Set.union tset tt, Avalue_Set.union aset aa))
      (Type_Set.empty, Avalue_Set.empty)

  (**
    Evaluate the {{!Layout.Ast.body} body} of a clause.
  *)
  and eval_body pp =
    function
    | BVar id  -> register_data_flow pp id *> lookup' id
    | BVal v   -> eval_value pp v >>= with_type
    | BOpr o   -> eval_op pp o    >>= with_type
    | BProj (id, lbl)   -> eval_proj  pp id  lbl
    | BApply (id1, id2) -> eval_apply pp id1 id2

    | BInput  -> aset_of_list [AInt `N; AInt `Z; AInt `P] >>= with_type
    | BRandom -> aset_of_list [AInt `Z; AInt `P]          >>= with_type

    | BMatch (id, branches) ->
        let* (tys, _) = lookup' id in
        let branches = tys
          |> Type_Set.to_seq
          |> Seq.filter_map (fun ty ->
            branches |> List.find_opt (fun (pat, _) -> is_subtype_simple ty pat)
          )
          |> List.of_seq
          |> List.sort_uniq compare (* TODO: make sure `compare` makes sense... I think so though *)
        in
        let+ results =
          branches
          |> Lists.traverse (fun (_, expr) ->
              let* (final_pp, _, _) as results = eval_f expr in
              register_data_flow pp final_pp $> results
          )
        in
        List.fold_left
          (fun (tt, aa) (_, tset, aset) -> (Type_Set.union tt tset, Avalue_Set.union aa aset))
          (Type_Set.empty, Avalue_Set.empty)
          results

  (**
    Evaluate an {{!Layout.Ast.expr} expression}.
  *)
  and eval_f (expr : Ast.expr) : (label * tset * aset) AState.t =
    match expr with
    | [] -> raise Empty_Expression
    | Cl (pp, body) :: cls ->
    Format.eprintf "eval(%s)@." pp;
    let* (body_type, body_value) = eval_body pp body in
    Format.eprintf "body(%s) had %d types.@." pp (Type_Set.cardinal body_type);
    if Type_Set.cardinal body_type > 1000 then
      Type_Set.iter begin fun ty -> Format.eprintf "%a@." pp_simple_type ty end body_type;
    let* () = register_type_flow pp body_type in
    let* () = add_to_env' pp (body_type, body_value) in
    match cls with
    | [] -> AState.pure (pp, body_type, body_value)
    | _  -> eval_f cls

  (**
    Entrypoint to the other evaluation functions;
    This sets up the initial state as required
    (Including calling {!Matching.find_required_depths}).
  *)
  let eval ?(k=0) field_depths expr =
    (let+ (_, _, result) = eval_f expr in result) {
      sensitivity  = k;
      inlining = 0;
      field_depths;
    } {
      data_flow = ID_Map.empty;
      type_flow = ID_Map.empty;

      env_cache    = Context_Map.empty;
      env_version  = Context_Map.empty;

      type_cache  = Type_Map.empty;

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
      next_tid = 5;
      next_uid = 1;

      type_to_id  = Type_Map.of_seq (List.to_seq [
        (TUniv,  0);
        (TInt,   1);
        (TTrue,  2);
        (TFalse, 3);
        (TFun,   4);
      ]);

      id_to_type  = Int_Map.of_seq (List.to_seq [
        (0, TUniv);
        (1, TInt);
        (2, TTrue);
        (3, TFalse);
        (4, TFun);
      ]);

      union_to_id = Int_Set_Map.singleton Int_Set.empty 0;

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


  let inferred_types_from_flow type_flow : inferred_types_t =
    let { type_to_id; id_to_type; union_to_id; id_to_union; _ }
      : fold_t = assign_unique_type_ids type_flow
    in
    let convert_type_set ts =
      Type_Set.fold (fun ty is ->
          Int_Set.add (Type_Map.find ty type_to_id) is) ts Int_Set.empty
    in {
      type_to_id;  id_to_type;
      union_to_id; id_to_union;

      pp_to_union_id =
        ID_Map.map (fun t -> Int_Set_Map.find
          (convert_type_set t) union_to_id) type_flow
    }




  module Field_Union_Map = Map.Make(struct
    type t = int ID_Map.t
    let compare = ID_Map.compare Int.compare
  end)

  type refine_fold_t = string Field_Union_Map.t (* ID assigned to each field/union record shape. *)

  module State = RWS_Util
    (struct type t = inferred_types_t end)
    (UnitM)
    (struct type t = refine_fold_t end)

  module Lists = struct
    include Lists
    include Traversable_Util(Lists)
  end

  module ID_Maps = struct
    include Maps(ID_Map)
    include Traversable_Util(Maps(ID_Map))
  end

  open State.Syntax

  let project_pp_of id lbl =
    id ^ "." ^ lbl

  let get_record_name (name: string) (fields : label list) : string State.t =
    let* field_unions = State.get in
    let* { pp_to_union_id; _ } = State.ask in
    let unions = fields
      |> List.to_seq
      |> Seq.map (fun f -> (f, ID_Map.find (project_pp_of name f) pp_to_union_id))
      |> ID_Map.of_seq
    in
    match Field_Union_Map.find_opt unions field_unions with
    | None ->
        let field_unions' = Field_Union_Map.add unions name field_unions in
        State.put field_unions' $> name
    | Some(name) ->
        State.pure name

  let refine_type_set type_set : Type_Set.t State.t =
    let open Lists.Make_Traversable(State) in
    let type_list = type_set |> Type_Set.elements in
    let+ type_list' = type_list |> traverse begin
      function
      | TRec (Some name, fields) ->
          let field_names = List.map fst fields in
          let+ name = get_record_name name field_names in
          TRec (Some name, fields)
      | other -> State.pure other
      end
    in
    Type_Set.of_list type_list'

  let rec refine_record_unions (type_flow, inferred_types) : inferred_types_t =
    let (_, (), type_flow') =
      let open ID_Maps.Make_Traversable(State) in
      let make_type_flow = type_flow |> traverse refine_type_set in
      make_type_flow inferred_types Field_Union_Map.empty
    in
    (* Repeatedly refine until the number of types stabilizes. *)
    let inferred_types' = inferred_types_from_flow type_flow' in
    if Type_Map.cardinal inferred_types'.type_to_id < Type_Map.cardinal inferred_types.type_to_id then
      refine_record_unions (type_flow', inferred_types')
    else
      inferred_types'


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
    let type_flow = type_flow_closure data_flow type_flow in
    let inferred_types = inferred_types_from_flow type_flow in
      (* inferred_types *)
      refine_record_unions (type_flow, inferred_types)

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
  let find_retagging ?check_names tys ty =
    first_where (is_instance_simple ?check_names) tys ty

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
      match ty1 with
      | TRec (_, ty1) ->
      let ty1' = ty1 |> List.to_seq |> ID_Map.of_seq in

      i2_tags |> traverse (fun t2 ->
        let+ ty2 = type_of_tag t2 in
        match ty2 with
        | TRec (_, ty2) ->
        let ty2' = ty2 |> List.to_seq |> ID_Map.of_seq in

        let ty' = TRec (
          Some pp,
          ID_Map.union (fun _ _ t2 -> Some(t2)) ty1' ty2'
          |> ID_Map.bindings
        ) in

        let t_ix = find_retagging pp_types ty' ~default:(-1) in
        if t_ix != -1 then
          Type_Tag_Pair_Map.singleton (t1, t2) (List.nth pp_tags t_ix)
        else
          Type_Tag_Pair_Map.empty

        | _ -> Type_Tag_Pair_Map.empty
      )
      | _ -> State.pure []
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
            let+ ty = type_of_tag tag in (lbl, erase_type_names ty))
        in
        let t_ix = find_retagging ~default:(-1)
          pp_types (TRec (Some pp, rty)) in
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
    pp_to_body     : Ast.body ID_Map.t;         (** Convenience mapping from pp to Ast.body *)
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
  let pp_to_body = Clauses.pp_to_body expr in
  let field_depths = Matching.find_required_depths expr in
  let closures = Closures.get_closure_info expr in
  let (flow, log, results) = FlowTracking.eval ~k field_depths expr in
  let inferred_types = Typing.assign_program_point_types flow.data_flow flow.type_flow in
  let tag_tables = Tagging.compute_tag_tables inferred_types expr in
  {
    pp_to_body;
    flow;
    log;
    results;
    field_depths;
    inferred_types;
    tag_tables;
    closures;
  }

