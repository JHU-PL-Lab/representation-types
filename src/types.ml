
let rec for_all l f =
  match l with
  | []      -> true
  | e :: l' -> if f e then for_all l' f  else false

let rec for_some l f =
  match l with
  | []      -> false
  | e :: l' -> if f e then true else for_some l' f


let rec for_all2 l1 l2 f =
  match l1, l2 with
  | [], [] -> true
  | (e1 :: l1'), (e2 :: l2') ->
      if f e1 e2 then for_all2 l1' l2' f else false
  | _ -> false


let rec for_some2 l1 l2 f =
  match l1, l2 with
  | [], [] -> false
  | (e1 :: l1'), (e2 :: l2') ->
      if f e1 e2 then true else for_some2 l1' l2' f
  | _ -> false
  
type label = string
  [@@deriving show, eq, ord]

type simple_type =
  | TBottom 
  | TUniv 
  | TInt 
  | TFun
  | TTrue | TFalse
  | TRec of (label * simple_type) list
  [@@deriving show { with_path = false }, eq, ord]

type type_id  = int [@@deriving show, eq, ord]
type union_id = int [@@deriving show, eq, ord]

type type_tag =
  Tag of { t_id: type_id; u_id: union_id }
  [@@deriving eq, ord]

let pp_type_tag fmt (Tag tag) =
  Format.fprintf fmt "%a#%a"
    pp_type_id tag.t_id
    pp_union_id tag.u_id

  
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


let rec is_instance_simple (t1 : simple_type) (t2 : simple_type) : bool =
  match t1, t2 with
  | _, TUniv -> true
  | TRec r1, TRec r2 ->
      (* print_string (
          (show_simple_type t1) ^ 
          " ?= " ^
          (show_simple_type t2) ^
          "\n"
      ); *)
      let r1' = List.fast_sort compare r1 in
      let r2' = List.fast_sort compare r2 in
      for_all2 r1' r2' (fun (l1, t1) (l2, t2) ->
        l1 = l2 && is_instance_simple t1 t2)

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
        else TRec (List.sort compare record')
  | other -> other
