
(**
  Definitions of the structure of
  values, both statically and at runtime.
*)

open Util
open Types
open Classes

(**
  The type of identifiers, i.e. to descibe
  program points and their variable bindings.
*)
type ident = string
  [@@deriving show]

(**
  An enumeration of the different primitive
  operations we can interpret.
*)
type operator =
  | OPlus   of ident * ident (** Integer Addition. *)
  | OMinus  of ident * ident (** Integer Subtraction. *)
  | OLess   of ident * ident (** Integer Ordering. *)
  | OEquals of ident * ident (** Integer Equality. *)
  | OAnd    of ident * ident (** Boolean Conjunction. *)
  | OOr     of ident * ident (** Boolean Disjunction. *)
  | ONot    of ident         (** Boolean Negation. *)
  | OAppend of ident * ident (** Record Append *)
  [@@deriving show]
  
(**
  The type of static values.
*)
type value =
  | VInt of int                  (** Integers. *)
  | VTrue                        (** Boolean True.*)
  | VFalse                       (** Boolean False. *)
  | VRec of (label * ident) list (** Records. *)
  | VFun of ident * expr         (** Lambdas. *)
  [@@deriving show { with_path = false }]
(**
  Whether the representation of
  {!VTrue} and {!VFalse} should remain separate
  (corresponding to {!Types.simple_type.TTrue} and {!Types.simple_type.TFalse})
  is unclear; they may be merged.
*)

(**
  The types of expressions
  which must be associated with a program point.
*)
and body =
  | BVar    of ident          (** Environment Lookup. *)
  | BVal    of value          (** Static Value. *)
  | BOpr    of operator       (** Primitive Operator. *)
  | BApply  of ident * ident  (** Function Application. *)
  | BProj   of ident * label  (** Field Projection. *)
  | BMatch  of ident * (simple_type * expr) list (** Match Expression. *)
  [@@deriving show { with_path = false }]

(**
  A clause merely associates the name of a program point
  to its body.
*)
and clause = Cl of ident * body
  [@@deriving show { with_path = false }]

(**
  An expression is merely an ordered string of clauses,
  corresponding to a sequence of nested let-bindings.
*)
and expr = clause list
  [@@deriving show]

(**
  {!ident}-indexed association lists.
*)
and 'v env = (ident * 'v) list
  [@@deriving show]

  
(**
  Primitive structure of runtime values.
  These must be supplied with an (in general recursive)
  type for their parameter to act as a way
  of extending their structure as need be.
*)
type ('rvalue) rvalue_spec =
  | RInt  of int
  | RBool of bool
  
  | RRec  of ('rvalue ID_Map.t [@polyprinter Util.pp_id_map])
  | RFun  of 'rvalue env * ident * expr
  [@@deriving show { with_path = false }]

(**
  The type of undecorated rvalues.
*)
type rvalue' = (rvalue') rvalue_spec
  [@@deriving show { with_path = false }]


(**
  A basic representation of a runtime value
  augmented with a comonadic context.
*)
module RValue (RValueWrapper : Comonad) =
struct

  (**
    A renaming of the {!RValueWrapper} module, in case
    it was an anonymous functor application, for example.
    This also avoids certain issues in which ocaml
    complains about intermediate modules not being erasable.
  *)
  module Wrapper = Comonad_Util(RValueWrapper)
  
  (**
    Each top-level rvalue is wrapped in
    the comonadic environment supplied by {!Wrapper}.
  *)
  type rvalue = rvalue rvalue_spec Wrapper.t

  (**
    An abbreviation for convenience so that
    one can reference the 'unwrapped' type of
    an instance of {!RValue.rvalue} more concisely
    than [RValue.rvalue Ast.rvalue_spec].
  *)
  type nonrec rvalue_spec = rvalue rvalue_spec
  
  (**
    Check whether an rvalue has a given type.
  *)
  let rec matches (pat : simple_type) (rv : rvalue) =
    match pat, Wrapper.extract rv with
    |  TUniv,          _
    |   TInt, RInt _
    |  TTrue, RBool  true
    | TFalse, RBool false
    |   TFun, RFun (_, _, _) -> true
    | TRec (record), RRec (record') ->
        for_all record (fun (lbl, pat') ->
          match ID_Map.find_opt lbl record' with
          | None      -> false
          | Some(rv') -> matches pat' rv'  
        )
    | _ -> false

  (**
    Given a certain depth, compute the runtime
    type of an rvalue. At depth 0, this
    will always return {!Layout.Types.simple_type.TUniv}. 
  *)
  let rec type_of ?(depth=(-1)) rv =
    if depth = 0 then TUniv else
    match Wrapper.extract rv with
    | RInt  _ -> TInt
    | RBool b -> if b then TTrue else TFalse
    | RFun (_, _, _) -> TFun
    | RRec record ->
        TRec ( record 
          |> ID_Map.map (type_of ~depth:(depth - 1))
          |> ID_Map.bindings
        )

  (**
    Unwrap the comonadic layers and return
    an unaugmented {{!Ast.rvalue'} rvalue'} for
    use in comparison, printing, etc.
  *)
  let unwrap : rvalue -> rvalue' =
    let rec unwrap_rvalue r =
      match Wrapper.extract r with
      | RInt i  -> RInt i
      | RBool b -> RBool b
      | RRec record ->
          RRec (ID_Map.map unwrap_rvalue record)

      | RFun (env, id, body) ->
          RFun (unwrap_env env, id, body)

    and unwrap_env env =
        List.map (fun (id, rval) -> (id, unwrap_rvalue rval)) env
    in
      unwrap_rvalue

end

(**
  Basic rvalues with no comonadic context
  (the {{!Layout.Classes.Identity} Identity} context).
  This exists for consistency and to provide the additional
  operations the functor defines.
  In principle, {!RValue'.rvalue} == {!rvalue'}
*)
module RValue' = RValue(Identity)
