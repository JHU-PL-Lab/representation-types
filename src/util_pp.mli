
(**
  Pretty-printers for all of the
  instantiations of {!Stdlib.Map} and {!Stdlib.Set}
  found in {!Layout.Util}.

  These are automatically installed in the toplevel
  when this module is opened, thanks to the {i really}
  convenient [[@@ocaml.toplevel_printer]] annotation.
*)

val pp_id_set : Format.formatter -> Util.ID_Set.t -> unit
  [@@ocaml.toplevel_printer]

val pp_int_set : Format.formatter -> Util.Int_Set.t -> unit
  [@@ocaml.toplevel_printer]

val pp_type_set : Format.formatter -> Util.Type_Set.t -> unit
  [@@ocaml.toplevel_printer]

val pp_type_map :
  (Format.formatter -> 'a -> unit) ->
  Format.formatter -> 'a Util.Type_Map.t -> unit
  [@@ocaml.toplevel_printer]

val pp_id_map :
  (Format.formatter -> 'a -> unit) ->
  Format.formatter -> 'a Util.ID_Map.t -> unit
  [@@ocaml.toplevel_printer]

val pp_int_map :
  (Format.formatter -> 'a -> unit) ->
  Format.formatter -> 'a Util.Int_Map.t -> unit
  [@@ocaml.toplevel_printer]

val pp_id_set_map :
  (Format.formatter -> 'a -> unit) ->
  Format.formatter -> 'a Util.ID_Set_Map.t -> unit
  [@@ocaml.toplevel_printer]

val pp_type_set_map :
  (Format.formatter -> 'a -> unit) ->
  Format.formatter -> 'a Util.Type_Set_Map.t -> unit
  [@@ocaml.toplevel_printer]

val pp_type_tag_map :
  (Format.formatter -> 'a -> unit) ->
  Format.formatter -> 'a Util.Type_Tag_Map.t -> unit
  [@@ocaml.toplevel_printer]

val pp_field_tags_map :
  (Format.formatter -> 'a -> unit) ->
  Format.formatter -> 'a Util.Field_Tags_Map.t -> unit
  [@@ocaml.toplevel_printer]