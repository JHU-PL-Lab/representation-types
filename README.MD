

# Representation types

This repository contains the OCaml source code implementing
the eponymous theory describing how one can
implement a dynamic language in an efficient manner.

## Building

Building this code is known to work with `dune` v2.4.0 and `ocaml` 4.11.0 or newer.
The only `opam` dependencies are `menhir`, `ppx_deriving` and `ppx_inline_test`.

There is some support for AFL fuzzing, which optionally requires `afl-clang`. The
build profile `afl` should be used to activate this feature.

Some documentation of the overall module structure can be built with `dune build @doc`.

## Command-line usage

Accompanying the library are utils for interpreting and compiling programs
in the simple functional language this implements. Syntax for this language
can be seen in the benchmarks and tests (i.e. `tests/*.frl`).

- `src/cli/lti.exe` is an interpreter, and will output the abstract and concrete interpretation results of the source code given via stdin.
- `src/cli/lcc.exe` is the compiler, and outputs C code to stdout corresponding to the source code given via stdin.

Both can be executed or built as `dune` targets (e.g. `dune exec ./src/cli/lcc.exe`)

## Interactive usage

To get into an interactive top level with modules defined in this library
visible, use `dune utop . -- -rectypes`. The flag is required due to
certain implementation details (see the `Ast` module for specifics).

One can then start exploring the basic functionality with
```ocaml
open Layout  (* Main module named `Layout` for historical reasons *)
open Util_pp (* for automatic pretty-printing of data structures *)

Eval.full_analysis_of' Tests.t5 (* for example *)
```

## Benchmarking

A script has been provided to replicate the benchmarks included in the paper.
By running `./bench.fish`, All benchmarks which have `.py`, `.exs`, `.frl`, and `.input`
files will be compiled and executed to produce a `.json` file of results and a more
readable markdown table. Benchmarks for which a `.json` file already exists will be skipped so that existing results are not discarded.

This depends on the `fish` shell for the script (but it could be easily adapted to `sh`), and the `hyperfine` benchmarking tool to handle warmup runs, time measurement, averaging, etc. The benchmarks require some installation of `python3`, `pypy3`,
and `elixir`, as well as `gcc` and `libgc` to compile our generated C code.

A secondary tool `results_to_latex.py` is included to convert the JSON data into latex tables, graphs, or bar charts.
