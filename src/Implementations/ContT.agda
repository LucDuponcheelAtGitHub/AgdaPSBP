module Implementations.ContT where

open import Level using (zero)

open import Effect.Monad using (RawMonad)
open import Effect.Monad.Identity as IdentityModule public using (Identity)

open import Utilities.ComputationValuedFunction

open import Specifications.Functional
open import Specifications.Functorial
open import Specifications.Sequential
open import Specifications.Creational
open import Specifications.Conditional

open import Implementations.ComputationValuedFunction using 
  (module ComputationValuedFunctionInstances)

ContT : Set → (Set → Set) → Set → Set
ContT R M A = (A → M R) → M R

module ContTInstances {R : Set} {M : Set → Set} (monad : RawMonad {zero} {zero} M) where
  open RawMonad monad

  contTMonad : RawMonad {zero} {zero} (ContT R M)
  contTMonad = record
    { rawApplicative = record
        { rawFunctor = record
            { _<$>_ = λ f ma k → ma (λ a → k (f a))
            }
        ; pure = λ a k → k a
        ; _<*>_ = λ mf mx k → mf (λ f → mx (λ x → k (f x)))
        }
    ; _>>=_ = λ ma f k → ma (λ a → f a k)
    }

  open ComputationValuedFunctionInstances contTMonad public

module IdContTInstance {R : Set} where
  open ContTInstances {R} {Identity} IdentityModule.monad public
