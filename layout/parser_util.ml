
open Ast
open Classes
open Types

open Ast'

type exn +=
  | Parse_error of string

module ID_Map = Map.Make(String)


module Diff = struct
  type 'a t =
    { fold : 'b. ('a -> 'b -> 'b) -> 'b -> 'b }

  let cons a l =
    { fold = fun c n -> c a (l.fold c n) }

  let nil =
    { fold = fun _ n -> n }

  let (++) l1 l2 =
    { fold = fun c n -> l1.fold c (l2.fold c n) }

  let to_list l1 =
    l1.fold (fun x xs -> x :: xs) []

  let concat ll1 =
    ll1.fold (++) nil

  let map f l =
    { fold = fun c n -> l.fold (fun a b -> c (f a) b) n }

  let pure a = cons a nil

  let snoc l a =
    l ++ pure a
end


type parse_state =
  {
    emitted   : Ast'.clause Diff.t;
    fresh_cts : int   ID_Map.t;
    fresh_env : ident ID_Map.t;
  }


module PState = State_Util(struct type t = parse_state end)

include struct
  open PState
  open PState.Syntax

  let run_pstate : 'a PState.t -> 'a =
      fun ps -> snd @@ ps {
        emitted   = Diff.nil;
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
      emitted = Diff.snoc ps.emitted cl;
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
        emitted = Diff.nil;
      })
      (fun ps ps' -> { ps' with
        emitted = ps.emitted;
      })
      act


end [@warning "-K"]

