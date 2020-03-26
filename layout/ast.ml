
open Types
open Classes

module Basic_Ast (ValueWrapper : Comonad) (IdentWrapper : Comonad) =
struct

  module ValueWrapper = ValueWrapper
  module IdentWrapper = IdentWrapper

  type ident = string IdentWrapper.t

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
    
  and value = value_spec ValueWrapper.t
  
  and body =
    | BVar   of ident
    | BVal   of value
    | BOpr   of operator
    | BApply of ident * ident
    | BProj  of ident * label
    | BMatch of ident * (simple_type * expr) list
  
  and clause = Cl of ident * body
  
  and expr = clause list
  and 't env = (ident * 't) list
  
  module Basic_RValue (RValueWrapper : Comonad) =
  struct
    module RValueWrapper = RValueWrapper

    type rvalue_spec =
      | RInt  of int
      | RBool of bool
      
      | RRec  of (label * rvalue) list
      | RFun  of rvalue env * ident * expr

    and rvalue = rvalue_spec RValueWrapper.t

    let rec matches (pat : simple_type) (rv : rvalue) =
      match pat, RValueWrapper.extract rv with
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

    let rec type_of rv =
      match RValueWrapper.extract rv with
      | RInt  _ -> TInt
      | RBool b -> if b then TTrue else TFalse
      | RFun (_, _, _) -> TFun
      | RRec (record) ->
          TRec (List.map (fun (lbl, rv) -> (lbl, type_of rv)) record)

  end
end


module Unwrap_Ast (ValueWrapper : Comonad) (IdentWrapper : Comonad) =
struct

  open struct
    module Ast  = Basic_Ast(ValueWrapper)(IdentWrapper)
    module Ast' = Basic_Ast(Identity)(Identity)
  end

  let unwrap_ident : Ast.ident -> Ast'.ident =
    IdentWrapper.extract

  let unwrap_operator : Ast.operator -> Ast'.operator =
    function
    | Ast.OPlus   (id1, id2) -> Ast'.OPlus   (unwrap_ident id1, unwrap_ident id2)
    | Ast.OMinus  (id1, id2) -> Ast'.OMinus  (unwrap_ident id1, unwrap_ident id2)
    | Ast.OLess   (id1, id2) -> Ast'.OLess   (unwrap_ident id1, unwrap_ident id2)
    | Ast.OEquals (id1, id2) -> Ast'.OEquals (unwrap_ident id1, unwrap_ident id2)
    | Ast.OAnd    (id1, id2) -> Ast'.OAnd    (unwrap_ident id1, unwrap_ident id2)
    | Ast.OOr     (id1, id2) -> Ast'.OOr     (unwrap_ident id1, unwrap_ident id2)
    | Ast.ONot    (id)       -> Ast'.ONot    (unwrap_ident id)

  let rec unwrap_value : Ast.value -> Ast'.value =
    fun v -> match ValueWrapper.extract v with
    | Ast.VInt i -> Ast'.VInt i
    | Ast.VTrue  -> Ast'.VTrue
    | Ast.VFalse -> Ast'.VFalse
    | Ast.VRec record -> Ast'.VRec
        (List.map (fun (lbl, id) -> (lbl, unwrap_ident id)) record)
    | Ast.VFun (id, body) -> Ast'.VFun (unwrap_ident id, unwrap_expr body)

  and unwrap_body : Ast.body -> Ast'.body =
    function
    | Ast.BVar id -> Ast'.BVar (unwrap_ident id)
    | Ast.BVal v  -> Ast'.BVal (unwrap_value v)
    | Ast.BOpr o  -> Ast'.BOpr (unwrap_operator o)
    | Ast.BApply (id1, id2) -> Ast'.BApply (unwrap_ident id1, unwrap_ident id2)
    | Ast.BProj (id, lbl)   -> Ast'.BProj (unwrap_ident id, lbl)
    | Ast.BMatch (id, branches) ->
        Ast'.BMatch (unwrap_ident id,
          List.map (fun (ty, body) -> (ty, unwrap_expr body)) branches)

  and unwrap_clause : Ast.clause -> Ast'.clause =
    function
    | Ast.Cl (id, body) -> Ast'.Cl (unwrap_ident id, unwrap_body body)

  and unwrap_expr : Ast.expr -> Ast'.expr =
    fun e -> List.map unwrap_clause e

  module Unwrap_RValue (RValueWrapper : Comonad) = 
  struct
    open struct
      module RValue  = Ast.Basic_RValue(RValueWrapper)
      module RValue' = Ast'.Basic_RValue(Identity)
    end

    let rec unwrap_rvalue : RValue.rvalue -> RValue'.rvalue =
      fun r -> match RValueWrapper.extract r with
      | RValue.RInt i  -> RValue'.RInt i
      | RValue.RBool b -> RValue'.RBool b
      | RValue.RRec record ->
          RValue'.RRec (List.map (fun (lbl, rv) ->
            (lbl, unwrap_rvalue rv)) record)
      | RValue.RFun (env, id, body) ->
          RValue'.RFun (unwrap_env env, unwrap_ident id, unwrap_expr body)

    and unwrap_env : RValue.rvalue Ast.env -> RValue'.rvalue Ast'.env =
      fun env ->
        List.map (fun (id, rval) ->
          (unwrap_ident id, unwrap_rvalue rval)) env

  end

end


module Make (ValueWrapper : Comonad) (IdentWrapper : Comonad) =
struct

  include Basic_Ast(ValueWrapper)(IdentWrapper)
  include Unwrap_Ast(ValueWrapper)(IdentWrapper)

  module RValue (RValueWrapper : Comonad) =
  struct
    include Basic_RValue(RValueWrapper)
    include Unwrap_RValue(RValueWrapper)
  end

end