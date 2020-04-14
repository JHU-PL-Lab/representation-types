{
  
  open Lexing
  open Parser

}

let digit = ['0'-'9']
let int = digit+

let space = [' ' '\t' '\n']+

let letter = ['a'-'z' 'A'-'Z']

let ident = letter (letter | digit | '_' )* '\''*

let comment_opener = "(*"


rule read =
  parse
  | space { read lexbuf }
  | eof   { EOF }
  | int   { INTEGER (lexeme lexbuf |> int_of_string) }
  | "(*"  { read_comment 0 lexbuf }
  | '*' { UNIV_PAT }
  | '.' { PROJ_DOT }
  | "==" { EQUALS }
  | '=' { GETS }
  | '<' { LTHAN  }
  | '(' { LPAREN }
  | ')' { RPAREN }
  | '{' { LBRACE }
  | '}' { RBRACE }
  | ';' { SEMICOLON }
  | ':' { COLON }
  | '|' { ALTERNATIVE }
  | "->" { ARROW }
  | '+' { OP_PLUS }
  | '-' { OP_MINUS }
  | ident {
    match lexeme lexbuf with
    | "and"   -> KW_AND
    | "end"   -> KW_END
    | "false" -> KW_FALSE
    | "fun"   -> KW_FUN
    | "in"    -> KW_IN
    | "int"   -> KW_INT
    | "let"   -> KW_LET
    | "match" -> KW_MATCH
    | "not"   -> KW_NOT
    | "or"    -> KW_OR
    | "true"  -> KW_TRUE
    | "with"  -> KW_WITH
    | other   -> IDENTIFIER(other)
  }

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