

type 'a formatter
  = Format.formatter -> 'a -> unit

type ('a, 'b) formatter1
  = 'a formatter -> 'b formatter


let pp_type_tag     = Types.pp_type_tag
let pp_simple_type  = Types.pp_simple_type

let pp_operator     = Ast.pp_operator
let pp_value        = Ast.pp_value
let pp_body         = Ast.pp_body
let pp_clause       = Ast.pp_clause
let pp_rvalue'      = Ast.pp_rvalue'
let pp_rvalue_spec  = Ast.pp_rvalue_spec

let pp_id_set       = Util.pp_id_set
let pp_int_set      = Util.pp_int_set
let pp_type_set     = Util.pp_type_set
let pp_type_map     = Util.pp_type_map
let pp_id_map       = Util.pp_id_map
let pp_int_map      = Util.pp_int_map
let pp_id_set_map   = Util.pp_id_set_map
let pp_type_set_map = Util.pp_type_set_map
let pp_type_tag_map = Util.pp_type_tag_map

let pp_type_tag_pair_map = Util.pp_type_tag_pair_map
let pp_field_tags_map    = Util.pp_field_tags_map
