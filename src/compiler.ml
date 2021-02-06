(**
  Functions corresponding to taking in an AST
  and producing C code (technically transpilation).
*)

open Ast
open Classes
open Types
open Util

type exn +=
  | Open_Expression
  | Type_Mismatch
  | Match_Fallthrough
  | Empty_Expression

let c_prelude =
{|
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

typedef void Func();

typedef struct {
  Func *_func;
} Closure;

#define ABORT exit(EXIT_FAILURE)
#define COPY(...) __builtin_memcpy(__VA_ARGS__)
#define COMBINE(a, b) (a) >= (b) ? (a) * (a) + (a) + (b) : (a) + (b) * (b)
#define CALL(c, ...) ((c)->_func)((c), __VA_ARGS__)
#define HEAP_VALUE(type, ...) \
  ({ type *ptr = malloc(sizeof(type)); *ptr = (type) __VA_ARGS__; (void*)ptr; })
#define UNTAGGED(U, T, value) ((U) { . T = value })
#define TAGGED(U, T, value) ((U) { .tag = U ## _ ## T, . T = value })

void __input(ssize_t *i) {
  if (scanf("%zd", i) != 1) ABORT;
}

typedef struct {} Empty;
typedef void *Univ;
|}


module C = struct

  type compile_state =
    {
      deferred: string Diff_list.t Diff_list.t;
      counter: int;
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

  module Type_Tag_Pair_Map = struct
    include Type_Tag_Pair_Map
    include Traversable_Util(Maps(Type_Tag_Pair_Map))
    include Make_Traversable(State)
  end

  module Seqs = struct
    include Seqs
    include Traversable_Util(Seqs)
    include Make_Traversable(State)
  end

  let emit ss =
    State.tell (Diff_list.from_list ss)
    
  let tmp_prefix = "_tmp$"
  
  let fresh_tmp_id =
    let* { counter; _ } = State.get in
    let+ () = State.modify (fun s -> { s with counter = counter + 1; }) in
    tmp_prefix ^ (string_of_int counter)

  let indent_prefix = "  "
  let indent ma =
    State.pass (Diff_list.map (fun s -> indent_prefix ^ s)) ma
    
  let bracketed_indented e1 e2 ma =
    emit e1 *> indent ma <* emit e2

  let defer ma =
    let* (_, emitted) = State.capture ma in
    State.modify (fun s -> { s with deferred = Diff_list.(snoc s.deferred emitted) })

  let emit_deferred =
    let* { deferred; _ } = State.get in
    Lists.traverse_ State.tell (Diff_list.to_list deferred) *>
    State.modify (fun s -> { s with deferred = Diff_list.nil })
    
  let sf = Format.asprintf
  let ff = Format.fprintf

  let emit_prelude = emit [c_prelude]

  let type_prefix  = "Type"
  let union_prefix = "Union"

  let argument_style = `Value

  let fmt_type fmt id =
    ff fmt "%s%d" type_prefix id
  let fmt_union fmt id =
    ff fmt "%s%d" union_prefix id
  let fmt_closure_type fmt name =
    ff fmt "%s_Closure" name
  let fmt_closure_impl fmt name =
    ff fmt "_%s" name

  let get_closure_info name =
    let+ { closures; _ } = State.ask in
    ID_Map.find name closures

  let uid_of name =
    let+ { inferred_types; _ } = State.ask in
    ID_Map.find_opt name inferred_types.pp_to_union_id
    |> Option.value ~default:0

  let union_of name =
    let* { inferred_types; _ } = State.ask in
    let+ uid = uid_of name in
    let union =  Int_Map.find uid inferred_types.id_to_union   in
    (union, uid)

  let tid_of simple_type =
    let+ { inferred_types; _ } = State.ask in
    Type_Map.find simple_type inferred_types.type_to_id

  let type_of_tid id =
    let+ { inferred_types; _ } = State.ask in
    Int_Map.find id inferred_types.id_to_type
  
  let place_deref =
    function
    | `Ptr id | `Loc id -> `Loc (sf "(*%s)" id)

  let place_address =
    function
    | `Ptr id | `Loc id -> `Ptr (sf "(&%s)" id)

  let place_to_ptr =
    function
    | `Ptr id -> `Ptr id
    | loc -> place_address loc

  let place_to_loc =
    function
    | `Loc id -> `Loc id
    | ptr -> place_deref ptr

  let place_to_str =
    function
    | `Ptr id | `Loc id -> id

  let place_field lbl =
    function
    | `Ptr id -> `Loc (sf "%s->%s" id lbl)
    | `Loc id -> `Loc (sf "%s.%s" id lbl)

  let place_type tid =
    place_field (sf "%a" fmt_type tid)

  let get_place (info : Analysis.Closures.closure_info) id =
    let+ fn = tid_of TFun
    and+ u, uid = union_of info.name in
    match ID_Map.find id info.scope with
    | exception _ -> raise Open_Expression
    | Self_closure ->
        let macro = if Int_Set.cardinal u < 2 then "UNTAGGED" else "TAGGED" in
        `Loc (sf "%s(%a, %a, (const Closure*)_clo)" macro fmt_union uid fmt_type fn)
          
    | Captured -> `Loc (sf "_clo->%s" id)
    | Local    -> `Loc id
    | Argument -> `Loc id
    | _ -> failwith "Won't happen."

    
  let fmt_place_ptr fmt place =
    Format.pp_print_string fmt (
      place |> place_to_ptr
            |> place_to_str)
    
  let fmt_place_loc fmt place =
    Format.pp_print_string fmt (
      place |> place_to_loc
            |> place_to_str)

  let fmt_place_arg fmt place =
    match argument_style with
    | `Value     -> fmt_place_loc fmt place
    | `Reference -> fmt_place_ptr fmt place


  
  let rec size_of_type_repr =
    function
    | TTrue | TFalse -> 0
    | TInt | TFun | TUniv -> 8
    | TRec (_, fields) ->
        List.fold_left
          (fun acc (_, _ty) ->
              acc + 8)
          0
          fields

  let size_of_union u =
    match Int_Set.elements u with
    | []  -> State.pure 0
    | [x] -> size_of_type_repr <$> type_of_tid x
    | xs  ->
      let+ xsizes = xs |>
        Lists.traverse (fun tid ->
          size_of_type_repr <$> type_of_tid tid)
      in
      8 + List.fold_left max 0 xsizes



  let rec type_repr =
    function
    | TInt  -> State.pure "ssize_t"
    | TUniv -> State.pure "Univ"
    | TFun  -> State.pure "Closure*"
    | TTrue | TFalse -> State.pure "Empty"
    | TRec (name, ts) ->
        let name = Option.get name in
        let+ lbl_uids = ts 
          |> Lists.traverse (fun (lbl, _) ->
            let+ uid = uid_of (name ^ "." ^ lbl) in (lbl, uid))
        in
        lbl_uids |> sf "struct /* %s */ {@.%a}" 
          name
          (fun fmt ts -> ts |> List.iter (fun (lbl, uid) ->
            ff fmt "  Univ %s; /* %a */@." lbl fmt_union uid
          ))

  let emit_type_decls =
    let* { inferred_types; _ } = State.ask in
    inferred_types.id_to_type
      |> Int_Map.bindings
      |> Lists.traverse_ (fun (id, ty) ->
        let* sty = type_repr ty in
        emit [sf "typedef %s %a;\n" sty fmt_type id] *> 
        State.pure (Some id)
      )

  let emit_union_decls =
    let* { inferred_types; _ } = State.ask in
    let id_to_union = Int_Map.bindings inferred_types.id_to_union in
    id_to_union
    |> Lists.traverse_ (fun (id, tys) ->
      if Int_Set.cardinal tys = 0 then
        emit [sf "typedef Empty %a;\n" fmt_union id]
      else if Int_Set.cardinal tys = 1 then
        let tid = Int_Set.choose tys in
        emit [sf "typedef struct { %a %a; } %a;" fmt_type tid fmt_type tid fmt_union id]
      else 
      bracketed_indented
        ["typedef struct {"] [sf "} %s%d;\n" union_prefix id]
      begin
        bracketed_indented ["enum {"] ["} tag;"]
        begin
          tys 
          |> Int_Set.elements
          |> Lists.traverse_ (fun tid ->
            emit [sf "%a_%a," fmt_union id fmt_type tid]
          )
        end *>
        bracketed_indented ["union {"] ["};"]
        begin
          tys
          |> Int_Set.elements
          |> Lists.traverse_ (fun tid ->
            emit [sf "%a %a;" fmt_type tid fmt_type tid]
          )
        end
      end)

  let emit_closure_struct_decls =
    let* { closures; _ } = State.ask in
    closures
    |> ID_Map.mapi (fun name { Analysis.Closures.scope; _ } ->
      bracketed_indented
        ["typedef struct {"] [sf "} %a;\n" fmt_closure_type name]
      begin
        let* () = emit ["Func *_func;"] in
        scope
        |> ID_Map.bindings
        |> List.filter_map (fun (id, kind) ->
            match kind with
            | Analysis.Closures.Captured -> Some(id)
            | _ -> None)
        |> Lists.traverse (fun id ->
            let* uid = uid_of id in
            emit [sf "%a %s;" fmt_union uid id])
      end)
    |> ID_Map.sequence_
    
  let emit_closure_function_decls =
    let* { closures; _ } = State.ask in
    let* _ = closures
      |> ID_Map.mapi (fun name _ -> emit [sf "Func %a;" fmt_closure_impl name])
      |> ID_Map.sequence
    in
      emit [""]


  let emit_type_printer_decls =
    let* { inferred_types; _ } = State.ask in
    let* () = 
      inferred_types.id_to_type
      |> Int_Map.bindings
      |> Lists.traverse_ (fun (id, _) ->
        emit [sf "static inline void fprint_%a(FILE *, const %a*);" fmt_type id fmt_type id]  
      )
    in
    let* () =
      inferred_types.id_to_union
      |> Int_Map.bindings
      |> Lists.traverse_ (fun (id, _) ->
        emit [sf "static inline void fprint_%a(FILE *, const %a*);" fmt_union id fmt_union id]    
      )
    in
    emit [""]

  let emit_type_printer_defns =
    let* { inferred_types; _ } = State.ask in
    let* () =
      inferred_types.id_to_type
      |> Int_Map.bindings
      |> Lists.traverse_ @@ fun (id, ty) ->
        bracketed_indented
          [sf "void fprint_%a(FILE *stream, const %a* value) {" fmt_type id fmt_type id] ["}"]
        begin
          match ty with
          | TUniv  -> emit [{|fprintf(stream, "<univ>");|}]
          | TInt   -> emit [{|fprintf(stream, "%zd", *value);|}]
          | TFun   -> emit [{|fprintf(stream, "<fun>");|}]
          | TTrue  -> emit [{|fprintf(stream, "true");|}]
          | TFalse -> emit [{|fprintf(stream, "false");|}]
          | TRec (name, fields) ->
          let name = Option.get name in
          match fields with
          | [] -> emit [{|fprintf(stream, "{}");|}]
          | (lbl1, _) :: fs ->
          let* id1_u, id1_uid = union_of (name ^ "." ^ lbl1) in
          let* id1_size = size_of_union id1_u in
          let* () = emit [sf {|fprintf(stream, "{%s = ");|} lbl1] in
          let* () = 
            if id1_size <= 8 then  
              emit [sf {|fprint_%a(stream, (%a*)&value->%s);|} fmt_union id1_uid fmt_union id1_uid lbl1]
            else 
              emit [sf {|fprint_%a(stream, (%a*)value->%s);|} fmt_union id1_uid fmt_union id1_uid lbl1]
          in
          let* () = fs |> Lists.traverse_ @@ fun (lbl, _) ->
            let* id_u, id_uid = union_of (name ^ "." ^ lbl) in
            let* id_size = size_of_union id_u in
            let* () = emit [sf {|fprintf(stream, "; %s = ");|} lbl] in
            if id_size <= 8 then
              emit [sf {|fprint_%a(stream, (%a*)&value->%s);|} fmt_union id_uid fmt_union id_uid lbl]
            else
              emit [sf {|fprint_%a(stream, (%a*)value->%s);|} fmt_union id_uid fmt_union id_uid lbl]
          in
          emit [{|fprintf(stream, "}");|}]
        end
    in
    let* () =
      inferred_types.id_to_union
      |> Int_Map.bindings
      |> Lists.traverse_ @@ fun (id, u) ->
        bracketed_indented
          [sf "void fprint_%a(FILE *stream, const %a* value) {" fmt_union id fmt_union id] ["}"]
        begin
          if Int_Set.cardinal u = 0 then
            emit ["__builtin_unreachable();"]
          else if Int_Set.cardinal u = 1 then
            let tid = Int_Set.choose u in
            emit [sf "fprint_%a(stream, &value->%a);" fmt_type tid fmt_type tid]
          else
          bracketed_indented
            ["switch (value->tag) {"] ["}"]
          begin
            u |> Int_Set.elements |> Lists.traverse_ @@ fun tid ->
              emit [sf "case %a_%a:" fmt_union id fmt_type tid] *>
              indent begin
                emit [sf "fprint_%a(stream, &value->%a);" fmt_type tid fmt_type tid] *>
                emit ["break;"]
              end
          end
        end
    in
    emit [""]


  (**
    Figure out how to set the tag, if necessary.
  *)
  let tag_setter tid pp place =
    let+ u, uid = union_of pp in
    if not (Int_Set.mem tid u) then
      None
    else if Int_Set.cardinal u = 1 then
      Some (State.pure ())
    else
      Some (
        emit [sf "%a = %a_%a;" fmt_place_loc (place_field "tag" place) fmt_union uid fmt_type tid]
      )

  let tag_setter_exn tid pp place =
    let+ set_tag = tag_setter tid pp place in
    match set_tag with
    | None -> raise Type_Mismatch
    | Some(set_tag) -> set_tag

  let assert_place_type pp tid place =
    let* u, uid = union_of pp in
    if not (Int_Set.mem tid u) then
      raise Type_Mismatch
    else
    State.pure (place_type tid place) <*
    if Int_Set.cardinal u != 1 then
      emit [sf "if (%a.tag != %a_%a) ABORT;" fmt_place_loc place fmt_union uid fmt_type tid]
    else
      State.pure()
    
  let is_true pp place =
    let* tru = tid_of TTrue in
    let+ u, uid = union_of pp in
    if not (Int_Set.mem tru u) then
      "0"
    else if Int_Set.cardinal u = 1 then
      "1"
    else
      sf "%a.tag == %a_%a" fmt_place_loc place fmt_union uid fmt_type tru

  let is_false pp place =
    let* fal = tid_of TFalse in
    let+ u, uid = union_of pp in
    if not (Int_Set.mem fal u) then
      "0"
    else if Int_Set.cardinal u = 1 then
      "1"
    else
      sf "%a.tag == %a_%a" fmt_place_loc place fmt_union uid fmt_type fal



  let rec emit_clauses (info : Analysis.Closures.closure_info) dest =
    function
    | [] -> raise Empty_Expression
    | Cl (pp, body) as cl :: [] ->
        let* pp_u, _ = union_of pp in
        emit [sf "/* %a */" pp_clause' cl] *>
        begin
          if Int_Set.cardinal pp_u != 0 then
            emit_body info pp dest body
          else
            State.pure ()
        end
    | Cl (pp, body) as cl :: cls ->
        let* pp_u, pp_uid = union_of pp in
        emit [sf "/* %a */" pp_clause' cl] *>
        emit [sf "%a %s;" fmt_union pp_uid pp] *>
        begin
          if Int_Set.cardinal pp_u != 0 then
            emit_body info pp (`Loc pp) body
          else
            State.pure ()
        end *>
        emit [""] *>
        emit_clauses info dest cls

  and emit_closure_defn name expr : unit State.t =
    let* info = get_closure_info name in
    let* return_uid = uid_of info.return in
    let* func_signature = match info.argument with
    | None     -> 
        State.pure [sf "void %a(const %a *_clo, %a *restrict %s) {"
          fmt_closure_impl name
          fmt_closure_type name 
          fmt_union return_uid 
          info.return]
    | Some arg -> 
        let+ arg_uid = uid_of arg in
        [sf "void %a(const %a *_clo, %a *restrict %s, %a %s) {" 
          fmt_closure_impl name 
          fmt_closure_type name
          fmt_union return_uid
          info.return 
          fmt_union arg_uid arg]
    in
    bracketed_indented func_signature ["}\n\n"]
      (emit_clauses info (`Ptr info.return) expr)

  and emit_body info pp dest =
    function
    | BVar id ->
        let* id = get_place info id in
        emit [sf "%a = %a;" fmt_place_loc dest fmt_place_loc id]
    
    | BVal (VFun (_, expr)) ->
        let* () = defer @@ emit_closure_defn pp expr in
        let* fn = tid_of TFun in
        let* set_tag = tag_setter_exn fn pp dest in
        let* pp_info = get_closure_info pp in
        let captured = pp_info.scope 
          |> ID_Map.bindings
          |> List.filter_map Analysis.Closures.(fun (lbl, kind) -> 
              match kind with
              | Captured -> Some (lbl, get_place info lbl)
              | _ -> None)
        in
        set_tag *>
        if List.length captured = 0 then
          emit [sf "static const %a %a$ = { ._func = %a };" fmt_closure_type pp fmt_closure_impl pp fmt_closure_impl pp] *>
          emit [sf "%a = (Closure*)&%a$;" fmt_place_loc (place_type fn dest) fmt_closure_impl pp]
        else
        bracketed_indented
          [sf "%a = HEAP_VALUE(%a, {" fmt_place_loc (place_type fn dest) fmt_closure_type pp] ["});"]
        begin
          let* () = emit [sf "._func = %a," fmt_closure_impl pp] in
          captured |> Lists.traverse_ (fun (name, src) ->
            let* src = src in
            emit [sf ".%s = %a," name fmt_place_loc src])
        end

    | BVal (VRec fields) ->
        let* { tag_tables; _ } = State.ask in
        let record_table = ID_Map.find pp tag_tables.record_tables in
        let* pp_u, _pp_uid = union_of pp in

        let init_fields place =
          fields |> Lists.traverse_ (fun (lbl, id) ->
            let* id_u, id_uid = union_of id in
            let* id_place = get_place info id in
            let* size = size_of_union id_u in
            if size <= 8 then
              emit [sf "COPY(%a, %a, sizeof(%a));" fmt_place_ptr (place_field lbl place) fmt_place_ptr id_place fmt_union id_uid]
            else
              emit [sf "%a = HEAP_VALUE(%a, %a);" 
                fmt_place_loc (place_field lbl place) fmt_union id_uid fmt_place_loc id_place]
          )
        in
        
        if Int_Set.cardinal pp_u = 1 then
          let place = place_type (Int_Set.choose pp_u) dest in
          init_fields place
        else
        let open Map_Util(struct type t = type_tag [@@deriving ord] end)(Field_Tags_Map) in
        let inverted_fields = invert record_table in
        if Invert_Map.cardinal inverted_fields = 1 then
          let Tag tid, _ = Invert_Map.choose inverted_fields in
          let* set_tag = tag_setter_exn tid pp dest in
          set_tag *> init_fields (place_type tid dest)
        else
        let rec emit_switches field_tags = 
          function
          | (lbl, id) :: fields ->
              let* id_u, id_uid = union_of id in
              let* id_place = get_place info id in
              let type_tags = Int_Set.elements id_u in
              if Int_Set.cardinal id_u = 1 then
                let field_tags' = ID_Map.add lbl (Tag (Int_Set.choose id_u)) field_tags in
                emit_switches field_tags' fields
              else
              bracketed_indented
                [sf "switch (%a.tag) {" fmt_place_loc id_place] ["}"]
              begin
                type_tags |> Lists.traverse_ (fun tid ->
                  let field_tags' = ID_Map.add lbl (Tag tid) field_tags in
                  emit [sf "case %a_%a:" fmt_union id_uid fmt_type tid] *>
                  indent ((emit_switches field_tags' fields) *> emit ["break;"])
                )
              end

          | _ -> 
          match Field_Tags_Map.find_opt field_tags record_table with
          | None          -> emit ["ABORT;"]
          | Some(Tag tid) -> 
              let* set_tag = tag_setter_exn tid pp dest in
              set_tag *> init_fields (place_type tid dest) (* **> emit ["break;"] *)
        in
        emit_switches
          ID_Map.empty
          fields
        
    | BVal (VInt i) ->
        let* int = tid_of TInt in
        let* set_tag = tag_setter_exn int pp dest in
        set_tag *> emit [sf "%a = %d;" fmt_place_loc (place_type int dest) i]

    | BVal VTrue ->
        let* tru = tid_of TTrue in
        let* set_tag = tag_setter_exn tru pp dest in
        set_tag

    | BVal VFalse ->
        let* fal = tid_of TFalse in
        let* set_tag = tag_setter_exn fal pp dest in
        set_tag
        
    | BInput ->
        let* int = tid_of TInt in
        let* set_tag = tag_setter_exn int pp dest in
        set_tag *> emit [sf "_input(%a);" fmt_place_ptr (place_type int dest)]

    | BApply (i1, i2) ->
        let* fn = tid_of TFun in
        let* i1 = get_place info i1 in
        let* i2 = get_place info i2 in
        emit [sf "CALL(%a, %a, %a);"
          fmt_place_loc (place_type fn i1)
          fmt_place_ptr dest 
          fmt_place_arg i2]
    

    | BProj (id, lbl) ->
        let* id_u, id_uid = union_of id in
        let* pp_u, pp_uid = union_of pp in
        let* id_place = get_place info id in

        let* pp_u_size = size_of_union pp_u in

        let emit_proj src =
          if pp_u_size <= 8 then
            emit [sf "COPY(%a, %a, sizeof(%a));" fmt_place_ptr dest fmt_place_ptr src fmt_union pp_uid]
          else
            emit [sf "COPY(%a, %a, sizeof(%a));" fmt_place_ptr dest fmt_place_loc src fmt_union pp_uid]
        in

        let handle_case_of tid =
          let* { inferred_types; _ } = State.ask in
          let+ ty = type_of_tid tid in  
          match ty with
          | TRec (Some name, _fields) ->
            let rec_field_pp = Printf.sprintf "%s.%s" name lbl in
            begin match ID_Map.find_opt rec_field_pp inferred_types.pp_to_union_id with
            | Some rf_uid when rf_uid = pp_uid ->
              Some (
                (* 
                  (* The below seems unnecessary, as we are already copying the union as a whole. *)
                  (* Note that this would be invalidated if we did not necessarily back-propagate unions... *)
                  (* This is why the rf_uid identity check is in place above, as a reminder. *)
                let* field_tid = tid_of field_ty in
                let* set_tag = tag_setter field_tid pp dest in
                Option.value set_tag ~default:(State.pure ()) *> 
                *)
                emit_proj (place_field lbl (place_type tid id_place))
              )
            | _ -> None  
            end
          | _ ->
            None
        in
        
        if Int_Set.cardinal id_u = 1 then
          let tid = Int_Set.choose id_u in
          handle_case_of tid >>= Option.get
        else
        bracketed_indented
          [sf "switch (%a) {" fmt_place_loc (place_field "tag" id_place)] ["}"]
        begin
          let* () =
            Int_Set.elements id_u |> Lists.traverse_ (fun tid ->
              handle_case_of tid >>= function
              | None -> State.pure ()
              | Some(handle) ->
              emit [sf "case %a_%a:" fmt_union id_uid fmt_type tid] *>
              indent begin
                handle *>
                emit ["break;"]
              end
            )
          in
          emit ["default:"] *>
          indent (emit ["ABORT;"])
        end 


    | BMatch (i1, branches) ->
        let* { tag_tables; _ } = State.ask in
        let* i1_u, i1_uid = union_of i1 in
        let* i1 = get_place info i1 in
        let open Map_Util(Int)(Type_Tag_Map) in
        let tag_to_branch  = ID_Map.find pp tag_tables.match_tables in
        let branch_to_tags = invert tag_to_branch in
        if Int_Set.cardinal i1_u = 1 then
          let i1_tid = Int_Set.choose i1_u in
          let branch_ix = Type_Tag_Map.find (Tag i1_tid) tag_to_branch in
          let (_, branch) = List.nth branches branch_ix in
          emit_clauses info dest branch
        else
        let module Invert_Maps = Traversable_Util(Maps(Invert_Map)) in
        let module Invert_Maps = Invert_Maps.Make_Traversable(State) in
        bracketed_indented
          [sf "switch (%a) {" fmt_place_loc (place_field "tag" i1)] ["}"]
        begin
          let* () = branch_to_tags
            |> Invert_Map.mapi (fun branch_ix tids ->
                let* () = tids |> Lists.traverse_ 
                  (fun (Tag tid) -> emit [sf "case %a_%a:" fmt_union i1_uid fmt_type tid]) in
                let (_, branch) = List.nth branches branch_ix in
                bracketed_indented ["{"] ["}"]
                begin
                  emit_clauses info dest branch *>
                  emit ["break;"]
                end)
            |> Invert_Maps.sequence_
          in
          emit ["default:"] *>
          indent (emit ["ABORT;"])
        end

    | BOpr ((OPlus (i1, i2) | OMinus (i1, i2) | OTimes (i1, i2)) as o) ->
        let* int = tid_of TInt in
        let* i1_place = get_place info i1 >>= assert_place_type i1 int in
        let* i2_place = get_place info i2 >>= assert_place_type i2 int in
        let* set_tag = tag_setter_exn int pp dest in
        let[@warning "-8"] op = match o with 
          | OPlus  (_, _) -> "+"
          | OMinus (_, _) -> "-"
          | OTimes (_, _) -> "*"
        in
        set_tag *> 
        emit [sf "%a = %a %s %a;" fmt_place_loc (place_type int dest) fmt_place_loc i1_place op fmt_place_loc i2_place] 

    | BOpr ((OEquals (i1, i2) | OLess (i1, i2)) as o) ->
        let* int = tid_of TInt in
        let* tru = tid_of TTrue in
        let* fal = tid_of TFalse in
        
        let* set_fal = tag_setter fal pp dest in
        let* set_tru = tag_setter tru pp dest in

        let* i1_place = get_place info i1 >>= assert_place_type i1 int in
        let* i2_place = get_place info i2 >>= assert_place_type i2 int in

        begin match set_tru, set_fal with
        | None, None -> raise Type_Mismatch
        | Some t, None -> t
        | None, Some f -> f
        | Some t, Some f ->
        let[@warning "-8"] op = match o with 
          | OEquals (_, _) -> "=="
          | OLess   (_, _) -> "<"
        in
        bracketed_indented [sf "if (%a %s %a) {" fmt_place_loc i1_place op fmt_place_loc i2_place] ["}"] t *>
        bracketed_indented ["else {"] ["}"] f
        end

    | BOpr (ONeg i1) ->
      let* int = tid_of TInt in
      let* i1_place = get_place info i1 >>= assert_place_type i1 int in
      let* set_tag = tag_setter_exn int pp dest in
      set_tag *> 
      emit [sf "%a = -%a;" fmt_place_loc (place_type int dest) fmt_place_loc i1_place]

    | BOpr ((OAnd (i1, i2) | OOr (i1, i2)) as o) ->
        let* tru = tid_of TTrue in
        let* fal = tid_of TFalse in
        let* set_fal = tag_setter fal pp dest in
        let* set_tru = tag_setter tru pp dest in

        begin match set_tru, set_fal with
        | None, None -> raise Type_Mismatch
        | Some t, None -> t
        | None, Some f -> f
        | Some t, Some f ->

          let* i1_u, _ = union_of i1 in
          let* i2_u, _ = union_of i2 in
          let emit_check opstr = 
              let* i1_t = get_place info i1 >>= is_true i1 in
              let* i2_t = get_place info i2 >>= is_true i2 in
              bracketed_indented [sf "if ((%s) %s (%s)) {" i1_t opstr i2_t] ["}"] t *>
              bracketed_indented ["else {"] ["}"] f
          in
          begin[@warning "-8"] match o with
          | OAnd (_, _) -> 
              if (not @@ Int_Set.mem tru i1_u) || (not @@ Int_Set.mem tru i2_u) then
                f
              else if (not @@ Int_Set.mem fal i1_u) && (not @@ Int_Set.mem fal i2_u) then
                t
              else
                emit_check "&&"

          | OOr (_, _) -> 
              if (not @@ Int_Set.mem tru i1_u) && (not @@ Int_Set.mem tru i2_u) then
                f
              else if (not @@ Int_Set.mem fal i1_u) || (not @@ Int_Set.mem fal i2_u) then
                t
              else
                emit_check "||"
          end
        end

    | BOpr (ONot i1) ->
        let* tru = tid_of TTrue in
        let* fal = tid_of TFalse in
        let* set_fal = tag_setter fal pp dest in
        let* set_tru = tag_setter tru pp dest in
        
        begin match set_tru, set_fal with
        | None, None -> raise Type_Mismatch
        | Some t, None -> t
        | None, Some f -> f
        | Some t, Some f ->
          let* i1_u, _ = union_of i1 in
          if not (Int_Set.mem tru i1_u) then
            t
          else if not (Int_Set.mem fal i1_u) then
            f
          else
          let* is_i1_true = get_place info i1 >>= is_true i1 in
          bracketed_indented [sf "if (%s) {" is_i1_true] ["}"] f *>
          bracketed_indented ["else {"] ["}"] t
        end

    | BOpr (OAppend (i1, i2)) ->
        let* { tag_tables; _ } = State.ask in
        let append_table = ID_Map.find pp tag_tables.append_tables in
        
        let* pp_u, _ = union_of pp in
        let* i1_u, i1_uid = union_of i1 in
        let* i1_place = get_place info i1 in
        let* i2_u, i2_uid = union_of i2 in
        let* i2_place = get_place info i2 in

        let combined_tags t1 t2 =
          if Int_Set.cardinal i1_u = 1 then 
            t2
          else if Int_Set.cardinal i2_u = 1 then
            t1
          else
            sf "COMBINE(%s, %s)" t1 t2
        in

        let init_from_tids t1 t2 tp =
          let* ty1 = type_of_tid t1 in
          let* ty2 = type_of_tid t2 in
          let* set_tag = tag_setter_exn tp pp dest in
          set_tag *>
          match ty1, ty2 with
          | TRec (_, r1), TRec (_, r2) ->
              let f2 = ID_Set.of_list (List.map fst r2) in
              let f1 = ID_Set.of_list (List.map fst r1) |> (fun f1 -> ID_Set.diff f1 f2) in
              let init_lbl src lbl =
                emit [sf "%a = %a;"
                  fmt_place_loc (place_field lbl (place_type tp dest))
                  fmt_place_loc (place_field lbl src)]
              in
              let* () = f1 |> ID_Set.to_seq |> Seqs.traverse_ (init_lbl (place_type t1 i1_place)) in
              f2 |> ID_Set.to_seq |> Seqs.traverse_ (init_lbl (place_type t2 i2_place))

          | _ -> raise Type_Mismatch
        in

        if Int_Set.cardinal i1_u = 1 && Int_Set.cardinal i2_u = 1 then
          init_from_tids (Int_Set.choose i1_u) (Int_Set.choose i2_u) (Int_Set.choose pp_u)
        else
        bracketed_indented
          [sf "switch (%s) {"
            (combined_tags (i1_place |> place_field "tag" |> place_to_str)
                           (i2_place |> place_field "tag" |> place_to_str))]
          ["}"]
        begin
          append_table
          |> Type_Tag_Pair_Map.mapi (fun (Tag t1, Tag t2) (Tag tp) ->
            let t1s = sf "%a_%a" fmt_union i1_uid fmt_type t1 in
            let t2s = sf "%a_%a" fmt_union i2_uid fmt_type t2 in
            emit [sf "case %s:" (combined_tags t1s t2s)] *>
            indent begin
              init_from_tids t1 t2 tp *>
              emit ["break;"]
            end
          )
          |> Type_Tag_Pair_Map.sequence_
        end


  let emit_epilogue =
    let* { inferred_types; closures; _ } = State.ask in
    let final = (ID_Map.find "__main" closures).return in
    let uid = ID_Map.find final inferred_types.pp_to_union_id in
    bracketed_indented
      ["int main(void) {"] ["}\n"]
    begin
      emit [
        sf "%a result;" fmt_union uid;
        sf "___main(NULL, &result);";
        sf "fprint_%a(stdout, &result);" fmt_union uid;
      ]
    end

  let compile expr : unit State.t =
    emit_prelude
    *> emit_type_decls
    *> emit_union_decls
    *> emit_closure_struct_decls
    *> emit_closure_function_decls
    *> emit_type_printer_decls
    *> emit_type_printer_defns
    *> emit_closure_defn "__main" expr
    *> emit_deferred
    *> emit_epilogue

  let compile_string ?analysis expr : string =
    let analysis = match analysis with
    | Some a -> a
    | None   -> Analysis.full_analysis_of expr
    in
    let (_, emitted, ()) = compile expr analysis { deferred = Diff_list.nil; counter = 0; } in
      String.concat "\n" (Diff_list.to_list emitted)

end