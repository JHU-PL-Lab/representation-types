
open Util
open Types
open Classes


type ident = string

type operator =
  | OPlus   of ident * ident
  | OMinus  of ident * ident
  | OLess   of ident * ident
  | OEquals of ident * ident
  | OAnd    of ident * ident
  | OOr     of ident * ident
  | ONot    of ident
  
type value_spec =
  | VInt of int 
  | VTrue 
  | VFalse 
  | VRec of (label * ident) list
  | VFun of ident * expr
  
and value = value_spec

and body =
  | BVar   of ident
  | BVal   of value
  | BOpr   of operator
  | BApply of ident * ident
  | BProj  of ident * label
  | BMatch of ident * (simple_type * expr) list

and clause = Cl of ident * body

and expr = clause list
and ('k, 'v) env = ('k * 'v) list

module Basic_RValue (RValueWrapper : Comonad) =
struct
  module Wrapper = Comonad_Util(RValueWrapper)

  type rvalue_spec =
    | RInt  of int
    | RBool of bool
    
    | RRec  of (label * rvalue) list
    | RFun  of (ident, rvalue) env * ident * expr

  and rvalue = rvalue_spec Wrapper.t

  let rec matches (pat : simple_type) (rv : rvalue) =
    match pat, Wrapper.extract rv with
    |  TUniv,          _
    |   TInt, RInt _
    |  TTrue, RBool  true
    | TFalse, RBool false
    |   TFun, RFun (_, _, _) -> true
    | TRec (record), RRec (record') ->
        for_all record (fun (lbl, pat') ->
          match List.assoc_opt lbl record' with
          | None      -> false
          | Some(rv') -> matches pat' rv'  
        )
    | _ -> false

  let rec type_of ?(depth=(-1)) rv =
    if depth = 0 then TUniv else
    match Wrapper.extract rv with
    | RInt  _ -> TInt
    | RBool b -> if b then TTrue else TFalse
    | RFun (_, _, _) -> TFun
    | RRec record ->
        TRec (record |> List.map (fun (lbl, rv) -> 
          (lbl, type_of ~depth:(depth - 1) rv)))

end


open struct
  module RValue' = Basic_RValue(Identity)
end


module Unwrap_RValue
  (RValueWrapper : Comonad)
=  struct
  
  include Basic_RValue(RValueWrapper)

  let rec unwrap_rvalue : rvalue -> RValue'.rvalue =
    fun r -> match Wrapper.extract r with
    | RInt i  -> RValue'.RInt i
    | RBool b -> RValue'.RBool b
    | RRec record ->
        RValue'.RRec (List.map (fun (lbl, rv) ->
          (lbl, unwrap_rvalue rv)) record)
    | RFun (env, id, body) ->
        RValue'.RFun (unwrap_env env, id, body)

  and unwrap_env : ('i, rvalue) env -> ('i, RValue'.rvalue) env =
    fun env ->
      List.map (fun (id, rval) -> (id, unwrap_rvalue rval)) env

end


module RValue (RValueWrapper : Comonad) =
struct
  include Unwrap_RValue(RValueWrapper)
end


module RValue' = RValue(Identity)