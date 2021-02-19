
open Layout
open Analysis
open Eval

let k = ref 0

let () =
  Arg.parse [
    "-k",    Arg.Set_int k,       "Context sensitivity for analysis.";
    (* "--box", Arg.Set boxing_mode, "Change calling convention to use more pointers."; *)
  ] 
  print_endline
  "C transpiler for layout types.";
  try
    let text = Stdio.In_channel.input_all Stdio.stdin in
    let prog = Tests.parse text in
    let analysis = full_analysis_of ~k:(!k) prog in 
    print_string @@ Compiler.C.compile_string ~analysis prog  
  with
    | Compiler.Open_Expression
    | Analysis.Open_Expression   
    | Eval.Open_Expression ->
        Format.eprintf "error: Open Expression.\n"
    
    | Compiler.Type_Mismatch
    | Analysis.Type_Mismatch     
    | Eval.Type_Mismatch ->
        Format.eprintf "error: Type Mismatch.\n"

    | Compiler.Match_Fallthrough
    | Analysis.Match_Fallthrough 
    | Eval.Match_Fallthrough ->
        Format.eprintf "error: Match Fallthrough.\n"
    
    | Parser.Error ->
        Format.eprintf "error: Parse Error.\n"
    | Lexer.Error ->
        Format.eprintf "error: Lexing Error.\n"

