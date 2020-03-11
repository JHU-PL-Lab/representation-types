

type ident = string
type label = string

type tagged = Tagged
type untagged = Untagged

type simple_type =
  | TInt | TTrue | TFalse | TFun
  | TBottom | TUniv | TRec of (label * simple_type) list

type full_type = Type of simple_type * (simple_type list)

type tag_set = Tau of (int * full_type) list

type _ operator =
  | OPlus   : (int  -> int  -> int)  operator
  | OMinus  : (int  -> int  -> int)  operator
  | OLess   : (int  -> int  -> bool) operator
  | OEquals : (int  -> int  -> bool) operator 
  | OAnd    : (bool -> bool -> bool) operator
  | OOr     : (bool -> bool -> bool) operator
  | ONot    : (bool -> bool) operator

let fn_of_operator : type f. f operator -> f =
  function
  | OPlus   -> (+)
  | OMinus  -> (-)
  | OLess   -> (<)
  | OEquals -> (=)
  | OAnd    -> (&&)
  | OOr     -> (||)
  | ONot    -> not

type _ value =
  | VInt of int 
  | VTrue 
  | VFalse 

  | VRec of (label * ident) list

  | VFun  : ident           * untagged expr -> untagged value
  | VTFun : ident * tag_set *   tagged expr ->   tagged value

and 't body =
  | BVar   of ident
  | BVal   of 't value
  | BOpr   : 'f operator * ident * ident -> 't body
  | BApply of ident * ident
  | BProj  of ident * label
  | BMatch of ident * (simple_type * 't expr) list

and _ clause =
  | Cl  : ident           * untagged body -> untagged clause
  | TCl : ident * tag_set *   tagged body ->   tagged clause

and 't expr = 't clause list
and 't env  = (ident * 't rvalue) list

and _ rvalue =
  | RInt  of int
  | RBool of bool
  
  | RRec  : untagged env * (label * ident) list -> untagged rvalue
  | RTRec :   tagged env * (label * ident) list ->   tagged rvalue

  | RFun  : untagged env * ident           * untagged expr -> untagged rvalue
  | RTFun :   tagged env * ident * tag_set *   tagged expr ->   tagged rvalue


let rec untag_value : type t. (t value) -> untagged value =
  function
  | VInt i -> VInt i
  | VTrue  -> VTrue
  | VFalse -> VFalse
  | VRec  (record)      -> VRec (record)
  | VFun  (id,    expr) -> VFun (id,            expr)
  | VTFun (id, _, expr) -> VFun (id, untag_expr expr)

and untag_pattern : type t. simple_type * t expr -> simple_type * untagged expr =
  fun (pt, e) -> (pt, untag_expr e)

and untag_body : type t. (t body) -> untagged body =
  function
  | BVar i -> BVar i
  | BVal v -> BVal (untag_value v)
  | BOpr (o, i1, i2)  -> BOpr (o, i1, i2)
  | BApply (id1, id2) -> BApply (id1, id2)
  | BProj (id, lbl)   -> BProj (id, lbl)
  | BMatch (id, pats) -> 
      BMatch (id, List.map untag_pattern pats)

and untag_clause : type t. (t clause) -> untagged clause =
  function
  | Cl  (id,    body) -> Cl (id,            body)
  | TCl (id, _, body) -> Cl (id, untag_body body)

and untag_expr : type t. (t expr) -> untagged expr =
  fun expr -> List.map untag_clause expr
  
and untag_env : type t. (t env) -> untagged env =
  fun env ->
    List.map (fun (id, rval) -> (id, untag_rvalue rval)) env
  
and untag_rvalue : type t. (t rvalue) -> untagged rvalue =
  function
  | RInt i  -> RInt i
  | RBool b -> RBool b
  | RRec  (env, record)      -> RRec (          env, record)
  | RTRec (env, record)      -> RRec (untag_env env, record)
  | RFun  (env, id,    expr) -> RFun (          env, id,            expr)
  | RTFun (env, id, _, expr) -> RFun (untag_env env, id, untag_expr expr)


let rec for_all l f =
  match l with
  | []      -> true
  | e :: l' -> if f e then for_all l' f  else false

let rec for_some l f =
  match l with
  | []      -> false
  | e :: l' -> if f e then true else for_some l' f


let rec is_comparable_simple (t1 : simple_type) (t2 : simple_type) : bool =
  match t1, t2 with
  |       _, TUniv
  | TBottom,     _  -> true

  | TRec r1, TRec r2 ->
      let module Set = Set.Make(String) in
      let r1_lbls = r1 |> List.map fst |> Set.of_list in
      let r2_lbls = r2 |> List.map fst |> Set.of_list in
      Set.equal r2_lbls (Set.inter r1_lbls r2_lbls) &&
      for_all r2 (fun (lbl, elem_2) ->
        match List.assoc_opt lbl r1 with
        | None         -> false
        | Some(elem_1) -> is_comparable_simple elem_1 elem_2
      )

  | t1, t2 when t1 = t2 -> true
  | _others -> false


let rec is_subtype_simple (t1 : simple_type) (t2 : simple_type) : bool =
  match t1, t2 with
  |       _, TUniv
  | TBottom,     _  -> true

  | TRec r1, TRec r2 ->
      for_all r2 (fun (lbl, elem_2) ->
        match List.assoc_opt lbl r1 with
        | None         -> false
        | Some(elem_1) -> is_subtype_simple elem_1 elem_2
      )

  | t1, t2 when t1 = t2 -> true
  | _others -> false

let is_subtype (t1 : full_type) (t2 : full_type) : bool =
  let Type (base_1, minus_set_1) = t1 in
  let Type (base_2, minus_set_2) = t2 in
  if not (is_subtype_simple base_1 base_2) then false
  else match base_2 with
  | TUniv ->
      for_all minus_set_2 (fun minus_type ->
        not (is_subtype_simple base_1 minus_type))

  | _otherwise ->
      for_all minus_set_2 (fun minus_type ->
        for_some minus_set_1 (fun minus_type' ->
          is_subtype_simple minus_type minus_type'))


let rec canonicalize_simple (base : simple_type) : simple_type =
  match base with
  | TRec record ->
      let (record', contains_bottom) =
        List.fold_right
          (fun (lbl, elem_base) (record, contains_bottom) ->
            let elem_base'       = canonicalize_simple elem_base in
            let record'          = (lbl, elem_base') :: record in
            let contains_bottom' = (elem_base' = TBottom) || contains_bottom in
              (record', contains_bottom')
          ) record ([], false) in
      if contains_bottom
        then TBottom
        else TRec record'
  | other -> other


let minimize_minus_set (Type (base, minus_set)) : full_type =
  let add_if_not_subsumed mt mts =
    if (mt = TBottom)
    || (not (is_subtype_simple mt base) && is_comparable_simple mt base)
    || for_some mts (fun mt' -> is_subtype_simple mt mt')
    then mts
    else mt :: mts
  in
  let minus_set' = List.fold_right add_if_not_subsumed minus_set [] in
  Type (base, minus_set')


let canonicalize (Type (base, minus_set)) : full_type =
  let base'      = canonicalize_simple base in
  let minus_set' = minus_set
      |> List.map canonicalize_simple
      |> List.sort_uniq compare
  in
  match base' with
  | TBottom    -> Type (TBottom, [])
  | _otherwise ->
      if for_some minus_set' (fun minus_type -> is_subtype_simple base' minus_type)
      then Type (TBottom, [])
      else minimize_minus_set @@ Type (base', minus_set')
      

let rec intersect_simple t1 t2 =
  match t1, t2 with
  | TUniv, t
  | t, TUniv -> t

  | TRec record1, TRec record2 ->
      let module Map = Map.Make(String) in
      let r1_map = record1 |> List.to_seq |> Map.of_seq in
      let r2_map = record2 |> List.to_seq |> Map.of_seq in
      let union =
        Map.union (fun _ t1 t2 -> Some(intersect_simple t1 t2)) 
          r1_map r2_map 
      in
        (* canonicalization because this type might actually be TBottom *)
        canonicalize_simple @@
        TRec (union |> Map.to_seq |> List.of_seq)

  | t1, t2 when t1 = t2 -> t1
  | _otherwise -> TBottom


let intersect (Type (base_1, minus_set_1)) (Type (base_2, minus_set_2)) =
  let base      = intersect_simple base_1 base_2 in
  let minus_set = minus_set_1 @ minus_set_2 in
  canonicalize @@
    Type (base, minus_set)


(*

  Currently forget about incomparable subtracted types:

    minimize_minus_set @@ Type (TRec ["x", TInt], [TRec ["y", TInt]])
      => Type (TRec ["x", TInt], [])

*)

let rec matches_u (pat : simple_type) (rv : untagged rvalue) =
  match pat, rv with
  |  TUniv,           _
  |   TInt, RInt      _
  |  TTrue, RBool  true
  | TFalse, RBool false
  |   TFun, RFun (_, _, _) -> true
  | TRec (record), RRec (env, record') ->
      for_all record (fun (lbl, pat') ->
        match List.assoc_opt lbl record' with
        | None      -> false
        | Some(id)  ->
        match List.assoc_opt id env with
        | None      -> false
        | Some(rv') -> matches_u pat' rv'  
      )
  | _ -> false

type exn +=
  | Open_Expression
  | Type_Mismatch
  | Match_Fallthrough
  | Empty_Expression

let rec eval_u : (untagged env) -> (untagged expr) -> (untagged rvalue) =

  let ( let+ ) v f =
    try f v with Match_failure (_, _, _) -> raise Type_Mismatch in

  let eval_value env =
    function
    | VInt i -> RInt i
    | VTrue  -> RBool true
    | VFalse -> RBool false
    | VRec (record)   -> RRec (env, record)
    | VFun (id, expr) -> RFun (env, id, expr)
  in

  let [@warning "-8"] eval_opr v1 v2 (type f) (o : f operator) =
    match o with
    | OPlus | OMinus as o ->
      begin
        let+ RInt i1 = v1 in
        let+ RInt i2 = v2 in
          RInt (fn_of_operator o i1 i2)
      end

    | OLess | OEquals as o ->
      begin
        let+ RInt i1 = v1 in
        let+ RInt i2 = v2 in
          RBool (fn_of_operator o i1 i2)
      end

    | OAnd | OOr as o ->
      begin
        let+ RBool b1 = v1 in
        let+ RBool b2 = v2 in
          RBool (fn_of_operator o b1 b2)
      end

    | ONot as o ->
      begin
        let+ RBool b1 = v1 in
          RBool (fn_of_operator o b1)
      end
  in

  let lookup env id =
    match List.assoc_opt id env with
    | None    -> raise Open_Expression
    | Some(v) -> v
  in

  let [@warning "-8"] eval_proj v1 lbl =
    begin
      let+ RRec (env', record) = v1 in
      match List.assoc_opt lbl record with
      | None     -> raise Type_Mismatch
      | Some(id) -> lookup env' id
    end
  in

  let eval_body env =
    function
    | BVar id -> lookup env id
    
    | BVal v  -> eval_value env v
    
    | BOpr (o, id1, id2) ->
        let v1 = lookup env id1 in
        let v2 = lookup env id2 in
          eval_opr v1 v2 o
    
    | BProj (id, lbl) ->
        let v1 = lookup env id in
          eval_proj v1 lbl

    | BApply (id1, id2) ->
        begin [@warning "-8"]
          let+ RFun (env', id, expr) = lookup env id1 in
          let  v2                    = lookup env id2 in
            eval_u ((id, v2) :: env') expr
        end

    | BMatch (id, branches) ->
        let v1 = lookup env id in
        let branch = List.find_opt
          (fun (pat, _) -> matches_u pat v1) branches in
        match branch with
        | None -> raise Match_Fallthrough
        | Some((_, expr')) -> eval_u env expr'
          
  in
  
  fun env expr ->
    match expr with
    | [] -> raise Empty_Expression
    | Cl (id, body) :: cls ->
      let body_value = eval_body env body in
      if cls = []
        then body_value
        else eval_u ((id, body_value) :: env) cls
