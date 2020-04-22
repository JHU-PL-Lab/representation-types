
(**
  Pretty-printers for all of the
  instantiations of {!Stdlib.Map} and {!Stdlib.Set}
  found in {!Layout.Util} (among other things).

  These are automatically installed in the toplevel
  when this module is opened, thanks to the {i really}
  convenient [[@@ocaml.toplevel_printer]] annotation.
*)


(**
  Type abbreviations so I don't go insane.
*)

type 'a formatter
  = Format.formatter -> 'a -> unit

type ('a, 'b) formatter1
  = 'a formatter -> 'b formatter


val pp_type_tag : Types.type_tag formatter
  [@@ocaml.toplevel_printer]

val pp_simple_type : Types.simple_type formatter
  [@@ocaml.toplevel_printer]

val pp_operator : Ast.operator formatter
  [@@ocaml.toplevel_printer]

val pp_value : Ast.value formatter
  [@@ocaml.toplevel_printer]

val pp_body : Ast.body formatter
  [@@ocaml.toplevel_printer]

val pp_clause : Ast.clause formatter
  [@@ocaml.toplevel_printer]

val pp_rvalue' : Ast.rvalue' formatter
  [@@ocaml.toplevel_printer]

val pp_rvalue_spec : ('a, 'a Ast.rvalue_spec) formatter1
  [@@ocaml.toplevel_printer]
  

val pp_id_set : Util.ID_Set.t formatter
  [@@ocaml.toplevel_printer]

val pp_int_set : Util.Int_Set.t formatter
  [@@ocaml.toplevel_printer]

val pp_type_set : Util.Type_Set.t formatter
  [@@ocaml.toplevel_printer]

val pp_type_map : ('a, 'a Util.Type_Map.t) formatter1
  [@@ocaml.toplevel_printer]

val pp_id_map : ('a, 'a Util.ID_Map.t) formatter1
  [@@ocaml.toplevel_printer]

val pp_int_map : ('a, 'a Util.Int_Map.t) formatter1
  [@@ocaml.toplevel_printer]

val pp_id_set_map : ('a, 'a Util.ID_Set_Map.t) formatter1
  [@@ocaml.toplevel_printer]

val pp_type_set_map : ('a, 'a Util.Type_Set_Map.t) formatter1
  [@@ocaml.toplevel_printer]

val pp_type_tag_map : ('a, 'a Util.Type_Tag_Map.t) formatter1
  [@@ocaml.toplevel_printer]

val pp_type_tag_pair_map : ('a, 'a Util.Type_Tag_Pair_Map.t) formatter1
  [@@ocaml.toplevel_printer]

val pp_field_tags_map : ('a, 'a Util.Field_Tags_Map.t) formatter1
  [@@ocaml.toplevel_printer]
