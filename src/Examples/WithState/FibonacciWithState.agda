module Examples.WithState.FibonacciWithState where

open import Data.Nat using (ℕ; _+_)
open import Data.Unit using (⊤)

open import Specifications.Functional
open import Specifications.Sequential
open import Specifications.Creational
open import Specifications.Conditional
open import Specifications.WithState

open import Examples.Functional.Primitives using (plusOne)
open import Examples.Conditional.Fibonacci using (fibonacci)

open Functional {{...}}
open Sequential {{...}}
open Creational {{...}}
open Conditional {{...}}
open WithState {{...}}

{-# TERMINATING #-}
fibonacciWithState :
  {program : Set → Set → Set}
  {{_ : Functional program}}
  {{_ : Sequential program}}
  {{_ : Creational program}}
  {{_ : Conditional program}}
  {{_ : WithState ℕ program}} → program ⊤ ℕ
fibonacciWithState =
  readState >>> fibonacci >>> modifyStateWith plusOne
