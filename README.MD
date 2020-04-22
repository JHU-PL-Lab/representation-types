
# Layout types

This repository contains the OCaml source code implementing
parts of an (as yet underspecified) theory describing how one might
implement a dynamic language in an efficient manner.

## Building

Building this code requires `dune` v2.4.0 and `ocaml` 4.09.0 or newer.

Documentation for viewing the overall module structure and comments
can be built with `dune build @doc`.

## Toplevel usage

To get into an interactive top level with modules defined in this library
visible, use `dune utop . -- -rectypes`. The flag is required due to
certain implementation details (see the `Ast` module for specifics).

One can then start exploring the basic functionality here so far with
```ocaml
open Layout
open Util_pp (* for automatic pretty-printing of data structures *)

Eval.full_analysis_of' Tests.t5 (* for example *)
```