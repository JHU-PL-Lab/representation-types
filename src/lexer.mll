{
  
  open Lexing
  open Parser

  exception Error

}

let digit = ['0'-'9']
let int = ('+' | '-')? digit+

let space = [' ' '\t' '\r' '\n']+

let letter = ['a'-'z' 'A'-'Z']

let ident = (letter | '_') (letter | digit | '_')* '\''*

rule read =
  parse
  | eof   { EOF }
  | space { read lexbuf }
  | int   { 
    (* In case the integer value itself is too large *)
    try INTEGER (lexeme lexbuf |> int_of_string)
    with Failure _ -> raise Error
  }

  | "(*"  { read_comment 0 lexbuf }
  | '*'  { UNIV_PAT }
  | '.'  { PROJ_DOT }
  | "==" { EQUALS }
  | '='  { GETS }
  | '<'  { LTHAN  }
  | '>'  { GTHAN  }
  | "<=" { LEQUAL }
  | ">=" { GEQUAL }
  | '('  { LPAREN }
  | ')'  { RPAREN }
  | '{'  { LBRACE }
  | '}'  { RBRACE }
  | ';'  { SEMICOLON }
  | ':'  { COLON }
  | '|'  { ALTERNATIVE }
  | "->" { ARROW }
  | '+'  { OP_PLUS }
  | '-'  { OP_MINUS }
  | '/'  { OP_DIVIDE }
  | '@'  { OP_APPEND }
  | ident {
      match lexeme lexbuf with
      | "and"    -> KW_AND
      | "else"   -> KW_ELSE
      | "end"    -> KW_END
      | "false"  -> KW_FALSE
      | "fun"    -> KW_FUN
      | "if"     -> KW_IF
      | "in"     -> KW_IN
      | "input"  -> KW_INPUT
      | "random" -> KW_RANDOM
      | "int"    -> KW_INT
      | "let"    -> KW_LET
      | "match"  -> KW_MATCH
      | "mod"    -> KW_MOD
      | "not"    -> KW_NOT
      | "or"     -> KW_OR
      | "then"   -> KW_THEN
      | "true"   -> KW_TRUE
      | "with"   -> KW_WITH
      | other    -> IDENTIFIER(other)
    }
  | _ { raise Error }

and read_comment depth =
  parse
  | eof  { EOF }
  | "(*" { read_comment (depth + 1) lexbuf }
  | "*)" {
    match depth with
    | 0 -> read lexbuf
    | n -> read_comment (n - 1) lexbuf
  }
  | _ { read_comment depth lexbuf }