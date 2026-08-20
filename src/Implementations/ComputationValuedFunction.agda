module Implementations.ComputationValuedFunction where

open import Level using (zero)

open import Data.Product using (_,_)

open import Data.Sum using (inj₁; inj₂)

open import Effect.Monad using (RawMonad)

open import Utilities.ComputationValuedFunction

open import Specifications.Functional
open import Specifications.Functorial
open import Specifications.Sequential
open import Specifications.Creational
open import Specifications.Conditional

module ComputationValuedFunctionInstances {M : Set → Set} (monad : RawMonad {zero} {zero} M) where
  open RawMonad monad

  computationValuedFunctionFunctional : Functional (computationValuedFunction M)
  computationValuedFunctionFunctional = record
    { asProgram = λ f z → return (f z)
    }

  computationValuedFunctionFunctorial : Functorial (computationValuedFunction M)
  computationValuedFunctionFunctorial = record
    { functionAction = λ g f z → do
        y ← f z
        return (g y)
    }

  computationValuedFunctionSequential : Sequential (computationValuedFunction M)
  computationValuedFunctionSequential = record
    { andThenProgram = λ f g z → do
        y ← f z
        g y
    }

  computationValuedFunctionCreational : Creational (computationValuedFunction M)
  computationValuedFunctionCreational = record
    { sequentialProduct = λ f g z → do
        y ← f z
        x ← g z
        return (y , x)
    }

  computationValuedFunctionConditional : Conditional (computationValuedFunction M)
  computationValuedFunctionConditional = record
    { sum = λ { f g (inj₁ z) → f z ; f g (inj₂ y) → g y }
    }

