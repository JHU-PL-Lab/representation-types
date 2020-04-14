
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
  | TInt | TTrue | TFalse | TFun
  | TBottom | TUniv | TRec of (label * simple_type) list
  [@@deriving show, eq, ord]

type type_tag =
  Tag of { t_id: int; u_id: int }
  [@@deriving show, eq, ord]

  
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

(*   
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
*)

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


(* 
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
*)
      

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

(*
  let intersect (Type (base_1, minus_set_1)) (Type (base_2, minus_set_2)) =
    let base      = intersect_simple base_1 base_2 in
    let minus_set = minus_set_1 @ minus_set_2 in
    canonicalize @@ Type (base, minus_set)
*)