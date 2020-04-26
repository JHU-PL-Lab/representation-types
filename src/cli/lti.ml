
open Layout


let () =
  let text = Stdio.In_channel.input_all Stdio.stdin in
  try
    let prog = Tests.parse text in
    let full = Eval.full_analysis_of prog in 
    Format.printf "%a\n" Util_pp.pp_rvalue' full.result
  with
    | Eval.FlowTracking.Open_Expression ->
        Format.eprintf "error: Open Expression."
    | Eval.FlowTracking.Type_Mismatch ->
        Format.eprintf "error: Type Mismatch."
    | Eval.FlowTracking.Match_Fallthrough ->
        Format.eprintf "error: Match Fallthrough."
    | Eval.FlowTracking.Empty_Expression ->
        Format.eprintf "error: Empty Expression (!?)."
    | Parser.Error ->
        Format.eprintf "error: Parse Error."
    | Lexer.Error ->
        Format.eprintf "error: Lexing Error."

