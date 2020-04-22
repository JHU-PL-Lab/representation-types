%{

  open Types
  open Ast
  open Classes

  open Util
  module Util = Parser_util
  open Parser_util

  open Traversable_Util(Lists)
  open Make_Traversable(PState)

  open PState
  open PState.Syntax

%}


%token <int> INTEGER

%token KW_TRUE
%token KW_FALSE

%token <Ast.ident> IDENTIFIER

%token EOF

%token LBRACE RBRACE LPAREN RPAREN SEMICOLON COLON
%token LTHAN EQUALS PROJ_DOT GETS

%token OP_PLUS OP_MINUS OP_APPEND UNIV_PAT

%token KW_MATCH KW_WITH KW_FUN KW_AND KW_OR KW_NOT
%token KW_LET KW_IN KW_END KW_INT
%token ALTERNATIVE ARROW

%start <Ast.expr> main

%%

let main :=
  | ~ = ssa; EOF; { run_pstate ssa }

let ident ==
  | i = IDENTIFIER; { lookup i }

let binding ==
  | i = IDENTIFIER; { fresh' i }

let pattern_type :=
  | KW_TRUE;  { TTrue  }
  | KW_FALSE; { TFalse }
  | KW_INT;   { TInt   }
  | KW_FUN;   { TFun   }
  | UNIV_PAT; { TUniv  }
  | LBRACE; fields = separated_list(SEMICOLON, record_field_type); RBRACE;
    { TRec fields }

let record_field_type ==
  separated_pair(IDENTIFIER, COLON, pattern_type)

let ssa ==
  | ~ = expr; {
    new_block @@
      let* ret_id = fresh "" in
      let* expr = expr in
      let* () = emit @@ Cl (ret_id, expr) in
      let+ emitted = get |> map (fun s -> s.emitted) in
        Diff_list.to_list emitted
  }

let clause ==
  | KW_LET; id = binding; GETS; body = expr0; KW_IN; {
      let* body = body in
      let* id = id in
      emit @@ Cl (id, body)
  }

let expr ==
  | clauses = clause*; body = expr0; {
    let* _ = sequence clauses in
      body
  }

let sep_pair(e1, sep, e2) == separated_pair(e1, sep, e2)

let expr0 :=
  | KW_FUN; arg = IDENTIFIER; ARROW; body = ssa; 
    {
      let* arg' = fresh arg in
      let+ body = add_to_env arg arg' @@ body in
      BVal (VFun (arg', body))
    }
  | KW_MATCH; disc = expr1; KW_WITH; 
    ALTERNATIVE?; branches = separated_list(ALTERNATIVE, match_branch);
    KW_END;
    {
      let+ id = emit' disc
      and+ branches =
        branches |> traverse (fun (ty, branch) ->
          let+ branch = branch in (ty, branch)
        )
      in BMatch (id, branches)
    }
  | ~ = expr1; <>

let match_branch ==
  separated_pair(pattern_type, ARROW, ssa)

let expr1 :=
  | (e1, e2) = sep_pair(expr1, KW_AND, expr2); {
    let+ i1 = emit' e1
    and+ i2 = emit' e2
    in BOpr (OAnd (i1, i2))
  }
  | (e1, e2) = sep_pair(expr1, KW_OR, expr2); {
    let+ i1 = emit' e1
    and+ i2 = emit' e2
    in BOpr (OOr (i1, i2))
  }
  | ~ = expr2; <>

let expr2 :=
  | (e1, e2) = sep_pair(expr3, LTHAN, expr3); {
    let+ i1 = emit' e1
    and+ i2 = emit' e2
    in BOpr (OLess (i1, i2))
  }
  | (e1, e2) = sep_pair(expr3, EQUALS, expr3); {
    let+ i1 = emit' e1
    and+ i2 = emit' e2
    in BOpr (OEquals (i1, i2))
  }
  | ~ = expr3; <>

let expr3 :=
  | (e1, e2) = sep_pair(expr3, OP_PLUS, expr4); {
    let+ i1 = emit' e1
    and+ i2 = emit' e2
    in BOpr (OPlus (i1, i2))
  }
  | (e1, e2) = sep_pair(expr3, OP_MINUS, expr4); {
    let+ i1 = emit' e1
    and+ i2 = emit' e2
    in BOpr (OMinus (i1, i2))
  }
  | (e1, e2) = sep_pair(expr3, OP_APPEND, expr4); {
    let+ i1 = emit' e1
    and+ i2 = emit' e2
    in BOpr (OAppend (i1, i2))
  }
  | KW_NOT; e1 = expr4; {
    let+ i1 = emit' e1
    in BOpr (ONot i1)
  }
  | ~ = expr4; <>

let expr4 :=
  | (e1, e2) = pair(expr4, expr5); {
    let+ i1 = emit' e1
    and+ i2 = emit' e2
    in BApply (i1, i2)
  }
  | ~ = expr5; <>

let expr5 :=
  | e1 = expr5; PROJ_DOT; field = IDENTIFIER; {
    let+ i1 = emit' e1
    in BProj (i1, field)
  }
  | LPAREN; ~ = expr; RPAREN; <>
  | lit = literal; { let+ lit = lit in BVal lit }
  | id = ident;    { let+ id =  id  in BVar id }

let literal :=
  | i = INTEGER; { pure (VInt i) }
  | KW_TRUE;     { pure VTrue }
  | KW_FALSE;    { pure VFalse }
  | LBRACE; fields = separated_list(SEMICOLON, record_field_literal); RBRACE;
    {
      let+ fields = sequence fields
      in VRec fields
    }
  

let record_field_literal ==
  | field = IDENTIFIER; GETS; expr = expr; {
    let+ id = emit' expr
    in (field, id)
  }