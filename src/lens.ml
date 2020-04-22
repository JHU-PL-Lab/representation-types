
type ('s, 't, 'a, 'b) lens = 
  {
    get : 's -> 'a;        (* Given an object 's, get some component 'a *)
    set : 'b -> 's -> 't;  (* Given a replacement component 'b, turn the 's into a 't *)
  }

(* lenses which don't change the types *)
type ('s, 'a) lens' = ('s, 's, 'a, 'a) lens

let lens get set = { get; set; }

let get l s   = l.get s
let set l b s = l.set b s

let over l f s =
  let a = get l s in
   set l (f a) s 

let compose l1 l2 =
  {
    get = (fun s   -> s |> get l1 |> get l2);
    set = (fun b s -> s |> set l1 (s |> get l1 |> set l2 b));
  }

module Syntax = struct
  let ( ^. ) s l   = get  l   s
  let ( =. ) l b s = set  l b s
  let ( %. ) l f s = over l f s
  let ( => ) = compose
end;;


let _1 =
  {
    get = fst;
    set = (fun b (_, snd) -> (b, snd));
  }

let _2 =
  {
    get = snd;
    set = (fun b (fst, _) -> (fst, b));
  }

let at n =
  {
    get = (fun a -> a.(n));
    set = (fun b a -> let a' = Array.copy a in a'.(n) <- b; a');
  }

let pair l1 l2 =
  {
    get = (fun (a, b) -> (get l1 a, get l2 b));
    set = (fun (c', d') (a, b) -> (set l1 c' a, set l2 d' b));
  }

let assoc key =
  {
    get = List.assoc key;
    set =
      (fun v l -> let l' = List.remove_assoc key l in
        (key, v) :: l');
  }

let assoc_opt key =
  {
    get = List.assoc_opt key;
    set =
      (fun v l -> let l' = List.remove_assoc key l in
       match v with
       | Some(v) -> (key, v) :: l'
       | None    -> l'
      );
  }

let head =
  {
    get = List.hd;
    set = (fun v xs -> v :: List.tl xs);
  }

let tail =
  {
    get = List.tl;
    set = (fun v xs -> List.hd xs :: v);
  }

let rec nth n =
  if n = 0 then head
  else (compose tail (nth (n - 1)))


let inside l = 
  {
    get = (fun    es e -> get l (es e));
    set = (fun eb es e -> set l (eb e) (es e));
  }

let sget l s = (s, get l s)

let sset l b s = (set l b s, ())