
(*

  MONOIDS

*)

module type Monoid = sig
  type t
  val append : t -> t -> t
  val empty : t
end

module MonoidUtil (M : Monoid) = struct
  include M
  module Syntax = struct 
    let ( <> ) = M.append
  end
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

module OptionMonoid_Any (M : Monoid)
  : Monoid with type t = M.t option =
struct
  type t = M.t option

  let append o1 o2 =
    match o1, o2 with
    | Some(m1), Some(m2) -> Some(M.append m1 m2)
    | None,     Some(m2) -> Some(m2)
    | Some(m1), None     -> Some(m1)
    | None,     None     -> None

  let empty = None
end

module OptionMonoid_All (M : Monoid)
  : Monoid with type t = M.t option =
struct
  type t = M.t option

  let append o1 o2 =
    match o1, o2 with
    | Some(m1), Some(m2) -> Some(M.append m1 m2)
    | None,     Some(_)  -> None
    | Some(_),  None     -> None
    | None,     None     -> None

  let empty = Some(M.empty)
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
  type +'a t
  val map : ('a -> 'b) -> 'a t -> 'b t
end

module FunctorUtil (F : Functor) = struct
  include F
  module Syntax = struct
    let ( <$> ) = F.map
    let ( let+ ) a f = F.map f a
  end
end

module Compose (F : Functor) (G : Functor)
  : Functor with type 'a t = 'a G.t F.t =
struct
  type +'a t = 'a G.t F.t
  let map f a = F.map (G.map f) a
end


(*

  FOLDABLES

*)

module type Foldable = sig
  type +'a t
  include Functor with type 'a t := 'a t

  module Make_Foldable (M : Monoid) : sig
    val fold_map : ('a -> M.t) -> 'a t -> M.t
  end
end

module FoldableUtil (F : Foldable) = struct
  include F
  include FunctorUtil(F)

  open struct
    module Endo (T : sig type t end)
      : Monoid with type t = T.t -> T.t =
    struct
      type t = T.t -> T.t
      let empty = (fun t -> t)
      let append f1 f2 = (fun t -> f1 (f2 t))
    end
    module Dual (M : Monoid)
      : Monoid with type t = M.t =
    struct
      type t = M.t
      let empty = M.empty
      let append m1 m2 = M.append m2 m1
    end
  end

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

(*

  APPLICATIVES

*)

module type Applicative = sig
  type +'a t
  include Functor with type 'a t := 'a t

  val pure  : 'a -> 'a t
  val apply : ('a -> 'b) t -> 'a t -> 'b t
end

module ApplicativeUtil (A : Applicative) = struct
  include A
  include FunctorUtil(A)

  module Syntax = struct
    include Syntax
    let ( <*> ) = A.apply
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

  TRAVERSABLES

*)

module type Traversable = sig
  type +'a t
  include Foldable with type 'a t := 'a t

  module Make_Traversable (A : Applicative) : sig
    val traverse : ('a -> 'b A.t) -> 'a t -> 'b t A.t
  end
end

module TraversableUtil (T : Traversable) = struct
  include T
  include FoldableUtil(T)

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
        let module F = FoldableUtil(F) in
        let acc xs y =
          match xs with
          | x::xs -> (xs, f y x)
          | [] -> raise Insufficent_zip_length
        in
        snd @@ map_accuml acc (F.to_list fb) ta

    let zip : type a b. a T.t -> b F.t -> (a * b) T.t =
      fun t f -> zip_with (fun a b -> (a, b)) t f
  end
  
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

(*

  MONADS

*)

module type Monad = sig
  type +'a t
  include Applicative with type 'a t := 'a t

  val bind : 'a t -> ('a -> 'b t) -> 'b t
end

module MonadUtil (M : Monad) = struct
  include M
  include ApplicativeUtil(M)

  module Syntax = struct
    include Syntax

    let ( let* ) = M.bind
    let ( >>= ) = M.bind
    let ( >=> ) f g = fun a -> a >>= f >>= g
  end

  let join mm = M.bind mm (fun m -> m)
end

(* 
  Monads do not compose to new monads in general.
  However, in the case that the two monads
  can be distributed between each other, it can be done.
*)
module type Distributive = sig
  module F : Monad
  module G : Monad
  val commute : 'a F.t G.t -> 'a G.t F.t
end

module ComposeM (D : Distributive)
  : Monad with type 'a t = 'a D.G.t D.F.t =
struct
  include ComposeA(D.F)(D.G)

  let bind fga f =
    D.F.bind fga @@ fun ga ->
    let gfgb = D.G.map f ga in
    let fggb = D.commute gfgb in
    D.F.map (fun ggb -> D.G.bind ggb (fun b -> b)) fggb
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

module Identity : sig
  include Monad       with type 'a t = 'a
  include Traversable with type 'a t = 'a
end =
struct
  type +'a t = 'a
  let map f a = f a
  let pure a = a
  let apply f a = f a
  let bind a f = f a

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


module WriterF (T : sig type t end)
  : Traversable with type 'a t = T.t * 'a =
struct
  type +'a t = T.t * 'a
  let map f (t, a) = (t, f a)

  module Make_Foldable (M : Monoid) = struct
    let fold_map am (_, a) = am a
  end

  module Make_Traversable (A : Applicative) = struct
    let traverse ab (t, a) =
      A.map (fun b -> (t, b)) (ab a)
  end
end

module Writer (T : Monoid) : sig
  include Monad       with type 'a t = T.t * 'a
  include Traversable with type 'a t = T.t * 'a
end =
struct
  include WriterF(T)

  let pure a = (T.empty, a)
  let apply (t1, f) (t2, a) = (T.append t1 t2, f a)

  let bind (t1, a) f =
    let (t2, b) = f a in (T.append t1 t2, b)
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


module State (S : sig type t end)
  : Monad with type 'a t = S.t -> (S.t * 'a) =
struct
  type +'a t = S.t -> (S.t * 'a)

  let map f a =
    fun s -> let (s', a) = a s in (s', f a)

  let pure a =
    fun s -> (s, a)

  let apply a1 a2 =
    fun s ->
      let (s' , a1) = a1 s  in
      let (s'', a2) = a2 s' in
        (s'', a1 a2)

  let bind a f s =
    let (s', v) = a s in f v s'
end



module Lists : sig
  include Monad       with type 'a t = 'a list
  include Traversable with type 'a t = 'a list
end =
struct
  type +'a t = 'a list
  let map f a = List.map f a
  let pure a = [a]
  let bind a f = List.concat @@ List.map f a
  let apply fs aa = bind fs (fun f -> map f aa)

  module Make_Foldable (M : Monoid) = struct
    let rec fold_map am =
      function
      | []      -> M.empty
      | a :: aa -> M.append (am a) (fold_map am aa)
  end

  module Make_Traversable (A : Applicative) = struct
    let rec traverse ab =
      let open ApplicativeUtil(A) in
      let open Syntax in
      function
      | [] -> A.pure []
      | a :: aa ->
          (fun b bb -> b :: bb) <$> (ab a) <*> (traverse ab aa)
  end
end


module Options : sig
  include Monad       with type 'a t = 'a option
  include Traversable with type 'a t = 'a option
end =
struct
  type +'a t = 'a option
  let map f a = Option.map f a
  let pure a = Some(a)
  let bind a f = Option.bind a f
  let apply f a = bind f (fun f -> map f a)

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
      | Some(a) -> ab a |> A.map (fun b -> Some(b))
  end
end


module Seqs : sig
  include Monad       with type 'a t = 'a Seq.t
  include Traversable with type 'a t = 'a Seq.t
end =
struct
  type 'a t = 'a Seq.t

  let map f s = Seq.map f s
  let pure a = Seq.return a
  let bind s f = Seq.flat_map f s
  let apply fs ss =
    bind fs @@ fun f -> map f ss

  module Make_Foldable (M : Monoid) = struct
    let fold_map am s =
      Seq.fold_left
        (fun m a -> M.append (am a) m) M.empty s
  end

  module Make_Traversable (A : Applicative) = struct
    let rec traverse at s =
      let open ApplicativeUtil(A) in
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
      let open ApplicativeUtil(A) in
      let open Syntax in
        M.fold (fun k b apm -> M.add <$> A.pure k <*> b <*> apm) m'
          (A.pure M.empty)
  end
end
