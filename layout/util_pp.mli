
val pp_type_set : Format.formatter -> Util.Type_Set.t -> unit
  [@@ocaml.toplevel_printer]

val pp_id_set : Format.formatter -> Util.ID_Set.t -> unit
  [@@ocaml.toplevel_printer]

val pp_id_map :
  (Format.formatter -> 'a -> unit) ->
  Format.formatter -> 'a Util.ID_Map.t -> unit
  [@@ocaml.toplevel_printer]

val pp_id_set_map :
  (Format.formatter -> 'a -> unit) ->
  Format.formatter -> 'a Util.ID_Set_Map.t -> unit
  [@@ocaml.toplevel_printer]

