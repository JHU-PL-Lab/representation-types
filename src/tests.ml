
(**
  Regression and correctness tests.
  The primary purpose is to check that
  the naive, untagged interpreter agrees with
  the tagged interpreter on the values of expressions.
*)

open Analysis
open Eval
open Types
open Ast

(**
  Helper to parse a nicer syntax into {!Ast.expr} form.
*)
let parse s =
  Parser.main Lexer.read (Lexing.from_string s)


let test_eval_tagged ?(input = random_input ~upper_bound:10000) expr =
  let analysis = full_analysis_of ~k:1 expr in
  try ignore (TaggedEvaluator.eval expr input analysis); true with
  | Interpreters_Out_Of_Step -> false

  

(* 1 : basic operations *)
let t1 = parse "
  let x = 10 in
  let y = 20 in
    x + y
"

(* 2 : closures *)
let t2 = parse "
  let f1 = fun a1 -> fun a2 ->
    a1 + a2
  in

  let f3 = f1 10 in

  let x1 = f3 20 in
  let x3 = f3 200 in
    x3
"

(* 3 : records *)
let t3 = parse "
  let t = true in
  let f = false in

  let r = { x = { a = t; b = f } } in
  let q = r.x.b in
    q
"

(* 4 : y-combinator *)
let t4 = parse "
  let y = fun f ->
    let o = fun x -> f (fun arg -> x x arg)
    in o o   
  in

  let sum = y (fun sum -> fun n ->
    match n == 0 with
    | false -> n + sum (n - 1)
    | true  -> 0
    end
  ) in

  sum 10
"

(* 5 : records and pattern matching *)
let t5 = parse "
  let f = fun x ->
    match x with
    | {a: int; b: int} -> x.b
    | {a: int}         -> x.a
    | {a: int; c: int} -> x.c (* should never match! *)
    end
  in

  let x1 = f { a = 10 } in
  let x2 = f { a = 10; b = 20 } in
  let x3 = f { a = 10; c = 30; d = 50 } in
    x1 + x2 + x3
"

(* 6 : polymorphic record field projections *)
let t6 = parse "
  let f = fun r ->
    { a = r.a }
  in

  let x1 = f { a = 10 } in
  let x2 = f { a = false } in
  let x3 = f { a = { a = 15 } } in
  let x4 = f { b = { c = 10 }; a = { x = false } } in
    x1.a + x3.a.a
"

(* 7 : building and folding a list *)
let t7 = parse "
  let y = fun f ->
    let o = fun x -> f (fun arg -> x x arg)
    in o o   
  in
  
  let make = y (fun make -> fun n ->
    match n == 0 with
    | true  -> { hd = n; tl = false }
    | false -> { hd = n; tl = make (n - 1) }
    end
  ) in

  let sum = y (fun sum -> fun r ->
    match r with
    | { hd: int; tl: * } -> r.hd + sum r.tl
    | * -> 0
    end
  ) in

  sum (make 10) + sum (make 20)
"

let t7' = parse "
    let make = fun n ->
      if n == 0 then {} else { hd = n; tl = make (n - 1) }
    in
    let sum = fun l ->
      match l with
      | { hd: int; tl: * } -> l.hd + sum l.tl
      | {} -> 0
      end
    in
    sum (make 10) + sum (make 20)
"

(* 8 : test for match pattern depth calculation *)
let t8 = parse "
  match {} with
  (* {a -> 2} *)
  | { a: { a: { a: * } } } -> 0 
  
  (* {a -> 2}; {b -> 1} *)
  | { a: { a: { a: * }; b: { b: * } }} -> 0

  (* {a -> 3}; {b -> 4} *)
  | { b: { a: { a: { a: { a: * }}}}} -> 0
  
  | * -> 0
  end
"

(* 9 : test for pattern match subtyping depth requirement *)
let t9 = parse "
  match {d = {f = 0}; e = 0} with
  | {b: {b: *}} -> 0
  | {a: {a: {a: *}; b: *}; b: *} -> 0
  | {a: *; b: *; c: *} -> 0
  | {b: *; c: *} -> 0
  | {d: *; e: *} -> 0
  | * -> 0
  end
"

(* 10 : worst case record tables *)
let t10 = parse "
  let f = fun x -> x in

  (*
    In absence of inlining of f, this
    causes the types of x1..x3 to be
    the same.
  *)
  let x1 = f true in
  let x2 = f false in
  let x3 = f true in

  let r = { a = x1; b = x2; c = x3 } in

  match r with
  | { a: false; b: false; c: false } -> 0
  | { a: false; b: false; c: true  } -> 1
  | { a: false; b: true;  c: false } -> 2
  | { a: false; b: true;  c: true  } -> 3
  | { a: true;  b: false; c: false } -> 4
  | { a: true;  b: false; c: true  } -> 5
  | { a: true;  b: true;  c: false } -> 6
  | { a: true;  b: true;  c: true  } -> 7
  end
"

(* 11 : basic record appending *)
let t11 = parse "
  let r1 = { a = 10; b = 20 } in
  let r2 = { a = {}; c = false } in
  let r3 = { b = 30; c = true } in
  r1 @ r2 @ r3
"

(* 12 : OO-like record methods *)
let t12 = parse "
  let r1 = {
    x = fun this -> this.y this + this.z this;
    y = fun this -> this.z this + this.z this;
    z = fun this -> 10
  } in

  let r2 = fun super -> super @ {
    y = fun this -> super.y this - this.w this;
    w = fun this -> 1
  } in

  let get_x = fun r -> r.x r in

  let x1 = get_x r1 in
  let x2 = get_x (r2 r1) in
  let x3 = get_x (r2 (r2 r1)) in
  x1 + x2 + x3
"

(* 13 : match on appended records *)
let t13 = parse "
  let defaults = { f1 = false; f2 = true } in
  let to_num = fun r ->
    match defaults @ r with
    | { f1 : false; f2 : false } -> 0
    | { f1 : false; f2 : true  } -> 1
    | { f1 : true;  f2 : false } -> 2
    | { f1 : true;  f2 : true  } -> 3
    end
  in
    to_num {}
  + to_num { f1 = true }
  + to_num { f1 = false; f2 = false }
  + to_num { f3 = 30 }
"

(* 14 : match on chained record appends *)
let t14 = parse "
  let append3 = 
    fun r1 -> fun r2 -> fun r3 ->
      r1 @ r2 @ r3
  in

  let do_match = fun r ->
    match r with
    | { a: *; b: *; c: * } -> 0
    | { a: *; b: *; d: * } -> 1
    | { a: *; c: *; d: * } -> 2
    | { b: *; c: *; d: * } -> 3
    | * -> 4
    end
  in

  let x1 = { a = 1 } in
  let x2 = { b = 2 } in
  let x3 = { c = 3 } in
  let x4 = { d = 4 } in

  do_match (append3 x1 x2 x3) +
  do_match (append3 x1 x2 x4) +
  do_match (append3 x1 x3 x4) +
  do_match (append3 x2 x3 x4)
"

let%test_module "interpreter validation" = (module struct

  let%test "t1 (basic operations)" = test_eval_tagged t1
  
  let%test "t2 (closures)" = test_eval_tagged t2

  let%test "t3 (records)" = test_eval_tagged t3

  let%test "t4 (y-combinator)" = test_eval_tagged t4

  let%test "t5 (patterns)" = test_eval_tagged t5

  let%test "t6 (projections)" = test_eval_tagged t6

  let%test "t7 (making/folding lists)" = test_eval_tagged t7

  let%test "t8 (match depth calculation)" = test_eval_tagged t8

  let%test "t9 (match subtype depth)" = test_eval_tagged t9

  let%test "t10 (exponential record table)" = test_eval_tagged t10
  
  let%test "t11 (basic record appending)" = test_eval_tagged t11
  
  let%test "t12 (OO-like record methods)" = test_eval_tagged t12

  let%test "t13 (match on appended records)" = test_eval_tagged t13

  let%test "t14 (match on chained record appends)" = test_eval_tagged t14
  
end)
