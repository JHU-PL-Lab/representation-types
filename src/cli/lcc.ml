
open Layout
open Analysis
open Eval

let () =
  let text = Stdio.In_channel.input_all Stdio.stdin in
  let k = try int_of_string Sys.argv.(1) with _ -> 0 in
  try
    let prog = Tests.parse text in
    let analysis = full_analysis_of ~k prog in 
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

