
let rec for_all l f =
  match l with
  | []      -> true
  | e :: l' -> if f e then for_all l' f else false

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
  | TUniv 
  | TInt 
  | TFun
  | TTrue | TFalse
  | TRec of (label * simple_type) list
  [@@deriving eq, ord]

let rec pp_simple_type fmt =
  function
  | TUniv  -> Format.fprintf fmt "*"
  | TInt   -> Format.fprintf fmt "int"
  | TFun   -> Format.fprintf fmt "fun"
  | TTrue  -> Format.fprintf fmt "true"
  | TFalse -> Format.fprintf fmt "false"
  | TRec record ->
      match record with
      | [] -> Format.fprintf fmt "{}"
      | (lbl, t1)::tl ->
        Format.fprintf fmt "{@[@,%s : %a" lbl pp_simple_type t1;
        tl |> List.iter (fun (lbl, ty) ->
          Format.fprintf fmt ";@ %s : %a" lbl pp_simple_type ty
        );
        Format.fprintf fmt "@,@]}"


type type_id  = int [@@deriving show, eq, ord]
type union_id = int [@@deriving show, eq, ord]

type type_tag =
  Tag of type_id
  [@@deriving eq, ord]

let pp_type_tag fmt (Tag tag) =
  Format.fprintf fmt "#%a"
    pp_type_id tag

  
let rec is_non_conflicting_simple (t1 : simple_type) (t2 : simple_type) : bool =
  match t1, t2 with
  | _, TUniv -> true
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
      let r1' = List.fast_sort compare r1 in
      let r2' = List.fast_sort compare r2 in
      for_all2 r1' r2' (fun (l1, t1) (l2, t2) ->
        l1 = l2 && is_instance_simple t1 t2)

  | t1, t2 when t1 = t2 -> true
  | _others -> false


let rec is_subtype_simple (t1 : simple_type) (t2 : simple_type) : bool =
  match t1, t2 with
  | _, TUniv -> true
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
      let record' = record
        |> List.map (fun (lbl, elem_base) ->
            (lbl, canonicalize_simple elem_base)) 
      in
      TRec (List.sort compare record')

  | other -> other
