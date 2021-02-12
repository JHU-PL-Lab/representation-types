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
%token LTHAN GTHAN EQUALS LEQUAL GEQUAL PROJ_DOT GETS

%token OP_PLUS OP_MINUS OP_DIVIDE OP_APPEND UNIV_PAT

%token KW_MATCH KW_WITH KW_FUN KW_AND KW_OR KW_NOT KW_MOD
%token KW_LET KW_IN KW_END KW_INT KW_INPUT KW_IF KW_THEN KW_ELSE KW_RANDOM
%token ALTERNATIVE ARROW

%start <Ast.expr> main

%%

let separated_list_trailing1(sep, elem) :=
  | { [] }
  | first = elem; sep; rest = separated_list_trailing(sep, elem); { first :: rest }

let separated_list_trailing(sep, elem) :=
  | { [] }
  | rest = separated_nonempty_list_trailing(sep, elem); { rest }

let separated_nonempty_list_trailing(sep, elem) :=
  | ~ = elem; { [elem] }
  | ~ = elem; sep; rest = option(separated_nonempty_list_trailing(sep, elem));
  {
    match rest with
    | None -> [elem]
    | Some(rest) -> elem :: rest
  }


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
  | ~ = record_type; <>
  
  
let record_type ==
  | LBRACE; fields = separated_list_trailing(SEMICOLON, record_field_type); RBRACE;
    { TRec (None, fields) }
  | LPAREN; fields = separated_list_trailing(SEMICOLON, tuple_field_type); RPAREN;
    { 
      TRec (None, snd @@ 
        List.fold_left
          begin fun (ct, list) field -> match field with
          | `Ordered ty -> (ct + 1, ("_" ^ string_of_int ct, ty) :: list)
          | `Tagged pair -> (ct, pair :: list)
          end
        (0, [])
        fields)
    }

let record_field_type ==
  | pair = separated_pair(IDENTIFIER, COLON, pattern_type); { pair }
  | PROJ_DOT; tag_name = IDENTIFIER; { (tag_name, TRec (None, [])) }

let tuple_field_type ==
  | ~ = pattern_type; {  
    `Ordered pattern_type
  }
  | PROJ_DOT; tag_name = IDENTIFIER; { 
    `Tagged (tag_name, TRec (None, [])) 
  }

let ssa ==
  | ~ = expr; {
    new_block @@
      let* ret_id = fresh "" in
      let* expr = expr in
      let* () = emit @@ Cl (ret_id, expr) in
      let+ emitted = gets (fun s -> s.emitted) in
        Diff_list.to_list emitted
  }

let clause ==
  | KW_LET; id = binding; GETS; body = expr0; KW_IN; {
      let* id = id in
      let* body = body in
      emit @@ Cl (id, body)
  }

let expr ==
  | clauses = clause*; body = expr0; {
    sequence clauses *> body
  }

let sep_pair(e1, sep, e2) == separated_pair(e1, sep, e2)

let expr0 :=
  | KW_FUN; args = nonempty_list(IDENTIFIER); ARROW; body = ssa; 
    {
      let arg0, argsN = List.hd args, List.tl args in
      let setup_args = List.fold_right
        (fun arg body ->
          new_block @@
            let* ret_id = fresh "" in
            let* arg' = fresh arg in
            let* body = add_to_env arg arg' body in
            let* () = emit @@ Cl (ret_id, BVal (VFun (arg', body))) in
            let+ emitted = gets (fun s -> s.emitted) in
            Diff_list.to_list emitted)
        argsN body
      in
      let* arg0' = fresh arg0 in
      let+ body = add_to_env arg0 arg0' @@ setup_args in
      BVal (VFun (arg0', body))
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
  | KW_IF; cond = expr1; KW_THEN; tru = ssa; KW_ELSE; fal = ssa;
    {
      let+ id = emit' cond
      and+ tru = tru
      and+ fal = fal
      in BMatch (id, [
        (TTrue, tru);
        (TFalse, fal);
      ])
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
  | (e1, e2) = sep_pair(expr3, GTHAN, expr3); {
    let* i1 = emit' e1 in
    let* i2 = emit' e2 in
    let* il = emit_pure' @@ BOpr (OLess (i1, i2)) in
    let* ie = emit_pure' @@ BOpr (OEquals (i1, i2)) in
    let+ io = emit_pure' @@ BOpr (OOr (il, ie)) in
    BOpr (ONot io)
  }
  | (e1, e2) = sep_pair(expr3, LEQUAL, expr3); {
    let* i1 = emit' e1 in
    let* i2 = emit' e2 in
    let* il = emit_pure' @@ BOpr (OLess (i1, i2)) in
    let+ ie = emit_pure' @@ BOpr (OEquals (i1, i2)) in
    BOpr (OOr (il, ie))
  }
  | (e1, e2) = sep_pair(expr3, GEQUAL, expr3); {
    let* i1 = emit' e1 in
    let* i2 = emit' e2 in
    let+ il = emit_pure' @@ BOpr (OLess (i1, i2)) in
    BOpr (ONot il)
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
  | ~ = expr4; <>

let expr4 :=
  | (e1, e2) = sep_pair(expr4, OP_APPEND, expr5); {
    let+ i1 = emit' e1
    and+ i2 = emit' e2
    in BOpr (OAppend (i1, i2))
  }
  | (e1, e2) = sep_pair(expr4, UNIV_PAT, expr5); {
    let+ i1 = emit' e1
    and+ i2 = emit' e2
    in BOpr (OTimes (i1, i2))
  }
  | (e1, e2) = sep_pair(expr4, OP_DIVIDE, expr5); {
    let+ i1 = emit' e1
    and+ i2 = emit' e2
    in BOpr (ODivide (i1, i2))  
  }
  | (e1, e2) = sep_pair(expr4, KW_MOD, expr5); {
    let+ i1 = emit' e1
    and+ i2 = emit' e2
    in BOpr (OModulo (i1, i2))  
  }
  | KW_NOT; e1 = expr5; {
    let+ i1 = emit' e1
    in BOpr (ONot i1)
  }
  | ~ = expr5; <>

let expr5 :=
  | (e1, e2) = pair(expr5, expr6); {
    let+ i1 = emit' e1
    and+ i2 = emit' e2
    in BApply (i1, i2)
  }
  | OP_MINUS; e1 = expr6; {
    let+ i1 = emit' e1
    in BOpr (ONeg i1)
  }
  | ~ = expr6; <>

let expr6 := 
  | e1 = expr6; PROJ_DOT; field = record_proj_name; {
    let+ i1 = emit' e1
    in BProj (i1, field)
  }
  | LPAREN; ~ = expr; RPAREN; <>
  | KW_INPUT;      { pure BInput }
  | KW_RANDOM;     { pure BRandom }
  | lit = literal; { let+ lit = lit in BVal lit }
  | id = ident;    { let+ id =  id  in BVar id }

let literal :=
  | i = INTEGER; { pure (VInt i) }
  | KW_TRUE;     { pure VTrue }
  | KW_FALSE;    { pure VFalse }
  | ~ = record_literal; <>
  

let record_literal :=
  | LBRACE; fields = separated_list_trailing(SEMICOLON, record_field_literal); RBRACE;
    {
      let+ fields = sequence fields in
      VRec fields
    } 
  | LPAREN; exprs = separated_list_trailing1(SEMICOLON, tuple_field_literal); RPAREN;
    {
      let+ exprs = sequence exprs in
      VRec (snd @@ 
        List.fold_left
          begin fun (ct, list) field -> match field with
          | `Ordered expr -> (ct + 1, ("_" ^ string_of_int ct, expr) :: list)
          | `Tagged pair -> (ct, pair :: list)
          end
        (0, [])
        exprs)
    }

let record_proj_name ==
  | field = IDENTIFIER; { field }
  | field = INTEGER;    { "_" ^ string_of_int field }

let tuple_field_literal ==
  | ~ = expr; { 
    let+ id = emit' expr 
    in `Ordered id 
  }
  | PROJ_DOT; tag_name = IDENTIFIER; { 
    let+ id = emit_pure' @@ BVal (VRec [])
    in `Tagged (tag_name, id) 
  }

let record_field_literal ==
  | PROJ_DOT; tag_name = IDENTIFIER; {
    let+ id = emit_pure' @@ BVal (VRec [])
    in (tag_name, id)
  }
  | field = IDENTIFIER; GETS; expr = expr; {
    let+ id = emit' expr
    in (field, id)
  }