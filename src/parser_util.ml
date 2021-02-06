
(**
  Helper functions used in the parser.
*)

open Ast

open Classes
open Types

open Util

module ID_Map = Map.Make(String)


type parse_state =
  {
    emitted   : clause Diff_list.t;
    fresh_cts : int   ID_Map.t;
    fresh_env : ident ID_Map.t;
  }

module PState = State_Util(struct type t = parse_state end)

include struct
  open PState
  open PState.Syntax

  module Lists = struct
    include Lists
    include Traversable_Util(Lists)
    include Make_Traversable(PState)
  end

  let run_pstate : 'a PState.t -> 'a =
    fun ps -> snd @@ ps {
      emitted   = Diff_list.nil;
      fresh_cts = ID_Map.empty;
      fresh_env = ID_Map.empty;
    }

  let fresh id : ident PState.t =
    fun ps ->
      let ct = Option.value ~default:0 @@
        ID_Map.find_opt id ps.fresh_cts in
      let id' = id ^ "$" ^ string_of_int ct in
      let ps' = { ps with
        fresh_cts = ps.fresh_cts |> ID_Map.add id (ct + 1);
      }
      in (ps', id')

  let fresh' id =
    let* id' = fresh id in
    let* () = modify (fun ps -> { ps with
      fresh_env = ps.fresh_env |> ID_Map.add id id';
    }) in
    pure id'

  let add_to_env id id' act =
    control
      (fun ps -> { ps with
        fresh_env = ps.fresh_env |> ID_Map.add id id';
      })
      (fun ps ps' -> { ps' with
        fresh_env = ps.fresh_env;
      })
      act

  let lookup id =
    let* ps = get in
    match ID_Map.find_opt id ps.fresh_env with
    | Some(id') -> pure id'  
    | None      -> fresh id

  let emit cl =
    modify (fun ps -> { ps with
      emitted = Diff_list.snoc ps.emitted cl;
    })

  let emit' body =
    let* body = body in
    match body with
    | BVar id -> pure id
    | _ ->
    let* id = fresh "" in
    let* () = emit @@ Cl (id, body) in
    pure id
    
  let new_block act =
    control
      (fun ps -> { ps with
        emitted = Diff_list.nil;
      })
      (fun ps ps' -> { ps' with
        emitted = ps.emitted;
      })
      act

end [@warning "-K"]
(* 
  otherwise, dune complains about
  'unused functions' even though
  they're used in the parser plenty...
*)

