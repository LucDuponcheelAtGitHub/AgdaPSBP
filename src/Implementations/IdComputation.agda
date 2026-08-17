module Implementations.IdComputation where

open import Level using (zero)

open import Effect.Functor using (RawFunctor)
open import Effect.Applicative using (RawApplicative)
open import Effect.Monad using (RawMonad)

Id : Set → Set
Id A = A

idFunctor : RawFunctor {zero} {zero} Id
idFunctor = record { _<$>_ = λ f x → f x }

idApplicative : RawApplicative {zero} {zero} Id
idApplicative = record
  { rawFunctor = idFunctor
  ; pure = λ x → x
  ; _<*>_ = λ f x → f x
  }

idMonad : RawMonad {zero} {zero} Id
idMonad = record
  { rawApplicative = idApplicative
  ; _>>=_ = λ x f → f x
  }

