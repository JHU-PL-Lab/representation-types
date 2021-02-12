
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
  | OTimes  of ident * ident (** Integer Multiplication. *)
  | ODivide of ident * ident (** Integer Division. *)
  | OLess   of ident * ident (** Integer Ordering. *)
  | ONeg    of ident         (** Integer Negation. *)
  | OEquals of ident * ident (** Integer Equality. *)
  | OModulo of ident * ident (** Integer Modulus.  *)
  | OAnd    of ident * ident (** Boolean Conjunction. *)
  | OOr     of ident * ident (** Boolean Disjunction. *)
  | ONot    of ident         (** Boolean Negation. *)
  | OAppend of ident * ident (** Record Append *)
  [@@deriving show { with_path = false }, eq, ord]

let pp_operator' fmt =
  let ff = Format.fprintf in
  function
  | OPlus   (i1, i2) -> ff fmt "%s + %s" i1 i2
  | OMinus  (i1, i2) -> ff fmt "%s - %s" i1 i2
  | OTimes  (i1, i2) -> ff fmt "%s * %s" i1 i2
  | ODivide (i1, i2) -> ff fmt "%s / %s" i1 i2
  | OLess   (i1, i2) -> ff fmt "%s < %s" i1 i2
  | ONeg    i1       -> ff fmt "- %s" i1
  | OEquals (i1, i2) -> ff fmt "%s == %s" i1 i2
  | OModulo (i1, i2) -> ff fmt "%s mod %s" i1 i2
  | OAnd    (i1, i2) -> ff fmt "%s and %s" i1 i2
  | OOr     (i1, i2) -> ff fmt "%s or %s" i1 i2
  | ONot    i1       -> ff fmt "not %s" i1
  | OAppend (i1, i2) -> ff fmt "%s %@ %s" i1 i2
  
(**
  The type of static values.
*)
type value =
  | VInt   of int                (** Integers. *)
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
  | BInput                    (** Integer input. *)
  | BRandom                   (** Integer (non-negative) random value. *)
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
  | VInt   i -> Format.fprintf fmt "%d" i
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
  | VFun (id, _body) ->
      Format.fprintf fmt "fun %s -> (...)" id

and pp_body' fmt =
  function
  | BVar id         -> Format.fprintf fmt "%s" id
  | BVal v          -> pp_value' fmt v
  | BOpr o          -> pp_operator' fmt o
  | BApply (i1, i2) -> Format.fprintf fmt "%s %s" i1 i2
  | BProj (id, lbl) -> Format.fprintf fmt "%s.%s" id lbl
  | BInput          -> Format.fprintf fmt "input"
  | BRandom         -> Format.fprintf fmt "random"
  | BMatch (id, _branches) ->
      Format.fprintf fmt "match %s with ..." id

and pp_clause' fmt (Cl (id, body)) =
  Format.fprintf fmt "let %s = %a" id pp_body' body

  
(**
  Primitive structure of abstract values.

  These must be supplied with an (in general recursive)
  type for their parameter to act as a way
  of extending their structure as need be.
*)
type 'env avalue =
  | AInt  of [ `N | `Z | `P ]
  | ABool of [ `T | `F ]
  | AFun  of 'env * ident * expr
  | ARec  of {
    name      : ident;
    fields_id : ident ID_Map.t [@polyprinter pp_id_map]; (** The name of the value assigned to each field *)
    fields_pp : ident ID_Map.t [@polyprinter pp_id_map]; (** The program point at which each field originated. *)
    pp_envs   : 'env  ID_Map.t [@polyprinter pp_id_map]; (** The context associated with each program point *)
  }
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
  | RInt   of int
  | RBool  of bool
  | RRec   of ident * ('rvalue ID_Map.t [@polyprinter pp_id_map])
  | RFun   of 'rvalue env * ident * expr
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
    | TRec (n1, record), RRec (n2, record') 
        when Option.is_none n1 || Option.get n1 = n2 ->
        for_all record (fun (lbl, pat') ->
          match ID_Map.find_opt lbl record' with
          | None      -> false
          | Some(rv') -> matches pat' rv')

    | _ -> false

  (**
    Given a certain depth, compute the runtime
    type of an rvalue. At depth 0, this
    will always return {!Layout.Types.simple_type.TUniv}. 
  *)
  let rec type_of ?(depth=(-1)) rv =
    if depth = 0 then TUniv else
    match Wrapper.extract rv with
    | RInt   _ -> TInt
    | RBool b -> if b then TTrue else TFalse
    | RFun (_, _, _) -> TFun
    | RRec (name, record) ->
        TRec (Some name, record 
          |> ID_Map.map (type_of ~depth:(depth - 1))
          |> ID_Map.bindings
        )

  (**
    Pretty-print the rvalue (regardless of the comonadic wrapper).
  *)
  let rec pp_rvalue'' fmt rv =
    let ff = Format.fprintf in
    match Wrapper.extract rv with
    | RInt   i -> ff fmt "%d" i
    | RBool  b -> ff fmt (if b then "true" else "false")
    | RFun   _ -> ff fmt "<fun>"
    | RRec (_, record) ->
      let record = ID_Map.bindings record in
      match record with
      | [] -> ff fmt "{}"
      | (lbl, hd) :: tl ->
        ff fmt "{%s = %a" lbl pp_rvalue'' hd;
        tl |> List.iter (fun (lbl, rv) ->
          ff fmt "; %s = %a" lbl pp_rvalue'' rv);
        ff fmt "}"

end


(**
  Basic rvalues with no comonadic context
  (the {{!Layout.Classes.Identity} Identity} context).
  This exists for consistency and to provide the additional
  operations the functor defines.
  In principle, {!RValue'.rvalue} == {!rvalue'}
*)
module RValue' = RValue(Identity)


      