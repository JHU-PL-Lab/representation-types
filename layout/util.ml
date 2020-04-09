
(*
  List representation
  with constant-time prepend, append, map, and concatenate.
  Conversion to regular lists in O(n) once done.
*)
module Diff_list = struct
  type 'a t =
    { fold : 'b. ('a -> 'b -> 'b) -> 'b -> 'b }

  let cons a l =
    { fold = fun c n -> c a (l.fold c n) }

  let nil =
    { fold = fun _ n -> n }

  let (++) l1 l2 =
    { fold = fun c n -> l1.fold c (l2.fold c n) }

  let to_list l1 =
    l1.fold (fun x xs -> x :: xs) []

  let concat ll1 =
    ll1.fold (++) nil

  let map f l =
    { fold = fun c n -> l.fold (fun a b -> c (f a) b) n }

  let pure a = cons a nil

  let snoc l a =
    l ++ pure a
end

(*
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


module ID_Map = Map.Make(String)
module ID_Set = Set.Make(String)

module Int_Map = Map.Make(Int)
module Int_Set = Set.Make(Int)

module Type_Set = Set.Make(struct
  type t = Types.simple_type
  let compare = Types.compare_simple_type
end)

module ID_Set_Map = Map.Make(ID_Set)
module Type_Set_Map = Map.Make(Type_Set)

module Type_Tag_Map = Map.Make(struct
  type t = Types.type_tag
  let compare = Types.compare_type_tag
end)

module Field_Tags_Map = Map.Make(struct
  type t = Types.type_tag ID_Map.t
  let compare = ID_Map.compare Types.compare_type_tag
end)


module Set_Util (S : Set.S) = struct

  let powerset s =
    let open Diff_list in
    let diff =
      S.fold (fun elt pset -> pset ++ map (S.add elt) pset) s
      (pure S.empty) in
    to_list diff

end