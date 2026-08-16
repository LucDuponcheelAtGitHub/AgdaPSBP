module Examples.Functorial.PlusOneTimesTwo where

open import Data.Nat using (ℕ)
open import Specifications.Functional
open import Specifications.Functorial

open import Examples.Functional.Primitives using (timesTwoFunction; plusOne; timesTwo)

open Functional {{...}}
open Functorial {{...}}

plusOneTimesTwo : 
  {program : Set → Set → Set} 
  {{_ : Functional program}} 
  {{_ : Functorial program}} → program ℕ ℕ
plusOneTimesTwo = plusOne >== timesTwoFunction



