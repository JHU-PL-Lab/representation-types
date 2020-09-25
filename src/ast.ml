
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
  [@@deriving show, eq, ord]

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
  [@@deriving show { with_path = false }, eq, ord]

let pp_operator' fmt = 
  function
  | OPlus   (i1, i2) -> Format.fprintf fmt "%s + %s" i1 i2
  | OMinus  (i1, i2) -> Format.fprintf fmt "%s - %s" i1 i2
  | OLess   (i1, i2) -> Format.fprintf fmt "%s < %s" i1 i2
  | OEquals (i1, i2) -> Format.fprintf fmt "%s == %s" i1 i2
  | OAnd    (i1, i2) -> Format.fprintf fmt "%s and %s" i1 i2
  | OOr     (i1, i2) -> Format.fprintf fmt "%s or %s" i1 i2
  | ONot    i1       -> Format.fprintf fmt "not %s" i1
  | OAppend (i1, i2) -> Format.fprintf fmt "%s @ %s" i1 i2
  
(**
  The type of static values.
*)
type value =
  | VInt of int                  (** Integers. *)
  | VTrue                        (** Boolean True.*)
  | VFalse                       (** Boolean False. *)
  | VRec of (label * ident) list (** Records. *)
  | VFun of ident * expr         (** Lambdas. *)
  [@@deriving show { with_path = false }, eq, ord]

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
  [@@deriving show { with_path = false }, eq, ord]

(**
  A clause merely associates the name of a program point
  to its body.
*)
and clause = Cl of ident * body
  [@@deriving show { with_path = false }, eq, ord]

(**
  An expression is merely an ordered string of clauses,
  corresponding to a sequence of nested let-bindings.
*)
and expr = clause list
  [@@deriving show, eq, ord]

(**
  {!ident}-indexed association lists.
*)
and 'v env = (ident * 'v) list
  [@@deriving show, eq, ord]


(**
  Means of identifying a particular (truncated)
  stack frame. The identifiers in this list
  correspond to the program points associated with
  each application of a function to a value.
*)
type context = ident list
  [@@deriving show, eq, ord]


let rec pp_value' fmt =
  function
  | VInt i -> Format.fprintf fmt "%d" i
  | VTrue  -> Format.fprintf fmt "true"
  | VFalse -> Format.fprintf fmt "false"
  | VRec record ->
      begin match record with
      | [] -> Format.fprintf fmt "{}"
      | (lbl1, id1)::tl ->
        Format.fprintf fmt "{@[@,%s = %s" lbl1 id1;
        tl |> List.iter (fun (lbl, id) ->
          Format.fprintf fmt ";@ %s = %s" lbl id
        );
        Format.fprintf fmt "@,@]}"
      end
  | VFun (id, body) ->
      Format.fprintf fmt "fu@[<hv>n %s ->@ " id;
      Format.fprintf fmt "%a@,@]" pp_expr body

and pp_body' fmt =
  function
  | BVar id         -> Format.fprintf fmt "%s" id
  | BVal v          -> pp_value fmt v
  | BOpr o          -> pp_operator fmt o
  | BApply (i1, i2) -> Format.fprintf fmt "%s %s" i1 i2
  | BProj (id, lbl) -> Format.fprintf fmt "%s.%s" id lbl
  | BMatch (id, branches) ->
      Format.fprintf fmt "@[<v>match %s with" id;
      branches |> List.iter (fun (ty, expr) ->
        Format.fprintf fmt "@;| %a ->@[@ %a@]"
          pp_simple_type ty pp_expr expr
      );
      Format.fprintf fmt "@;end@,@]"

and pp_clause' fmt (Cl (id, body)) =
  Format.fprintf fmt "le@[<hv>t %s =@ %a@ @]in" id pp_body body

and pp_expr' fmt =
  function
  | [] -> Format.fprintf fmt "(* empty expr (!?) *)"
  | [Cl (id, body)] ->
    Format.fprintf fmt
      "%a (* %s *)" pp_body body id
  | cl :: cls ->
    Format.fprintf fmt
      "@[<v>%a@;%a@]" pp_clause cl pp_expr cls

  
(**
  Primitive structure of abstract values.

  These must be supplied with an (in general recursive)
  type for their parameter to act as a way
  of extending their structure as need be.
*)
type 'env avalue =
  | AInt  of [ `N | `Z | `P ]
  | ABool of [ `T | `F ]
  | ARec  of (('env * ident) ID_Map.t [@polyprinter pp_id_map])
  | AFun  of 'env * ident * expr
  [@@deriving show { with_path = false }, eq, ord]


(**
  Primitive structure of runtime values.
  Almost identical to abstract values, but with concrete
  instances of integers, attached closure environments,
  etc.

  These must be supplied with an (in general recursive)
  type for their parameter to act as a way
  of extending their structure as need be.
*)
type 'rvalue rvalue_spec =
  | RInt  of int
  | RBool of bool
  
  | RRec  of ('rvalue ID_Map.t [@polyprinter pp_id_map])
  | RFun  of 'rvalue env * ident * expr
  [@@deriving show { with_path = false }, eq, ord]

(**
  The type of undecorated rvalues.
*)
type rvalue' = rvalue' rvalue_spec
  [@@deriving show { with_path = false }, eq, ord]


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
    |  TUniv, _
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

    in unwrap_rvalue


  (**
    Given an {!rvalue}, abstract away its
    specifics to get an equivalent {!avalue}.
    This preserves the comonadic wrapper, but it
    can later be removed with {!AValue.unwrap}.

    This abstract value preserves the environment
    obtained from closures, and has a constructed environment
    for each record so that lookups will return the appropriate
    value within the record.
  *)
  let rec to_avalue (rv : rvalue) : _ avalue Wrapper.t =
    rv |> Wrapper.map @@
    function
    | RInt i ->
        if i = 0 then AInt `Z
        else if i < 0 then AInt `N
        else AInt `P
    | RBool b ->
        if b then ABool `T else ABool `F
    | RFun (env, id, expr) ->
        let aenv = env
          |> List.map (fun (id, rv') -> (id, to_avalue rv')) 
        in
        AFun (aenv, id, expr)
    | RRec record ->
        let aenv = record
          |> ID_Map.map to_avalue
          |> ID_Map.bindings 
        in
        let arecord = record
          |> ID_Map.mapi (fun id _ ->
              (aenv, id))
        in
        ARec arecord

end


(**
  Basic rvalues with no comonadic context
  (the {{!Layout.Classes.Identity} Identity} context).
  This exists for consistency and to provide the additional
  operations the functor defines.
  In principle, {!RValue'.rvalue} == {!rvalue'}
*)
module RValue' = RValue(Identity)


      