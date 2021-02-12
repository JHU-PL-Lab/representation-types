
open Layout
open Analysis
open Eval

let () =
  Random.self_init ();
  let text = Stdio.In_channel.input_all Stdio.stdin in
  let k = try int_of_string Sys.argv.(1) with _ -> 0 in
  try
    let prog = Tests.parse text in
    let full = full_analysis_of ~k prog in 
    full.results
      |> FlowTracking.Avalue_Set.to_seq
      |> Seq.iter (Format.printf "%a@." (Util_pp.pp_avalue Util_pp.pp_context));
    Format.printf "---------------\n";
    let (_, actual) = TaggedEvaluator.eval prog increasing_input full in
    Format.printf "%a@." TaggedEvaluator.RValue.pp_rvalue'' actual
  with
    | Analysis.Open_Expression   
    | Eval.Open_Expression ->
        Format.eprintf "error: Open Expression.\n"
    | Analysis.Type_Mismatch     
    | Eval.Type_Mismatch ->
        Format.eprintf "error: Type Mismatch.\n"
    | Analysis.Match_Fallthrough 
    | Eval.Match_Fallthrough ->
        Format.eprintf "error: Match Fallthrough.\n"
    | Parser.Error ->
        Format.eprintf "error: Parse Error.\n"
    | Lexer.Error ->
        Format.eprintf "error: Lexing Error.\n"

