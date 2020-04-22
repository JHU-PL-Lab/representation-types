
open Util

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



let pp_type_tag = Types.pp_type_tag

let pp_simple_type = Types.pp_simple_type


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