
(**
  Definitions of various useful design patterns
  modeled after various Haskell typeclasses,
  and useful for monads and more.
*)


(** {1 Semigroups} *)

(**
  Types whose values can be combined
  in a regular manner.

  Requires that {!Semigroup.append} is associative,
  to be true to form:
  {[
    append a (append b c) == append (append a b) c
  ]}
*)
module type Semigroup = sig
  type t
  val append : t -> t -> t (** combine two {!t} values *)
end

(**
  Easily-derived helper definitions to be
  attached to a {!Semigroup} implementation.
*)
module Semigroup_Util (S : Semigroup) = struct
  include S

  module Syntax = struct 
    (** Synonym for {!S.append} *)
    let ( <> ) = S.append
  end
end

(**
  The trivial semigroup which
  always takes the first operand.
*)
module First (T : sig type t end)
  : Semigroup with type t = T.t =
struct
  include T
  let append t1 _ = t1
end

(**
  The trivial semigroup which
  always takes the last operand.
*)
module Last (T : sig type t end)
  : Semigroup with type t = T.t =
struct
  include T
  let append _ t2 = t2
end

(** {1 Monoids} *)

(**
  Types which form a {!Semigroup}, and
  which additionally have some zero element.

  Requires associativity and that
  {[
    append m empty == m
    append empty m == m
  ]}
*)
module type Monoid = sig
  type t
  include Semigroup with type t := t
  val empty : t (** the identity/zero element of {!t} *)
end

(**
  The "dual" of the provided monoid,
  which appends elements in the opposite order.
*)
module Dual (M : Monoid)
  : Monoid with type t = M.t =
struct
  type t = M.t
  let empty = M.empty
  let append m1 m2 = M.append m2 m1
end

(**
  The monoid on endomorphisms ['a -> 'a].
*)
module Endo (T : sig type t end)
  : Monoid with type t = T.t -> T.t =
struct
  type t = T.t -> T.t
  let empty = (fun t -> t)
  let append f1 f2 = (fun t -> f1 (f2 t))
end

(**
  The monoid given by booleans and disjunction.
*)
module BooleanMonoid_Any
  : Monoid with type t = bool =
struct
  type t = bool
  let append = (||)
  let empty = false
end

(**
  The monoid given by booleans and conjunction.
*)
module BooleanMonoid_All
  : Monoid with type t = bool =
struct
  type t = bool
  let append = (&&)
  let empty = true
end

(**
  For any semigroup [S], [S.t option] forms
  a monoid such that {!None} is the empty
  element and others are combined according
  to [S.append].
*)
module OptionMonoid (S : Semigroup)
  : Monoid with type t = S.t option =
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

(**
  For any element type [t], [t list] is
  the so-called "free monoid" for [t], using
  concatenation for append and the empty list
  as the zero element.
*)
module ListMonoid (T : sig type t end)
  : Monoid with type t = T.t list =
struct
  type t = T.t list
  let append l1 l2 = l1 @ l2
  let empty = []
end

(** {1 Functors} *)

(**
  Types which can be mapped over in some sense.
  Regular functions can be lifted to operate over
  elements of a functor with {!Functor.map}.

  Conceptually the functor is not consistent unless
  mapping the identity function does nothing:
  {[
    map (fun x -> x) f == f
  ]}
*)
module type Functor = sig
  type 'a t

  (** Lift a regular function to operate over {!t}s *)
  val map : ('a -> 'b) -> 'a t -> 'b t
end

(**
  Easily-derived helper definitions to be
  attached to a {!Functor} implementation.
*)
module Functor_Util (F : Functor) = struct
  include F
  module Syntax = struct

    (** Synonym for {!F.map} *)
    let ( <$> ) = F.map

    (** Let-operator for {!F.map} *)
    let ( let+ ) a f = F.map f a
  end
end

(**
  Given any two {!Functor}s [F] and [G],
  their composition is also a functor.
*)
module Compose (F : Functor) (G : Functor)
  : Functor with type 'a t = 'a G.t F.t =
struct
  type 'a t = 'a G.t F.t
  let map f a = F.map (G.map f) a
end

(**
  Given any two {!Functor}s [F] and [G],
  their disjoint sum is also a functor.
*)
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

(**
  Two functors are said to be distributive if
  one can commute the two type constructors.
*)
module Distributive (F : Functor) (G : Functor) =
struct
  module type Inst = sig
    (** Commute the order of the type constructors {!F.t} and {!G.t} *)
    val distribute : 'a F.t G.t -> 'a G.t F.t
  end
end

(** {1 Comonads} *)

(**
  Functors which additionally allow operations to
  view enclosing (even non-local) structure in their mapping operations,
  or throw away the additional structure for the internal value

  Note that the definitions of {!Comonad.extract} and
  {!Comonad.extend} should satisfy certain principles in order
  to behave predictably. These expectations include:
  {[
    extend extract w == w
    extract (extend f w) == f w
    extend f (extend g w) == extend (compose f g) w

    map f w = extend (fun w -> f (extract w)) w
  ]}
  
  The first two are the most important to guarantee
  to insure correctness for the others, in practice.
*)
module type Comonad = sig
  type 'a t
  include Functor with type 'a t := 'a t

  (** Throw away the comonadic context {!t}. *)
  val extract : 'a t -> 'a
  
  (** Propagate the context {!t} through a computation which consumes it. *)
  val extend : 'a t -> ('a t -> 'b) -> 'b t
end

(**
  Easily-derived helper definitions to be
  attached to a {!Comonad} implementation.
*)
module Comonad_Util (W : Comonad) = struct
  include W
  include Functor_Util(W)

  (** Construct another layer of context. *)
  let duplicate w = extend w (fun a -> a)

  module Syntax = struct
    include Syntax

    (** Synonym for {!W.extend} *)
    let (=>>) = extend

    (** Composition of Cokleisli arrows *)
    let (=>=) k1 k2 = fun w -> k2 (w =>> k1)
    
    (** A let-operator for {!W.extend}. Perhaps useful? *)
    let ( let@ ) = extend
  end
end

(**
  Given any two {!Comonad}s [F] and [G],
  their disjoint sum is also a comonad.
*)
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

(**
  If two {!Comonad}s [F] and [G] are {!Distributive},
  then their composition is also a comonad.
*)
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


(** {1 Foldables} *)

(**
  Functors which can be reduced by applying
  monoidal actions over their internal structure.
*)
module type Foldable = sig
  type 'a t
  include Functor with type 'a t := 'a t

  (**
    Given a particular {!Monoid},
    provide a means to reduce our structure to it.
  *)
  module Make_Foldable (M : Monoid) : sig

    (** Given a conversion into monoid {!M}, collapse the structure of {!t}. *)
    val fold_map : ('a -> M.t) -> 'a t -> M.t
  end
end


(**
  Easily-derived helper definitions to be
  attached to a {!Foldable} implementation.
*)
module Foldable_Util (F : Foldable) = struct
  include F
  include Functor_Util(F)

  (**
    A version of {!Foldable.Make_Foldable.fold_map}
    which can take a first-class module for [M].
  *)
  let fold_map
    : type m. (module Monoid with type t = m) -> ('a -> m) -> ('a F.t) -> m =
    fun (module M) f fs ->
      let module F = F.Make_Foldable(M) in
      F.fold_map f fs

  (**
    Equivalent to {!fold_map} with the identity.
  *)
  let fold m fs = fold_map m (fun m -> m) fs

  (**
    Right-associated fold of a binary operation.
  *)
  let foldr : type a b. (a -> b -> b) -> b -> a F.t -> b =
    fun abb b0 fa ->
      let module Endo = Endo(struct type t = b end) in
      fold_map (module Endo) abb fa b0

  (**
    Left-associated fold of a binary operation
  *)
  let foldl : type a b. (b -> a -> b) -> b -> a F.t -> b =
    fun bab b0 fa ->
    let module Endo = Endo(struct type t = b end) in
    let abb a b = bab b a in
      fold_map (module Dual(Endo)) abb fa b0

  (**
    Simulate a right-associated fold with {!foldl}
  *)
  let foldr' : type a b. (a -> b -> b) -> b -> a F.t -> b =
    fun abb b0 fa ->
      let f' k a b = let b = abb a b in k b in
      foldl f' (fun x -> x) fa b0
      
  (**
    Simulate a left-associated fold with {!foldr}
  *) 
  let foldl' : type a b. (b -> a -> b) -> b -> a F.t -> b =
    fun bab b0 fa ->
      let f' a k b = let b = bab b a in k b in
      foldr f' (fun x -> x) fa b0

  (**
    Determine whether some {!Foldable} is empty.
  *)
  let is_empty fa =
    foldr (fun _ _ -> false) true fa

  (**
    Find the length of some {!Foldable}.
  *)
  let length fa =
    foldl' (fun c _ -> c + 1) 0 fa

  (**
    Convert some {!Foldable} functor to a list.
  *)
  let to_list fa =
    foldr (fun x xs -> x :: xs) [] fa

  (**
    Check if {!any} element in the {!Foldable} satisfies some predicate.
  *)
  let any p fb = fold_map (module BooleanMonoid_Any) p fb

  (**
    Check if {!all} elements in the {!Foldable} satisfy some predicate.
  *)
  let all p fb = fold_map (module BooleanMonoid_All) p fb

end

(**
  For any {!Foldable}s [F] and [G],
  their composition is also foldable.
*)
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

(**
  For any foldables [F] and [G],
  their disjoint sum is also foldable.
*)
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

(** {1 Applicative Functors} *)

(**
  Functors which additionally admit pure
  values to be added to a context with {!Applicative.pure},
  and for contexts to be combined with {!Applicative.apply}.

  Instances should satisfy:
  {[
    apply (pure f) a = map f a
    apply (pure f) (pure x) = pure (f x)

  ]}
*)
module type Applicative = sig
  type 'a t
  include Functor with type 'a t := 'a t

  (** Embed a pure value into the applicative context {!t} *)
  val pure  : 'a -> 'a t

  (** Compose applicative effects together *)
  val apply : ('a -> 'b) t -> 'a t -> 'b t
end

(**
  Easily-derived helper definitions to be
  attached to a {!Applicative} implementation.
*)
module Applicative_Util (A : Applicative) = struct
  include A
  include Functor_Util(A)

  (**
    Lift a binary function to the level of
    the {!Applicative}. Like a binary {!map}.
  *)
  let lift2 f a1 a2 =
    A.apply (A.map f a1) a2
  (**
    It is not {i so} impressive a function however,
    considering that an arbitrary liftN is better modeled by
    {[
      f <$> a1 <*> ... <*> aN
    ]}
  *)

  module Syntax = struct
    include Syntax
 
    (** Synonym for {!A.apply} *)
    let ( <*> ) = A.apply

    (** [*>] links two {!Applicative} values, keeping only the {i right} result. *)
    let ( *> ) a1 a2 = (fun _ a2 -> a2) <$> a1 <*> a2

    (** [<*] links two {!Applicative} values, keeping only the {i left} result. *)
    let ( <* ) a1 a2 = (fun a1 _ -> a1) <$> a1 <*> a2

    (** Let-operator allowing multiple bindings at once, powered by the underlying {!Applicative}. *)
    let ( and+ ) a1 a2 = (fun a b -> (a, b)) <$> a1 <*> a2
    (**
      This allows e.g.
      {[
        let+ x = [1; 2; 3]
        and+ y = [4; 5; 6]
        in x + y
      ]}

      But just as in a normal [let/and] binding,
      the value of [y] cannot depend on [x].
      This would require a monad in general.
    *)
  end
end

(**
  For any two {!Applicative} functors [F] and [G],
  their composition is also an applicative functor.
*)
module ComposeA (F : Applicative) (G : Applicative)
  : Applicative with type 'a t = 'a G.t F.t =
struct
  include Compose(F)(G)

  let pure a = F.pure (G.pure a)
  let apply f a = F.apply (F.apply (F.pure G.apply) f) a
end


(** {1 Alternative Functors} *)

(**
  Applicative functors which themselves have
  some sort of monoidal structure.

  The {!Alternative} laws mirror those of {!Monoid}.
*)
module type Alternative = sig
  type 'a t
  include Applicative with type 'a t := 'a t

  (** Parallel to the {!Monoid}al {{!Monoid.empty} empty} *)
  val empty : 'a t
  
  (** Parallel to the {!Monoid}al {{!Monoid.append} append} *)
  val append : 'a t -> 'a t -> 'a t
  (** Note especially how this signature differs from {!apply} *)
end

(**
  Easily-derived helper definitions to be
  attached to a {!Alternative} implementation.
*)
module Alternative_Util (A : Alternative) = struct
  include A
  include Applicative_Util(A)

  (** Like regular expression [+], "one or more" *)
  let rec some (a : 'a t) : 'a list t =
    let open Syntax in
    (fun x xs -> x :: xs) <$> a <*> many a

  (** Like regular expression kleene star, "zero or more" *)
  and many (a : 'a t) : 'a list t =
    append (some a) (pure [])

  (**
    The above definitions for {!some} and {!many}
    might not really work due to OCaml's strictness.
    Alternative formulations using {!lazy} might be necessary.
  *)

  module Syntax = struct
    include Syntax

    (** Synonym for {!A.append} *)
    let (<|>) = append
  end
end

(**
  Given any two alternative applicative functors [F] and [G],
  their composition is also an alternative applicative functor.
  (this definition just delegates to the outer functor's implementation).
*)
module ComposeAlt (F : Alternative) (G : Alternative)
  : Alternative with type 'a t = 'a G.t F.t =
struct
  include ComposeA(F)(G)

  let empty = F.empty
  let append = F.append
end


(** {1 Traversables} *)

(**
  Foldables which can distribute their internal
  structure through a given {!Applicative} functor,
  to sequence the underlying {!Applicative} effects.

  The laws to obey here are
  - [traverse] must visit each element exactly once.
  - [traverse] cannot modify the underlying structure.
  - and:
  {[
    traverse A.pure x == A.pure x
  ]}
  (which mostly follows from the first two.)

*)
module type Traversable = sig
  type 'a t
  include Foldable with type 'a t := 'a t

  (**
    Given a particular {!Applicative}, provide
    the definition of {{!Make_Traversable.traverse}traverse} for it.
  *)
  module Make_Traversable (A : Applicative) : sig
    (**
      Walk over the {!t} in {!Foldable} order,
      transforming each value to an effect in {!A.t},
      and sequencing the effects while rebuilding
      the {!t} shape within using the new values.
    *)
    val traverse : ('a -> 'b A.t) -> 'a t -> 'b t A.t
  end
end


(**
  Easily-derived helper definitions to be
  attached to a {!Traversable} implementation.
*)
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

  (**
    Invert the order of elements in a {!Traversable.t}.
  *)
  let reverse : type a. a T.t -> a T.t =
    fun t ->
      let [@warning "-8"] acc (x::xs) _ = (xs, x)
      in snd @@ map_accumr acc (to_list t) t

  (**
    Given a {!Foldable} [F], take in two structures
    of equal {!length} and produce a {!T.t} of pairs.

    One cannot, in general, modify the structure during {!traverse},
    and so this must throw an exception if the lengths are not
    the same. Curiously, this is also the behavior of OCaml's
    {!List.combine_with} and {!List.combine}, so it's consistent
    at least.
  *)
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

  (** Alias for {!Make_Zip.zip_with} when the foldable is {!T} itself. *)
  let zip_with' f t1 t2 =
    let open Make_Zip(T) in
    zip_with f t1 t2
  
  (** Alias for {!Make_Zip.zip} when the foldable is {!T} itself. *)
  let zip' t1 t2 =
    zip_with' (fun a b -> (a, b)) t1 t2

end

(**
  Given two {!Traversable}s [F] and [G],
  their composition is also traversable.
*)
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

(**
  Given two {!Traversable}s [F] and [G],
  their disjoint sum is also traversable.
*)
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

(**
  {1 Monads} 
  (your feature presentation) 
*)

(**
  Applicative functors which also allow
  later computations to depend upon prior effectful results.

  Monad laws:
  {[
    bind m pure == m
    bind (pure m) f == f m
    bind (bind m f) g == bind m (fun m -> bind (f m) g)
  ]}
*)
module type Monad = sig
  type 'a t
  include Applicative with type 'a t := 'a t

  (** Use an effectful ['a] to produce a new effectful computation. *)
  val bind : 'a t -> ('a -> 'b t) -> 'b t
  (**
    Alternately: {!map} over the {!t}, then eliminate the double-nesting.
  *)
end

(**
  Easily-derived helper definitions to be
  attached to a {!Monad} implementation.
*)
module Monad_Util (M : Monad) = struct
  include M
  include Applicative_Util(M)

  module Syntax = struct
    include Syntax
      
    (** Synonym for {!M.bind} *)
    let ( >>= ) = M.bind

    (** Composition of kleisli arrows. *)
    let ( >=> ) f g = fun a -> f a >>= g

    (** Let-operator for {!M.bind}. {i THE} programmable semicolon. *)
    let ( let* ) = M.bind
  end

  (** Compress two effect layers of {!t} into one. *)
  let join mm = M.bind mm (fun m -> m)
end

(**
  If two {!Monad}s [F] and [G] are {!Distributive},
  then the composition of [F] and [G] is also a monad.
*)
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


(** {1 Assorted Instances} *)

(**
  Strings form a {!Monoid} with [""] and [^].
*)
module Strings
  : Monoid with type t = string =
struct
  type t = string
  let empty = ""
  let append s1 s2 = s1 ^ s2
end

(**
  The {!unit} type forms a trivial monoid.
*)
module UnitM
  : Monoid with type t = unit =
struct
  type t = unit
  let empty = ()
  let append () () = ()
end

(**
  Wrapping a type in {!Identity.t} does nothing.
  This is often useful and can fulfill many of
  the most poserful class requirements defined here, including
  {!Monad}, {!Comonad}, and {!Traversable}.
*)
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

(**
  The constant functor holds no value of the type it
  is parametrized over at all, and ignores {!Functor.map}
  entirely. Instead, it holds a value of another type.
  When it is traversed or folded over, it always has
  an empty value or effect.
*)
module ConstT (T : sig type t end) : sig
  include Functor     with type 'a t = T.t
  include Traversable with type 'a t = T.t
end =
struct
  type +'a t = T.t
  let map _ a = a

  module Make_Foldable (M' : Monoid) = struct
    let fold_map _ _ = M'.empty
  end

  module Make_Traversable (A : Applicative) = struct
    let traverse _ c = A.pure c
  end
end

(**
  When the type the constant functor holds is
  itself a {!Monoid}, then we can upgrade our
  functor to fulfill the whole suite of {!Monad}.
*)
module Const (M : Monoid) : sig
  include Monad       with type 'a t = M.t
  include Traversable with type 'a t = M.t
end =
struct
  include ConstT(M)

  let pure _ = M.empty
  let apply a1 a2 = M.append a1 a2
  let bind a _ = a
end

(**
  The free {!Monad} for a given {!Functor} [F].

  Also includes the convenience function {!Free.free}
  to lift a functor value into the monad.
*)
module Free (F : Functor) : sig
  type 'a t =
    | Pure of 'a | Join of 'a t F.t

  include Monad with type 'a t := 'a t

  val free : 'a F.t -> 'a t
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

  let free fa = Join (F.map (fun x -> Pure x) fa)
end

(**
  The cofree {!Comonad} for some {!Functor} [F].
*)
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

(** {1 Significantly Used Instances} *)

(**
  The Writer {!Comonad} (also called Env)
  wraps values in a context pairing them with some other type.
  That is, it is the functor [(t * _)] for some [t].
*)
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

(**
  When the type we pair each value with in the
  Writer {!Comonad} is {!Monoid}al, we also gain
  all of the {!Monad} abilities as well.
  This chains together the monoidal actions we
  generate as the result of various applicative effects.
*)
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

(**
  The Reader {!Monad} is the functor given by [t -> _] for some [t],
  and is adjoint to Writer. This represents values which
  require some shared context/input in order to compute.
*)
module Reader (T : sig type t end)
  : Monad with type 'a t = T.t -> 'a =
struct
  type +'a t = T.t -> 'a

  let map f a r = f (a r)

  let pure a _ = a

  let apply a1 a2 r = (a1 r) (a2 r)

  let bind a f r = f (a r) r
end

(**
  When the context each value depends on in the
  Reader {!Monad} is {!Monoid}al, then we gain
  all of the {!Comonad} operations here too.
*)
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

(**
  An indexed state monad. That is, this very general state monad
  allows the state type to change at each operation step.
  This is not necessary most of the time, but these function
  definitions are still useful to define the regular {!State} module.
*)
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

(**
  The state {!Monad}. Values with a mutable shared state.
*)
module State (S : sig type t end)
  : Monad with type 'a t = S.t -> S.t * 'a =
struct
  include StateI
  type 'a t = (S.t, 'a) StateI.t
end

(**
  Because the {!State} {!Monad} has other frequently-used
  operations, they are defined here for free.
  Generally using {!State_Util} instead of {!State} itself
  is easier.
*)
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

(**
  Indexed Reader-Writer-State {!Monad}.
  It turns out, the composition of {!Reader}, {!Writer},
  and {!State} can be useful as a generalization of the three,
  separating read-only, write-only, and mutable values.
*)
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

(**
  The concrete Reader-Writer-State {!Monad} with
  the provided types for each component.
*)
module RWS (R : sig type t end) (W : Monoid) (S : sig type t end)
  : Monad with type 'a t = (R.t, S.t, 'a) RWSI(W).t
= struct
  include RWSI(W)
  type 'a t = (R.t, S.t, 'a) RWSI(W).t
end

(**
  Analog of {!State_Util} for the {!RWS} stack.
  This includes all of the {!State} actions as well
  as those common for {!Reader} and {!Writer}.
  A very full suite of options.
*)
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


(**
  {!Lazy.t} values can have {!Monad} and {!Comonad} instances
  defined for them.
*)
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

(**
  Whereas {!UnitM} is a stub, meaningless {!Monoid},
  {!Units} is the equivalent for arity-1 type constructors
  by making use of the {!Const} monad.
*)
module Units = Const(UnitM)

(**
  The OCaml list type supports various classes defined here,
  most notably {!Traversable}, {!Alternative}, and {!Monad},
  where it often represents non-deterministic computations
  or the free monoid.
*)
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

(**
  Non-empty lists (represented as a pair of value and list)
  gain the ability to implement {!Comonad}, but lose their
  {!Alternative} instance (as there is no [empty] list, duh).
  Their {!Monad} instance is also "zippy", rather than
  "non-deterministic".
*)
module NonEmpty : sig 
  include Monad       with type 'a t = 'a * 'a list
  include Comonad     with type 'a t = 'a * 'a list
  include Traversable with type 'a t = 'a * 'a list
end =
struct
  type +'a t = 'a * 'a list

  let map f (x, xs) = (f x, List.map f xs)

  (**
    I would have made this create an {i infinite}
    list, but then OCaml would be too strict.
  *)
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

(**
  The OCaml option type also supports notions of
  partial computation, and a {!First}-esque instance
  of {!Alternative}. It is also {!Traversable}.
*)
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

(**
  The {!Seq} type can be seen as a
  {!Traversable} {!Monad}, like a lazy nondeterministic
  list with zippy application.
*)  
module Seqs : sig
  include Monad       with type 'a t = 'a Seq.t
  include Traversable with type 'a t = 'a Seq.t
end =
struct
  type 'a t = 'a Seq.t

  let map f s = Seq.map f s

  (** Here, we {i can} make it infinite. *)
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


(**
  Let's not leave out OCaml {!Map}s, which unfortunately do
  not have a lawful {!Applicative} (even with monoidal keys)
  but are {!Traversable}, which is still useful.
*)
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
