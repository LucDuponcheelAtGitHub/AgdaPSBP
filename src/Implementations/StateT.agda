module Implementations.StateT where

open import Level using (zero)

open import Data.Unit using (tt)

open import Data.Product using (_,_)

open import Effect.Monad using (RawMonad)

open import Effect.Monad.Identity as IdentityModule public
  using (Identity; monad)

open import Effect.Monad.State.Transformer as StateTModule public
  using (StateT; mkStateT)

open import Utilities.ComputationValuedFunction

open import Specifications.Functional
open import Specifications.Functorial
open import Specifications.Sequential
open import Specifications.Creational
open import Specifications.Conditional
open import Specifications.WithState

open import Implementations.ComputationValuedFunction using (module ComputationValuedFunctionInstances)

module StateTInstances {S : Set} {M : Set → Set} (monad : RawMonad {zero} {zero} M) where
  open RawMonad monad

  stateTMonad : RawMonad {zero} {zero} (StateT S M)
  stateTMonad = StateTModule.monad monad

  open ComputationValuedFunctionInstances stateTMonad public

  stateTWithState : WithState S (computationValuedFunction (StateT S M))
  stateTWithState = record
    { readState = λ _ → mkStateT (λ s → RawMonad.pure monad (s , s))
    ; writeState = λ s' → mkStateT (λ s → RawMonad.pure monad (s' , tt))
    }

module IdStateTInstance {S : Set} where
  open StateTInstances {S} {Identity} IdentityModule.monad public

