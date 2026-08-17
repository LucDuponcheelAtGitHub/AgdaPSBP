module Implementations.StateTComputationWithState where

open import Level using (zero)
open import Data.Unit using (⊤; tt)
open import Data.Product using (_×_; _,_)
open import Effect.Monad using (RawMonad)

open import Utilities.Function
open import Utilities.ComputationValuedFunction using (computationValuedFunction)

open import Specifications.Functional
open import Specifications.Functorial
open import Specifications.Sequential
open import Specifications.Creational
open import Specifications.Conditional
open import Specifications.WithState

open import Implementations.ComputationValuedFunction

open import Implementations.IdComputation using (Id; idMonad)

StateT : Set → (Set → Set) → Set → Set
StateT S M Y = S → M (Y × S)

module StateTInstances {S : Set} {M : Set → Set} (monad : RawMonad {zero} {zero} M) where
  open RawMonad monad

  stateTMonad : RawMonad {zero} {zero} (StateT S M)
  stateTMonad = record
    { rawApplicative = record
        { rawFunctor = record
            { _<$>_ = λ f st s → do
                (y , s') ← st s
                return (f y , s')
            }
        ; pure = λ y s → return (y , s)
        ; _<*>_ = λ sf st s → do
            (f , s') ← sf s
            (y , s'') ← st s'
            return (f y , s'')
        }
    ; _>>=_ = λ st f s → do
        (y , s') ← st s
        f y s'
    }

  open ComputationValuedFunctionInstances stateTMonad public

  computationValuedFunctionStateTWithState : WithState S (computationValuedFunction (StateT S M))
  computationValuedFunctionStateTWithState = record
    { readState = λ _ s → return (s , s)
    ; writeState = λ s' _ → return (tt , s')
    }

module IdStateTInstance {S : Set} where
  open StateTInstances {S} {Id} idMonad public
