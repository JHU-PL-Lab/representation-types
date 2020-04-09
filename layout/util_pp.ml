
open Util

module Set_Pretty (S : Set.S) = struct

  let pp_set pp_elem fmt set =
    match S.elements set with
    | [] -> Format.pp_print_string fmt "{}";
    | hd :: tl ->
    Format.pp_print_char fmt '{';
    Format.pp_open_box fmt 0;
    Format.pp_print_cut fmt ();
    pp_elem fmt hd;
    tl |> List.iter (fun ty ->
      Format.pp_print_char fmt ';';
      Format.pp_print_space fmt ();
      pp_elem fmt ty;
    );
    Format.pp_close_box fmt ();
    Format.pp_print_cut fmt ();
    Format.pp_print_char fmt '}'

end

module Map_Pretty (S : Map.S) = struct

  let pp_map pp_key pp_val fmt map =
    match S.bindings map with
    | [] -> Format.pp_print_string fmt "{}"
    | hd :: tl ->
    let pp_kv_pair (k, v) =
      pp_key fmt k;
      Format.pp_print_string fmt " -> ";
      pp_val fmt v
    in
    Format.pp_print_char fmt '{';
    Format.pp_open_box fmt 0;
    Format.pp_print_cut fmt ();
    pp_kv_pair hd;
    tl |> List.iter (fun kv ->
      Format.pp_print_char fmt ';';
      Format.pp_print_space fmt ();
      pp_kv_pair kv;
    );
    Format.pp_close_box fmt ();
    Format.pp_print_cut fmt ();
    Format.pp_print_char fmt '}'

end

let pp_id_set =
  let open Set_Pretty(ID_Set) in
  pp_set Format.pp_print_string

let pp_int_set =
  let open Set_Pretty(Int_Set) in
  pp_set Format.pp_print_int

let pp_type_set =
  let open Set_Pretty(Type_Set) in
  pp_set Types.pp_simple_type

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

let pp_field_tags_map pp_val =
  let open Map_Pretty(Field_Tags_Map) in
  pp_map (pp_id_map Types.pp_type_tag) pp_val