
(**
  Utility data structures.
*)

(**
  List representation with constant-time
  prepend, append, map, and concatenate.
  Conversion to regular lists in O(n) once done.
*)
module Diff_list = struct
  type 'a t =
    { fold : 'b. ('a -> 'b -> 'b) -> 'b -> 'b }
    [@@unboxed] 

  let cons a l =
    { fold = fun c n -> c a (l.fold c n) }

  let nil =
    { fold = fun _ n -> n }

  let (++) l1 l2 =
    { fold = fun c n -> l1.fold c (l2.fold c n) }

  let to_list l1 =
    l1.fold (fun x xs -> x :: xs) []

  let from_list l1 =
    { fold = fun c n -> List.fold_right c l1 n }

  let concat ll1 =
    ll1.fold (++) nil

  let map f l =
    { fold = fun c n -> l.fold (fun a b -> c (f a) b) n }

  let pure a = cons a nil

  let snoc l a =
    l ++ pure a
end

(**
  Disjoint sets data structure
  with practically constant set union
  and lookup, here with attached values
  which are merged when sets are.
*)
module Union_find = struct

  type 'a node =
    | Root of { data: 'a; }
    | Child of { mutable parent: 'a node ref }
    
  let make_distinct a =
    ref (Root { data = a; })

  let rec find_root a =
    match !a with
    | Root _ -> a
    | Child c ->
        let root = find_root c.parent in
          c.parent <- root; root

  let find a =
    match !(find_root a) with
    | Root r -> r.data
    | _ -> failwith "impossible."

  let are_disjoint a b =
    (find_root a <> find_root b)

  let union f a b =
    let a_root = find_root a in
    let b_root = find_root b in
    if a_root == b_root then () else
    let new_root = make_distinct @@ f (find a_root) (find b_root) in
      a_root := Child {parent = new_root};
      b_root := Child {parent = new_root}

end


let rec take k =
  function
  | x::xs when k > 0 -> x :: take (k - 1) xs
  | _ -> []

let take_last k l =
  List.fold_right
    (fun a (n, l) -> 
      if n = 0 
      then (n,      l)
      else (n-1, a::l)) 
    l (k, [])
  |> snd


(** {1 Various maps and sets} *)

module ID_Map = Map.Make(String)
module ID_Set = Set.Make(String)

module Int_Map = Map.Make(Int)
module Int_Set = Set.Make(Int)

module Type_Set = Set.Make(struct
  type t = Types.simple_type [@@deriving ord]
end)

module Type_Map = Map.Make(struct
  type t = Types.simple_type [@@deriving ord]
end)

module ID_Set_Map = Map.Make(ID_Set)
module Int_Set_Map = Map.Make(Int_Set)
module Type_Set_Map = Map.Make(Type_Set)

module Type_Tag_Map = Map.Make(struct
  type t = Types.type_tag [@@deriving ord]
end)

module Type_Tag_Pair_Map = Map.Make(struct
  type t = Types.type_tag * Types.type_tag [@@deriving ord]
end)

module Field_Tags_Map = Map.Make(struct
  type t = Types.type_tag ID_Map.t [@@deriving ord]
end)

(**
  Functions to operate over any particular kind of set.
  Currently only includes a [powerset] function.
*)
module Set_Util (S : Set.S) = struct
    
  let powerset s =
    let open Diff_list in
    let diff =
      S.fold (fun elt pset -> pset ++ map (S.add elt) pset) s
      (pure S.empty) in
    to_list diff

end

module Map_Util(Val : Map.OrderedType)(M : Map.S) = struct

  module Invert_Map = Map.Make(Val)

  let invert (m : Val.t M.t) : M.key list Invert_Map.t =
    M.fold (fun k v ->
      Invert_Map.update v
        (function
        | None    -> Some [k]
        | Some ks -> Some (k :: ks)
        )
    ) m Invert_Map.empty

end


(**
  Pretty-printing
*)


module Set_Pretty (S : Set.S) = struct

  let pp_set pp_elem fmt set =
    match S.elements set with
    | [] -> Format.fprintf fmt "{}"
    | hd :: tl ->
    Format.fprintf fmt "{@[@,%a" pp_elem hd;
    tl |> List.iter (Format.fprintf fmt ";@ %a" pp_elem);
    Format.fprintf fmt "@]@,}"

end

module Map_Pretty (S : Map.S) = struct

  let pp_map pp_key pp_val fmt map =
    match S.bindings map with
    | [] -> Format.fprintf fmt "{}"
    | hd :: tl ->
    let pp_kv_pair fmt (k, v) =
      Format.fprintf fmt "%a -> %a"
        pp_key k 
        pp_val v
    in
    Format.fprintf fmt "{@[@,%a" pp_kv_pair hd;
    tl |> List.iter (Format.fprintf fmt ";@ %a" pp_kv_pair);
    Format.fprintf fmt "@]@,}"

end

let pp_pair pp_e1 pp_e2 fmt (e1, e2) =
  Format.fprintf fmt "(@[@,%a,@, %a@,@])"
    pp_e1 e1
    pp_e2 e2


let pp_id_set =
  let open Set_Pretty(ID_Set) in
  pp_set Format.pp_print_string

let pp_int_set =
  let open Set_Pretty(Int_Set) in
  pp_set Format.pp_print_int

let pp_type_set =
  let open Set_Pretty(Type_Set) in
  pp_set Types.pp_simple_type

let pp_type_map pp_val =
  let open Map_Pretty(Type_Map) in
  pp_map Types.pp_simple_type pp_val

let pp_id_map pp_val =
  let open Map_Pretty(ID_Map) in
  pp_map Format.pp_print_string pp_val

let pp_int_map pp_val =
  let open Map_Pretty(Int_Map) in
  pp_map Format.pp_print_int pp_val

let pp_id_set_map pp_val =
  let open Map_Pretty(ID_Set_Map) in
  pp_map pp_id_set pp_val

let pp_int_set_map pp_val =
  let open Map_Pretty(Int_Set_Map) in
  pp_map pp_int_set pp_val
  
let pp_type_set_map pp_val =
  let open Map_Pretty(Type_Set_Map) in
  pp_map pp_type_set pp_val

let pp_type_tag_map pp_val =
  let open Map_Pretty(Type_Tag_Map) in
  pp_map Types.pp_type_tag pp_val

let pp_type_tag_pair_map pp_val =
  let open Map_Pretty(Type_Tag_Pair_Map) in
  pp_map (pp_pair Types.pp_type_tag Types.pp_type_tag) pp_val

let pp_field_tags_map pp_val =
  let open Map_Pretty(Field_Tags_Map) in
  pp_map (pp_id_map Types.pp_type_tag) pp_val