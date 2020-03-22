
module Lens = Lens
module Classes = Classes

open Classes

type ident = string 
type label = string 

type tagged   = Tagged   
type untagged = Untagged 

type simple_type =
  | TInt | TTrue | TFalse | TFun
  | TBottom | TUniv | TRec of (label * simple_type) list

type full_type = Type of simple_type * (simple_type list)

type tag_set = Tau of (int * full_type) list


type operator =
  | OPlus   of ident * ident
  | OMinus  of ident * ident
  | OLess   of ident * ident
  | OEquals of ident * ident
  | OAnd    of ident * ident
  | OOr     of ident * ident
  | ONot    of ident
  

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
  | BOpr   of operator
  | BApply of ident * ident
  | BProj  of ident * label
  | BMatch of ident * (simple_type * 't expr) list
  

and _ clause =
  | Cl  : ident           * untagged body -> untagged clause
  | TCl : ident * tag_set *   tagged body ->   tagged clause
  

and 't expr = 't clause list
and 't env  = (ident * 't) list

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
  | BOpr o -> BOpr o
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
  
  
module RValue (F : Functor) = struct

  module F = F;;

  type _ rvalue' =
    | RInt  of int
    | RBool of bool
    
    | RRec  : untagged rvalue env * (label * ident) list -> untagged rvalue'
    | RTRec :   tagged rvalue env * (label * ident) list ->   tagged rvalue'

    | RFun  : untagged rvalue env * ident           * untagged expr -> untagged rvalue'
    | RTFun :   tagged rvalue env * ident * tag_set *   tagged expr ->   tagged rvalue'
    

  and 't rvalue = 't rvalue' F.t

  let rec untag_rvalue : type t. (t rvalue) -> untagged rvalue =
    fun rval ->
      let untag_rvalue' : type t. (t rvalue') -> untagged rvalue' =
      function
      | RInt i  -> RInt i
      | RBool b -> RBool b
      | RRec  (env, record)      -> RRec (          env, record)
      | RTRec (env, record)      -> RRec (untag_env env, record)
      | RFun  (env, id,    expr) -> RFun (          env, id,            expr)
      | RTFun (env, id, _, expr) -> RFun (untag_env env, id, untag_expr expr)
      in
        F.map untag_rvalue' rval

  and untag_env : type t. (t rvalue env) -> untagged rvalue env =
    fun env ->
      List.map (fun (id, rval) -> (id, untag_rvalue rval)) env

end;;

let rec for_all l f =
  match l with
  | []      -> true
  | e :: l' -> if f e then for_all l' f  else false

let rec for_some l f =
  match l with
  | []      -> false
  | e :: l' -> if f e then true else for_some l' f


let rec is_non_conflicting_simple (t1 : simple_type) (t2 : simple_type) : bool =
  match t1, t2 with
  |       _, TUniv
  | TBottom,     _  -> true

  | TRec r1, TRec r2 ->
      let module Set = Set.Make(String) in
      let r1_lbls = r1 |> List.map fst |> Set.of_list in
      let r2_lbls = r2 |> List.map fst |> Set.of_list in
      let inter_lbls = Set.inter r1_lbls r2_lbls in
      Set.for_all (fun lbl ->
        (* guaranteed these lookups should not fail *)
        let r1_elem = List.assoc lbl r1 in
        let r2_elem = List.assoc lbl r2 in
          is_non_conflicting_simple r1_elem r2_elem
      ) inter_lbls

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



let canonicalize : full_type -> full_type =

  let minimize_minus_set (Type (base, minus_set)) : full_type =
    let rec traverse_insert mts mt =
      match mts, mt with
      |            [], mt -> [mt]
      | (mt' :: mts'), mt ->
        if is_subtype_simple mt  mt' then mt' :: mts' else
        if is_subtype_simple mt' mt  then traverse_insert mts' mt else
          if mt < mt'
            then mt :: mt' :: mts'
            else       mt' :: traverse_insert mts' mt
    in
    let minus_set' = minus_set
      |> List.filter (fun mt -> is_non_conflicting_simple mt base)
      |> List.fold_left traverse_insert [] in
    Type (base, minus_set')
  in

  function Type (base, minus_set) ->
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
  canonicalize @@ Type (base, minus_set)


type exn +=
  | Open_Expression
  | Type_Mismatch
  | Match_Fallthrough
  | Empty_Expression


module FlowEvaluator = struct

  type flow_tag =
    | Original
    | Source of ident

  module Flow_map = Map.Make(String)

  module RValues = RValue(WriterF(struct
    type t = flow_tag
  end));;
  
  open! RValues;;

  let pp_flow_map pp_val fmt flow =
    Format.pp_print_char fmt '{';
    Format.pp_print_cut fmt ();
    Flow_map.iter (fun k v ->
      Format.pp_print_string fmt k;
      Format.pp_print_string fmt " -> ";
      pp_val fmt v;
      Format.pp_print_char fmt ',';
      Format.pp_print_cut fmt ()) flow;
    Format.pp_print_char fmt '}'

  type flow_state =
    {
      env  : untagged rvalue env;
      flow : ident list Flow_map.t;
    }

  module State = MonadUtil(State(struct type t = flow_state end));;
  open State.Syntax;;

  let ( let$ ) v f = 
    try f v with | Match_failure (_, _, _) -> raise Type_Mismatch
  
  let ( let$+ ) v f =
      try f <$> v with | Match_failure (_, _, _) -> raise Type_Mismatch

  let ( let$* ) v f =
      try f >>= v with | Match_failure (_, _, _) -> raise Type_Mismatch

  let rec matches_u (pat : simple_type) (rv : untagged rvalue) =
  
    match pat, rv with
    |  TUniv,          _
    |   TInt, (_, RInt _)
    |  TTrue, (_, RBool  true)
    | TFalse, (_, RBool false)
    |   TFun, (_, RFun (_, _, _)) -> true
    | TRec (record), (_, RRec (env, record')) ->
        for_all record (fun (lbl, pat') ->
          match List.assoc_opt lbl record' with
          | None      -> false
          | Some(id)  ->
          match List.assoc_opt id env with
          | None      -> false
          | Some(rv') -> matches_u pat' rv'  
        )
    | _ -> false


  let get_env : untagged rvalue env State.t
    = fun s -> (s, s.env)
  
  let use_env env' (act : 'a State.t) : 'a State.t =
    fun s ->
      let (s', v) = act {s with env = env'} in
        ({s with flow = s'.flow}, v)

  let modify (f : flow_state -> flow_state) : unit State.t =
    fun s -> (f s, ())

  let lookup id : untagged rvalue State.t =
    let+ env = get_env in
    match List.assoc_opt id env with
    | None    -> raise Open_Expression
    | Some(v) -> v

  let eval_value v : untagged rvalue State.t =
    let+ env = get_env in 
    match v with
    | VInt i -> (Original, RInt i)
    | VTrue  -> (Original, RBool true)
    | VFalse -> (Original, RBool false)
    | VRec (record)   -> (Original, RRec (env, record))
    | VFun (id, expr) -> (Original, RFun (env, id, expr))

  let [@warning "-8"] eval_op o : untagged rvalue State.t =
    try match o with
    | OPlus (i1, i2) -> 
        let+ (_, RInt r1) = lookup i1 
        and+ (_, RInt r2) = lookup i2
        in (Original, RInt (r1 + r2))
    
    | OMinus (i1, i2) -> 
        let+ (_, RInt r1) = lookup i1 
        and+ (_, RInt r2) = lookup i2
        in (Original, RInt (r1 - r2))
    
    | OLess (i1, i2) -> 
        let+ (_, RInt r1) = lookup i1 
        and+ (_, RInt r2) = lookup i2
        in (Original, RBool (r1 < r2))
    
    | OEquals (i1, i2) -> 
        let+ (_, RInt r1) = lookup i1 
        and+ (_, RInt r2) = lookup i2
        in (Original, RBool (r1 = r2))
    
    | OAnd (i1, i2) -> 
        let+ (_, RBool r1) = lookup i1 
        and+ (_, RBool r2) = lookup i2
        in (Original, RBool (r1 && r2))
    
    | OOr (i1, i2) -> 
        let+ (_, RBool r1) = lookup i1 
        and+ (_, RBool r2) = lookup i2
        in (Original, RBool (r1 || r2))
    
    | ONot (i1)  -> 
        let+ (_, RBool r1) = lookup i1
        in (Original, RBool (not r1))
    with
    | Match_failure (_, _, _) -> raise Type_Mismatch

  let [@warning "-8"] eval_proj id lbl : untagged rvalue State.t =
    let$+ (_, RRec (env', record)) = lookup id in
    let$ Some(id') = List.assoc_opt lbl record in
      begin match List.assoc_opt id' env' with
        | None      -> raise Open_Expression
        | Some(v')  -> v'
      end

  let rec eval_apply id1 id2 =
    State.join begin [@warning "-8"]
      let$+ (_, RFun (env', id, expr)) = lookup id1 in
      let* v2 = lookup id2 in
        use_env ((id, v2) :: env') @@ eval_f expr
    end

  and eval_body =
    function
    | BVar id -> lookup id
    | BVal v -> eval_value v
    | BOpr o -> eval_op o
    | BProj (id, lbl) -> eval_proj id lbl
    | BApply (id1, id2) -> eval_apply id1 id2

    | BMatch (id, branches) ->
        let* v1 = lookup id in
        let branch = List.find_opt
          (fun (pat, _) -> matches_u pat v1) branches in
        match branch with
        | None -> raise Match_Fallthrough
        | Some((_, expr')) -> eval_f expr'

  and eval_f expr =
    match expr with
    | [] -> raise Empty_Expression
    | Cl (id, body) :: cls ->
      let* body_value = eval_body body in
      let (origin, rval) = body_value in
      let* () = modify @@ fun s -> {
        env  = (id, (Source id, rval)) :: s.env;
        flow =
          match origin with
          | Original -> s.flow
          | Source(o) ->
            Flow_map.update id
              (function | None    -> Some [o]
                        | Some os -> Some (o :: os))
              s.flow;
      } in
      if cls = []
        then State.pure body_value
        else eval_f cls

  let eval expr =
    eval_f expr { env = []; flow = Flow_map.empty; }

end;;
