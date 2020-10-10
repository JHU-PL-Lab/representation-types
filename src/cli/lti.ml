
open Layout
open Eval

let () =
  let text = Stdio.In_channel.input_all Stdio.stdin in
  let k = try int_of_string Sys.argv.(1) with _ -> 0 in
  try
    let prog = Tests.parse text in
    let full = full_analysis_of ~k prog in 
    full.results
      |> FlowTracking.Avalue_Set.to_seq
      |> Seq.map FlowTracking.Wrapper.extract
      |> Seq.iter (Format.printf "%a@." (Util_pp.pp_avalue Util_pp.pp_context));
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

