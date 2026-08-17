module Examples.WithState.FibonacciWithStatePair where

open import Data.Nat using (ℕ)
open import Data.Unit using (⊤)
open import Data.Product using (_×_)

open import Specifications.Functional
open import Specifications.Sequential
open import Specifications.Creational
open import Specifications.Conditional
open import Specifications.WithState

open import Examples.WithState.FibonacciWithState using (fibonacciWithState)

open Functional {{...}}
open Sequential {{...}}
open Creational {{...}}
open Conditional {{...}}
open WithState {{...}}

-- It illustrates that statefulness is an algebraic property of computation flow,
-- not a requirement for physical memory side-effects! 

{-# TERMINATING #-}
fibonacciWithStatePair :
  {program : Set → Set → Set}
  {{_ : Functional program}}
  {{_ : Sequential program}}
  {{_ : Creational program}}
  {{_ : Conditional program}}
  {{_ : WithState ℕ program}} → program ⊤ (ℕ × ℕ)
fibonacciWithStatePair = fibonacciWithState |x| fibonacciWithState
