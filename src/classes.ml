
(*

  SHOW

*)

module type Show = sig
  type t
    [@@deriving show]
end

(*

  SHOW1

*)

module type Show1 = sig
  type 'a t
    [@@deriving show]
end


(*

  MONOIDS

*)

module type Semigroup = sig
  type t
  val append : t -> t -> t
end

module SemigroupUtil (S : Semigroup) = struct
  include S
  module Syntax = struct 
    let ( <> ) = S.append
  end
end

module type Monoid = sig
  type t
  include Semigroup with type t := t
  val empty : t
end

module First (T : sig type t val empty : t end)
  : Monoid with type t = T.t =
struct
  include T
  let append t1 _ = t1
end

module Last (T : sig type t val empty : t end)
  : Monoid with type t = T.t =
struct
  include T
  let append _ t2 = t2
end

module Dual (M : Monoid)
  : Monoid with type t = M.t =
struct
  type t = M.t
  let empty = M.empty
  let append m1 m2 = M.append m2 m1
end

module Endo (T : sig type t end)
  : Monoid with type t = T.t -> T.t =
struct
  type t = T.t -> T.t
  let empty = (fun t -> t)
  let append f1 f2 = (fun t -> f1 (f2 t))
end

module BooleanMonoid_Any
  : Monoid with type t = bool =
struct
  type t = bool
  let append = (||)
  let empty = false
end

module BooleanMonoid_All
  : Monoid with type t = bool =
struct
  type t = bool
  let append = (&&)
  let empty = true
end

module OptionMonoid (S : Semigroup) : sig
  include Monoid with type t = S.t option
end =
struct
  type t = S.t option

  let append o1 o2 =
    match o1, o2 with
    | Some(m1), Some(m2) -> Some(S.append m1 m2)
    | None,     Some(m2) -> Some(m2)
    | Some(m1), None     -> Some(m1)
    | None,     None     -> None

  let empty = None
end


module ListMonoid (T : sig type t end)
  : Monoid with type t = T.t list =
struct
  type t = T.t list
  let append l1 l2 = l1 @ l2
  let empty = []
end

(*

  FUNCTORS

*)

module type Functor = sig
  type 'a t
  val map : ('a -> 'b) -> 'a t -> 'b t
end

module Functor_Util (F : Functor) = struct
  include F
  module Syntax = struct
    let ( <$> ) = F.map
    let ( let+ ) a f = F.map f a
  end
end

module Compose (F : Functor) (G : Functor)
  : Functor with type 'a t = 'a G.t F.t =
struct
  type 'a t = 'a G.t F.t
  let map f a = F.map (G.map f) a
end

module Sum (F : Functor) (G : Functor)
: sig
    type 'a t = | InL of 'a F.t | InR of 'a G.t
    include Functor with type 'a t := 'a t
end
= struct
  type 'a t = | InL of 'a F.t | InR of 'a G.t
  
  let map f =
    function
    | InL fa -> InL (F.map f fa)
    | InR ga -> InR (G.map f ga)
end

module Distributive (F : Functor) (G : Functor) =
struct
  module type Inst = sig
    val distribute : 'a F.t G.t -> 'a G.t F.t
  end
end

(*

  COMONADS

*)

module type Comonad = sig
  type 'a t
  include Functor with type 'a t := 'a t

  val extract : 'a t -> 'a
  val extend : 'a t -> ('a t -> 'b) -> 'b t
end

module Comonad_Util (W : Comonad) = struct
  include W
  include Functor_Util(W)

  let duplicate w = extend w (fun a -> a)

  module Syntax = struct
    include Syntax
    let (=>>) = extend
    let (=>=) k1 k2 = fun w -> k2 (w =>> k1)
    let ( let@ ) = extend
  end
end

module SumC (F : Comonad) (G : Comonad)
  : Comonad with type 'a t = 'a Sum(F)(G).t =
struct
  include Sum(F)(G)
  type 'a t = 'a Sum(F)(G).t = | InL of 'a F.t | InR of 'a G.t

  let extract =
    function
    | InL fa -> F.extract fa
    | InR ga -> G.extract ga

  let extend sa f =
    map (fun _ -> f sa) sa
end

module ComposeC (F : Comonad) (G : Comonad) (D : Distributive(G)(F).Inst)
  : Comonad with type 'a t = 'a G.t F.t =
struct
  include Compose(F)(G)

  let extract fga = G.extract (F.extract fga)
  let extend fga f =
    let module F = Comonad_Util(F) in
    let module G = Comonad_Util(G) in
    F.extend fga @@ fun fga ->
      fga |> F.map (G.duplicate)
          |> D.distribute
          |> G.map f
end


(*

  FOLDABLES

*)

module type Foldable = sig
  type 'a t
  include Functor with type 'a t := 'a t

  module Make_Foldable (M : Monoid) : sig
    val fold_map : ('a -> M.t) -> 'a t -> M.t
  end
end

module Foldable_Util (F : Foldable) = struct
  include F
  include Functor_Util(F)

  let fold_map
    : type m. (module Monoid with type t = m) -> ('a -> m) -> ('a F.t) -> m =
    fun (module M) f fs ->
      let module F = F.Make_Foldable(M) in
      F.fold_map f fs

  let fold m fs = fold_map m (fun m -> m) fs

  let foldr : type a b. (a -> b -> b) -> b -> a F.t -> b =
    fun abb b0 fa ->
      let module Endo = Endo(struct type t = b end) in
      fold_map (module Endo) abb fa b0

  let foldl : type a b. (b -> a -> b) -> b -> a F.t -> b =
    fun bab b0 fa ->
    let module Endo = Endo(struct type t = b end) in
    let abb a b = bab b a in
      fold_map (module Dual(Endo)) abb fa b0

  let foldr' : type a b. (a -> b -> b) -> b -> a F.t -> b =
    fun abb b0 fa ->
      let f' k a b = let b = abb a b in k b in
      foldl f' (fun x -> x) fa b0
      
  let foldl' : type a b. (b -> a -> b) -> b -> a F.t -> b =
    fun bab b0 fa ->
      let f' a k b = let b = bab b a in k b in
      foldr f' (fun x -> x) fa b0

  let is_empty fa =
    foldr (fun _ _ -> false) true fa

  let length fa =
    foldl' (fun c _ -> c + 1) 0 fa

  let to_list fa =
    foldr (fun x xs -> x :: xs) [] fa

  let any p fb = fold_map (module BooleanMonoid_Any) p fb
  let all p fb = fold_map (module BooleanMonoid_All) p fb
end

module ComposeF (F : Foldable) (G : Foldable)
  : Foldable with type 'a t = 'a G.t F.t =
struct
  include Compose(F)(G)
  module Make_Foldable (M : Monoid) = struct
    let fold_map am fga =
      let module F' = F.Make_Foldable(M) in
      let module G' = G.Make_Foldable(M) in
        F'.fold_map (G'.fold_map am) fga
  end
end

module SumF (F : Foldable) (G : Foldable)
  : Foldable with type 'a t = 'a Sum(F)(G).t =
struct
  include Sum(F)(G)
  type 'a t = 'a Sum(F)(G).t = | InL of 'a F.t | InR of 'a G.t

  module Make_Foldable (M : Monoid) = struct
    let fold_map am f_ga =
      let module F' = F.Make_Foldable(M) in
      let module G' = G.Make_Foldable(M) in
      match f_ga with
      | InL fa -> F'.fold_map am fa
      | InR ga -> G'.fold_map am ga
  end
end

module NaturalTransformation (F : Functor) (G : Functor) =
struct
  module type Inst = sig
    val transform : 'a F.t -> 'a G.t
  end
end

(*

  APPLICATIVES

*)

module type Applicative = sig
  type 'a t
  include Functor with type 'a t := 'a t

  val pure  : 'a -> 'a t
  val apply : ('a -> 'b) t -> 'a t -> 'b t
end

module Applicative_Util (A : Applicative) = struct
  include A
  include Functor_Util(A)

  module Syntax = struct
    include Syntax
    let ( <*> ) = A.apply
    let ( *> ) a1 a2 = (fun _ a2 -> a2) <$> a1 <*> a2
    let ( <* ) a1 a2 = (fun a1 _ -> a1) <$> a1 <*> a2
    let ( and+ ) a1 a2 = (fun a b -> (a, b)) <$> a1 <*> a2
  end
end

module ComposeA (F : Applicative) (G : Applicative)
  : Applicative with type 'a t = 'a G.t F.t =
struct
  include Compose(F)(G)

  let pure a = F.pure (G.pure a)
  let apply f a = F.apply (F.apply (F.pure G.apply) f) a
end


(*

  ALTERNATIVES

*)

module type Alternative = sig
  type 'a t
  include Applicative with type 'a t := 'a t

  val empty : 'a t
  val append : 'a t -> 'a t -> 'a t
end

module Alternative_Util (A : Alternative) = struct
  include A
  include Applicative_Util(A)

  let rec some (a : 'a t) : 'a list t =
    let open Syntax in
    (fun x xs -> x :: xs) <$> a <*> many a

  and many (a : 'a t) : 'a list t =
    append (some a) (pure [])

  module Syntax = struct
    include Syntax
    let (<|>) = append
  end
end

module ComposeAlt (F : Alternative) (G : Alternative)
  : Alternative with type 'a t = 'a G.t F.t =
struct
  include ComposeA(F)(G)

  let empty = F.empty
  let append = F.append
end


(*

  TRAVERSABLES

*)

module type Traversable = sig
  type 'a t
  include Foldable with type 'a t := 'a t

  module Make_Traversable (A : Applicative) : sig
    val traverse : ('a -> 'b A.t) -> 'a t -> 'b t A.t
  end
end

module Traversable_Util (T : Traversable) = struct
  include T
  include Foldable_Util(T)

  module Make_Traversable (A : Applicative) = struct
    include T.Make_Traversable(A)
    let sequence ts = traverse (fun x -> x) ts
  end

  let map_accuml : type a b c. (a -> b -> (a * c)) -> a -> b T.t -> (a * c T.t) =
    fun f s t ->
    let module StateL : Applicative with type 'a t = a -> a * 'a =
      struct
        type 'a t = a -> a * 'a
        let map f sa s = let (s', a) = sa s in (s', f a)
        let pure a s = (s, a)
        let apply f1 f2 s =
          let (s', f1)  = f1 s  in
          let (s'', f2) = f2 s' in
            (s'', f1 f2)
      end in
    let open Make_Traversable(StateL) in
    traverse (fun b a -> f a b) t s

  let map_accumr : type a b c. (a -> b -> (a * c)) -> a -> b T.t -> (a * c T.t) =
    fun f s t ->
    let module StateR : Applicative with type 'a t = a -> a * 'a =
      struct
        type 'a t = a -> a * 'a
        let map f sa s = let (s', a) = sa s in (s', f a)
        let pure a s = (s, a)
        let apply f1 f2 s =
          let (s', f2)  = f2 s  in
          let (s'', f1) = f1 s' in
            (s'', f1 f2)
      end in
    let open Make_Traversable(StateR) in
    traverse (fun b a -> f a b) t s

  let reverse : type a. a T.t -> a T.t =
    fun t ->
      let [@warning "-8"] acc (x::xs) _ = (xs, x)
      in snd @@ map_accumr acc (to_list t) t

  module Make_Zip (F : Foldable) = struct
    exception Insufficent_zip_length

    let zip_with : type a b. (a -> b -> 'c) -> a T.t -> b F.t -> 'c T.t =
      fun f ta fb ->
        let module F = Foldable_Util(F) in
        let acc xs y =
          match xs with
          | x::xs -> (xs, f y x)
          | [] -> raise Insufficent_zip_length
        in
        snd @@ map_accuml acc (F.to_list fb) ta

    let zip : type a b. a T.t -> b F.t -> (a * b) T.t =
      fun t f -> zip_with (fun a b -> (a, b)) t f

  end

  let zip_with' f t1 t2 =
    let open Make_Zip(T) in
    zip_with f t1 t2
  
  let zip' t1 t2 =
    zip_with' (fun a b -> (a, b)) t1 t2

end

module ComposeT (F : Traversable) (G : Traversable)
  : Traversable with type 'a t = 'a G.t F.t =
struct
  include ComposeF(F)(G)
  module Make_Traversable (A : Applicative) = struct
    let traverse ab fga =
      let module F' = F.Make_Traversable(A) in
      let module G' = G.Make_Traversable(A) in
        F'.traverse (G'.traverse ab) fga
  end
end

module SumT (F : Traversable) (G : Traversable)
  : Traversable with type 'a t = 'a Sum(F)(G).t =
struct
  include SumF(F)(G)
  type 'a t = 'a Sum(F)(G).t = | InL of 'a F.t | InR of 'a G.t

  module Make_Traversable (A : Applicative) = struct
    let traverse (ab : 'a -> 'b A.t) (f_ga : 'a t) =
      let module F' = F.Make_Traversable(A) in
      let module G' = G.Make_Traversable(A) in
      match f_ga with
      | InL fa -> A.map (fun fb -> InL fb) (F'.traverse ab fa)
      | InR ga -> A.map (fun gb -> InR gb) (G'.traverse ab ga)
  end
end

(*

  MONADS

*)

module type Monad = sig
  type 'a t
  include Applicative with type 'a t := 'a t

  val bind : 'a t -> ('a -> 'b t) -> 'b t
end

module Monad_Util (M : Monad) = struct
  include M
  include Applicative_Util(M)

  module Syntax = struct
    include Syntax

    let ( let* ) = M.bind
    let ( >>= ) = M.bind
    let ( >> ) m1 m2 = m1 >>= fun _ -> m2
    let ( >=> ) f g = fun a -> f a >>= g
  end

  let join mm = M.bind mm (fun m -> m)
end


module ComposeM (F : Monad) (G : Monad) (D : Distributive(F)(G).Inst)
  : Monad with type 'a t = 'a G.t F.t =
struct
  include ComposeA(F)(G)

  let bind fga f =
    let module F = Monad_Util(F) in
    let module G = Monad_Util(G) in
    F.bind fga @@ fun ga ->
      ga |> G.map f
         |> D.distribute
         |> F.map (G.join)
end



(*

  INSTANCES

*)

module Strings
  : Monoid with type t = string =
struct
  type t = string
  let empty = ""
  let append s1 s2 = s1 ^ s2
end

module UnitM
  : Monoid with type t = unit =
struct
  type t = unit
  let empty = ()
  let append () () = ()
end

module Identity : sig
  type +'a t = 'a
  include Monad       with type 'a t := 'a t
  include Comonad     with type 'a t := 'a t
  include Traversable with type 'a t := 'a t
end =
struct
  type +'a t = 'a
  let map f a = f a
  let pure a = a
  let apply f a = f a
  let bind a f = f a

  let extract a = a
  let extend a f = f a

  module Make_Foldable (M : Monoid) = struct
    let fold_map am a = am a
  end

  module Make_Traversable (A : Applicative) = struct
    let traverse ab a = ab a
  end
end

module ConstF (T : sig type t end)
  : Functor with type 'a t = T.t =
struct
  type +'a t = T.t
  let map _ a = a
end

module Const (M : Monoid) : sig
  include Monad       with type 'a t = M.t
  include Traversable with type 'a t = M.t
end =
struct
  include ConstF(M)

  let pure _ = M.empty
  let apply a1 a2 = M.append a1 a2
  let bind a _ = a

  module Make_Foldable (M' : Monoid) = struct
    let fold_map _ _ = M'.empty
  end

  module Make_Traversable (A : Applicative) = struct
    let traverse _ c = A.pure c
  end
end


module Free (F : Functor) : sig
  type 'a t =
    | Pure of 'a | Join of 'a t F.t

  include Monad with type 'a t := 'a t
end =
struct
  type 'a t =
    | Pure of 'a | Join of 'a t F.t

  let rec map f =
    function
    | Pure a  -> Pure (f a)
    | Join fa -> Join (F.map (map f) fa)

  let pure a = Pure a

  let rec bind a f =
    match a with
    | Pure a  -> f a
    | Join fa -> Join (F.map (fun a -> bind a f) fa)

  let apply ff fa =
    bind ff (fun f -> map f fa)
end


module CoFree (F : Functor) : sig
  type 'a t = CoFree of 'a * 'a t F.t
  include Comonad with type 'a t := 'a t
end =
struct
  type 'a t = CoFree of 'a * 'a t F.t
  
  let rec map f (CoFree (a, fs)) =
    CoFree ((f a), F.map (map f) fs)

  let extract (CoFree (a, _)) = a

  let rec extend (CoFree (_, fs) as c) f =
    CoFree (f c, F.map (fun c -> extend c f) fs)
end


module WriterF (T : sig type t end) : sig
  include Comonad     with type 'a t = T.t * 'a
  include Traversable with type 'a t = T.t * 'a
end =
struct
  type +'a t = T.t * 'a
  let map f (t, a) = (t, f a)

  let extract (_, a) = a
  let extend ta f = (fst ta, f ta)

  module Make_Foldable (M : Monoid) = struct
    let fold_map am (_, a) = am a
  end

  module Make_Traversable (A : Applicative) = struct
    let traverse ab (t, a) =
      A.map (fun b -> (t, b)) (ab a)
  end
end

module Writer (M : Monoid) : sig
  module Monoid : Monoid with type t = M.t
  include Monad       with type 'a t = M.t * 'a
  include Comonad     with type 'a t = M.t * 'a
  include Traversable with type 'a t = M.t * 'a
end =
struct
  module Monoid = M
  include WriterF(M)

  let pure a = (M.empty, a)
  let apply (t1, f) (t2, a) = (M.append t1 t2, f a)

  let bind (t1, a) f =
    let (t2, b) = f a in (M.append t1 t2, b)
end


module Reader (T : sig type t end)
  : Monad with type 'a t = T.t -> 'a =
struct
  type +'a t = T.t -> 'a

  let map f a r = f (a r)

  let pure a _ = a

  let apply a1 a2 r = (a1 r) (a2 r)

  let bind a f r = f (a r) r
end

module ReaderC (M : Monoid) : sig
  module Monoid : Monoid with type t = M.t
  include Monad   with type 'a t = M.t -> 'a
  include Comonad with type 'a t = M.t -> 'a 
end =
struct
  module Monoid = M
  include Reader(M)

  let extract f = f M.empty
  let extend f fs r = fs (fun r' -> f (M.append r r'))
end


module StateI = struct
  type ('s1, 's2, 'a) ti = 's1 -> 's2 * 'a
  type ('s, 'a) t = ('s, 's, 'a) ti

  let map f a s1 =
    let (s2, a) = a s1 in (s2, f a)

  let pure a s1 =
    (s1, a)

  let apply f a =
    fun s1 ->
      let (s2, f) = f s1 in
      let (s3, a) = a s2 in
        (s3, f a)

  let bind a f s1 =
    let (s2, v) = a s1 in f v s2
end

module State (S : sig type t end)
  : Monad with type 'a t = S.t -> S.t * 'a =
struct
  include StateI
  type 'a t = (S.t, 'a) StateI.t
end

module State_Util (S : sig type t end) = struct
  module State = State(S)
  include Monad_Util(State)
  type 'a t = 'a State.t

  let get : S.t State.t =
    fun s -> (s, s)

  let gets f = map f get

  let put s' : unit State.t =
    fun _s -> (s', ())
  
  let control f f' (sa : 'a State.t) : 'a State.t =
    fun s ->
      let (s', a) = sa (f s) in
        (f' s s', a)
  
  let modify f : unit State.t =
    fun s -> (f s, ())

end


module RWSI (W : Monoid) = struct

  type ('r, 's1, 's2, 'a) ti =
    'r -> 's1 -> 's2 * W.t * 'a

  type ('r, 's, 'a) t = ('r, 's, 's, 'a) ti

  let map f ma r s =
    let (s', w, a) = ma r s in
      (s', w, f a)

  let pure a _r s =
    (s, W.empty, a)

  let apply mf ma r s =
    let (s',  w,  f) = mf r s  in
    let (s'', w', a) = ma r s' in
     (s'', W.append w w', f a)

  let bind ma fm r s =
    let (s',  w,  a) = ma r s    in
    let (s'', w', b) = fm a r s' in
      (s'', W.append w w', b)
end

module RWS (R : sig type t end) (W : Monoid) (S : sig type t end)
  : Monad with type 'a t = (R.t, S.t, 'a) RWSI(W).t
= struct
  include RWSI(W)
  type 'a t = (R.t, S.t, 'a) RWSI(W).t
end

module RWS_Util (R : sig type t end) (W : Monoid) (S : sig type t end)
= struct
  module RWS = RWS(R)(W)(S)
  include Monad_Util(RWS)

  let get : S.t RWS.t =
    fun _r s -> (s, W.empty, s)

  let gets (f : S.t -> 'a) : 'a RWS.t
    = map f get

  let put s' : unit RWS.t =
    fun _r _s -> (s', W.empty, ())

  let modify f : unit RWS.t =
    fun _r s -> (f s, W.empty, ())

  let control f f' (ma : 'a RWS.t) : 'a RWS.t =
    fun r s ->
      let (s', w, a) = ma r (f s) in
       (f' s s', w, a)

  let ask : R.t RWS.t =
    fun r s -> (s, W.empty, r)

  let asks (f : R.t -> 'a) : 'a RWS.t 
    = map f ask

  let local f ma : unit RWS.t =
    fun r s ->
      ma (f r) s

  let tell w : unit RWS.t =
    fun _r s -> (s, w, ())

  let pass (f : W.t -> W.t) (ma : 'a RWS.t) : 'a RWS.t =
    fun r s ->
      let (s', w, a) = ma r s in
       (s', f w, a)

  let listen (ma : 'a RWS.t) : ('a * W.t) RWS.t =
    fun r s ->
      let (s', w, a) = ma r s in
       (s', w, (a, w))

  let listen' (ma : unit RWS.t) : W.t RWS.t =
    map snd (listen ma)

end



module Lazies : sig
  type +'a t = 'a Lazy.t
  include Monad   with type 'a t := 'a t
  include Comonad with type 'a t := 'a t
end =
struct
  type +'a t = 'a lazy_t

  let map f a = lazy (f (Lazy.force a))

  let pure a = lazy a

  let apply f a = lazy (Lazy.force f (Lazy.force a))

  let bind a f = lazy (Lazy.force (f (Lazy.force a)))

  let extract a = Lazy.force a

  let extend a f = lazy (f a)
end


module Units : sig
  type 'a t = unit
  include Monad       with type 'a t := 'a t
  include Traversable with type 'a t := 'a t
end =
struct
  type 'a t = unit

  let map _ () = ()
  let pure _ = ()
  let apply () () = ()
  let bind () _ = ()

  module Make_Foldable (M : Monoid) = struct
    let fold_map _ () = M.empty
  end

  module Make_Traversable (A : Applicative) = struct
    let traverse _ () = A.pure ()
  end

end


module Lists : sig
  include Alternative with type 'a t = 'a list
  include Monad       with type 'a t = 'a list
  include Traversable with type 'a t = 'a list
end =
struct
  type +'a t = 'a list
  let map f a = List.map f a
  let pure a = [a]
  let bind a f = List.concat @@ List.map f a
  let apply fs aa = bind fs (fun f -> map f aa)

  let empty = []
  let append = (@)

  module Make_Foldable (M : Monoid) = struct
    let fold_map am l =
      List.fold_left (fun m a -> M.append m (am a)) M.empty l
  end

  module Make_Traversable (A : Applicative) = struct
    let rec traverse ab =
      let open Applicative_Util(A) in
      let open Syntax in
      function
      | [] -> A.pure []
      | a :: aa ->
          (fun b bb -> b :: bb) <$> (ab a) <*> (traverse ab aa)
  end
end

module NonEmpty : sig 
  include Monad       with type 'a t = 'a * 'a list
  include Comonad     with type 'a t = 'a * 'a list
  include Traversable with type 'a t = 'a * 'a list
end =
struct
  type +'a t = 'a * 'a list

  let map f (x, xs) = (f x, List.map f xs)
  let pure a = (a, [])
  let bind (x, xs) f =
    let rec concat ((x0, x0s), xNs) =
      match xNs with
      | [] -> (x0, x0s)
      | (x1, x1s) :: xNs ->
        concat ((x0, x0s @ x1 :: x1s), xNs)
    in
    concat @@ map f (x, xs)

  let rec apply (f, fs) (x, xs) =
    match fs, xs with
    | f' :: fs', x' :: xs' ->
      let (fx', fsxs') = apply (f', fs') (x', xs') in
        (f x, fx' :: fsxs')
    | _ -> (f x, [])

  let extract (x, _) = x

  let rec extend xxs f =
    match snd xxs with
    | []      -> (f xxs, [])
    | x'::xs' ->
      let (x'', xs'') = extend (x', xs') f in
        (f xxs, x'' :: xs'')

  module Make_Foldable (M : Monoid) = struct
    let fold_map am (x, xs) =
      List.fold_left (fun m a -> M.append m (am a)) (am x) xs
  end

  module Make_Traversable (A : Applicative) = struct
    let traverse at (x, xs) =
      let open Lists.Make_Traversable(A) in
      let open Applicative_Util(A) in
      let open Syntax in
      (fun x xs -> (x, xs)) <$> at x <*> traverse at xs
  end

end

module Options : sig
  include Alternative with type 'a t = 'a option
  include Monad       with type 'a t = 'a option
  include Traversable with type 'a t = 'a option
end =
struct
  type +'a t = 'a option
  let map f a = Option.map f a
  let pure a = Some(a)
  let bind a f = Option.bind a f
  let apply f a = bind f (fun f -> map f a)

  let empty = None
  let append o1 o2 =
    match o1 with None -> o2 | _ -> o1

  module Make_Foldable (M : Monoid) = struct
    let fold_map am =
      function
      | Some(a) -> am a
      | None    -> M.empty
  end

  module Make_Traversable (A : Applicative) = struct
    let traverse ab =
      function
      | None    -> A.pure None
      | Some(a) -> ab a |> A.map Option.some
  end
end


module Seqs : sig
  include Monad       with type 'a t = 'a Seq.t
  include Traversable with type 'a t = 'a Seq.t
end =
struct
  type 'a t = 'a Seq.t

  let map f s = Seq.map f s
  let rec pure a = fun () -> Seq.Cons(a, pure a)
  let bind s f = Seq.flat_map f s

  let rec apply fs ss () =
    match fs (), ss () with
    | Seq.Cons (f, fs'), Seq.Cons (s, ss') ->
        Seq.Cons (f s, apply fs' ss')
    | _ -> Seq.Nil

  module Make_Foldable (M : Monoid) = struct
    let fold_map am s =
      Seq.fold_left
        (fun m a -> M.append m (am a)) M.empty s
  end

  module Make_Traversable (A : Applicative) = struct
    let rec traverse at s =
      let open Applicative_Util(A) in
      let open Syntax in
      match s () with
      | Seq.Nil         -> A.pure Seq.empty
      | Seq.Cons(a, s') ->
        (fun a s () -> Seq.Cons(a, s)) <$> (at a) <*> (traverse at s')
  end
end



module Maps (M : Map.S)
  : Traversable with type 'a t = 'a M.t =
struct
  type 'a t = 'a M.t

  let map f m = M.map f m

  module Make_Foldable (M' : Monoid) = struct
    let fold_map am m =
      M.fold (fun _ a m -> M'.append (am a) m) m M'.empty
  end

  module Make_Traversable (A : Applicative) = struct
    let traverse at m =
      let m' = M.map at m in
      let open Applicative_Util(A) in
      let open Syntax in
        M.fold (fun k b apm -> M.add <$> A.pure k <*> b <*> apm) m'
          (A.pure M.empty)
  end
end


module Arrays (Size : sig val length : int end) : sig
  type 'a t = 'a array
  include Monad with type 'a t := 'a t
  include Traversable with type 'a t := 'a t
end = 
struct
  type 'a t = 'a array

  let map f ar = Array.map f ar
  let pure a = Array.make Size.length a
  let apply fs xs =
    Array.map2 (@@) fs xs

  let bind xs f =
    map f xs |> Array.mapi 
      (fun ix xx -> xx.(ix))


  module Make_Foldable (M : Monoid) = struct
    let fold_map am xs =
      Array.fold_left (fun m a -> M.append m (am a)) M.empty xs
  end

  module Make_Traversable (A : Applicative) = struct
    let traverse at xs =
      let module L = Lists.Make_Traversable(A) in
      A.map Array.of_list
      @@ L.traverse at
      @@ Array.to_list xs
  end

end