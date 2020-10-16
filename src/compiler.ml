(**
  Functions corresponding to taking in an AST
  and producing C code (technically transpilation).
*)

open Ast
open Classes
open Types
open Util


let c_prelude =
"
#include <stdint.h>

typedef void (*Func)();

typedef struct {
  Func func;
} Closure;

typedef void* Univ;
"

let c_epilogue =
"
int main(int argc, char **argv) {
  /*
    Eventually, do setup here for `input` calls,
    and other argument handling if needed.
  */
  return 0;
}
"



module C = struct

  type compile_state =
    {
      deferred: string Diff_list.t list
    }

  type compile_params =
    Analysis.full_analysis

    
  module State = RWS_Util
    (struct type t = compile_params end)
    (struct
      type t = string Diff_list.t
      let append = Diff_list.(++)
      let empty = Diff_list.nil  
    end)
    (struct type t = compile_state end)

  
  open State.Syntax

  module Lists = struct
    include Lists
    include Traversable_Util(Lists)
    include Make_Traversable(State)
  end

  module ID_Map = struct
    include ID_Map
    include Traversable_Util(Maps(ID_Map))
    include Make_Traversable(State)
  end

  module Seqs = struct
    include Seqs
    include Traversable_Util(Seqs)
    include Make_Traversable(State)
  end

  let emit1 s = 
    State.tell Diff_list.(cons s nil)

  let emit ss =
    State.tell (Diff_list.from_list ss)

  let sf = Format.asprintf
  let ff = Format.fprintf

  let emit_prelude = emit1 c_prelude
  let emit_epilogue = emit1 c_epilogue

  let type_prefix  = "Type"
  let union_prefix = "Union"

  let rec type_repr ?(boxed_records=false) =
    function
    | TInt  -> "int64_t"
    | TUniv -> "Univ"
    | TFun  -> "Closure*"
    | TTrue | TFalse -> "struct {}"
    | TRec _ when boxed_records -> "Univ"
    | TRec ts ->
        ts |> sf "struct {@.%a}"
          (fun fmt ts ->  
            ts |> List.iter (fun (lbl, ty) ->
              let sty = type_repr ~boxed_records:true ty in
              ff fmt "  %s %s;@." sty lbl
          ))

  let emit_type_decls =
    let* { inferred_types; _ } = State.ask in
    inferred_types.id_to_type
      |> Int_Map.bindings
      |> Lists.traverse (fun (id, ty) ->
        let sty = type_repr ty in
        emit1 (sf "typedef %s %s%d;" sty type_prefix id)
        *> emit1 "" 
        *> State.pure (Some id)
      )

  let emit_union_decls =
    let* { inferred_types; _ } = State.ask in
    inferred_types.id_to_union
      |> Int_Map.bindings
      |> Lists.traverse (fun (id, tys) ->
        if Int_Set.cardinal tys == 0 then
          emit1 (sf "typedef Univ %s%d" union_prefix id)
        else if Int_Set.cardinal tys == 1 then
          let ty = Int_Set.choose tys in
          emit1 (sf "typedef %s%d %s%d;" type_prefix ty union_prefix id)
        else
        let* () = emit [
          "typedef struct {"; 
          "  enum {"
        ] in
        let* _ = tys 
          |> Int_Set.elements
          |> Lists.traverse (fun tid ->
            emit1 (sf "    %s%d_%s%d," union_prefix id type_prefix tid)  
          ) 
        in
        let* () = emit [
          "  } tag;";
          "  union {"; 
        ] in
        let* _ = tys
          |> Int_Set.elements
          |> Lists.traverse (fun tid ->
            emit1 (sf "    %s%d %s%d;" type_prefix tid type_prefix tid)  
          )
        in emit [
          "  };";
          sf "} %s%d;" union_prefix id;
          "";
        ]
      )

  let emit_closure_struct_decls =
    let* { closures; inferred_types; _ } = State.ask in
    let+ _ = closures
      |> ID_Map.mapi (fun name { Analysis.Closures.scope; _ } ->
        emit1 "typedef struct {" *>
        emit1 "  Func func;" *>
        let* _ = scope
          |> ID_Map.bindings
          |> List.filter_map (fun (id, kind) ->
              match kind with
              | Analysis.Closures.Captured -> Some(id)
              | _ -> None)
          |> Lists.traverse (fun id ->
              let uid = ID_Map.find id inferred_types.pp_to_union_id in
              emit1 (sf "  %s%d %s;" union_prefix uid id))
        in
        emit1 (sf "} %s_closure;" name)
      )
      |> ID_Map.sequence
    in ()
  
  let emit_closure_function_decls =
    let* { closures; _ } = State.ask in
    let+ _ = closures
      |> ID_Map.mapi (fun name _info ->
        emit1 @@ sf "Func %s;" name
      )
      |> ID_Map.sequence
    in ()  


  

  let compile _expr : unit State.t =
    emit_prelude
    *> emit_type_decls
    *> emit_union_decls
    *> emit_closure_struct_decls
    *> emit_closure_function_decls
    (* *> emit_epilogue *)

  let compile_string ?analysis expr : string =
    let analysis = match analysis with
    | Some a -> a
    | None   -> Analysis.full_analysis_of expr
    in
    let (_, emitted, ()) = compile expr analysis { deferred = [] } in
      String.concat "\n" (Diff_list.to_list emitted)

end