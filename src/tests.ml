
let parse s =
  Parser.main Lexer.read (Lexing.from_string s)


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

(* building and folding a list *)
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

(* test for match pattern depth calculation *)
let t8 = parse "
  match {} with
  (* {a} -> {a -> 3} *)
  | { a: { a: { a: * } } } -> 0 

  (* {b} -> {b -> 5}; {a} -> {a -> 4} *)
  | { b: { a: { a: { a: { a: * }}}}} -> 0

  (*
    shape {a; b} is distinct from {a} or {b}
    but: it's a subtype of both, inheriting constraints:
    {a; b} -> {a -> 4; b -> 5}
  *)
  | { a: { a: { a: * }; b: { b: * } }} -> 0
  
  | * -> 0
  end
"

(* test for pattern match subtyping depth requirement *)
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

(* worst case record tables *)
let t10 = parse "
  let f = fun r -> r in

  (*
    In absence of inlining of f, this
    causes the types of x1..x3 to be
    the same.
  *)
  let x1 = f true in
  let x2 = f false in
  let x3 = f true in

  (*
    Therefore although r only ever has type
     {a: true; b: false; c: true},
    it must create a retagging constructor
    which maps each of the 2^3 possibilities.
    All but one will be failure states.
  *)
  let r = { a = x1; b = x2; c = x3 } in

  (*
    On the other hand, because we know
    r's more precise type, this match only
    needs to store a table of size 1.
    We could eliminate all other
    branches semi-statically as dead code. 
  *)
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

let%test_module "interpreter validation" = (module struct
  
  let test_equal_result expr =
    let open Eval in
    let analysis = full_analysis_of expr in
    let (_, rv) = TaggedEvaluator.eval expr analysis in
    (analysis.result = rv) 

  let%test "t1 (basic operations)" = test_equal_result t1
  
  let%test "t2 (closures)" = test_equal_result t2

  let%test "t3 (records)" = test_equal_result t3

  let%test "t4 (y-combinator)" = test_equal_result t4

  let%test "t5 (patterns)" = test_equal_result t5

  let%test "t6 (projections)" = test_equal_result t6

  let%test "t7 (making/folding lists)" = test_equal_result t7

  let%test "t8 (match depth calculation)" = test_equal_result t8

  let%test "t9 (match subtype depth)" = test_equal_result t9

  let%test "t10 (exponential record table)" = test_equal_result t10
  
end)
