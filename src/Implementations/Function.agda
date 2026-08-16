module Implementations.Function where

open import Function using (_∘_)
open import Data.Product using (_,_)
open import Data.Sum using (_⊎_; inj₁; inj₂)

open import Utilities.Function

open import Specifications.Functional
open import Specifications.Functorial
open import Specifications.Sequential
open import Specifications.Creational
open import Specifications.Conditional

functionFunctional : Functional function
functionFunctional = record { asProgram = λ f → f }

functionFunctorial : Functorial function
functionFunctorial = record { functionAction = λ f g → f ∘ g }

functionSequential : Sequential function
functionSequential = record { andThenProgram = λ f g → g ∘ f }

functionCreational : Creational function
functionCreational = record { sequentialProduct = λ f g z → (f z , g z) }

functionConditional : Conditional function
functionConditional = record { sum = λ { f g (inj₁ z) → f z ; f g (inj₂ y) → g y } }

