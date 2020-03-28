{
  open Lexing
  open Parser

  type exn +=
    | Lexing_error of string
    ;;
}

let digit = ['0' - '9']
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
    | "fun"   -> KW_FUN
    | "match" -> KW_MATCH
    | "with"  -> KW_WITH
    | "and"   -> KW_AND
    | "true"  -> TRUE
    | "false" -> FALSE
    | "or"    -> KW_OR
    | "not"   -> KW_NOT
    | "let"   -> KW_LET
    | "in"    -> KW_IN
    | "end"   -> KW_END
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