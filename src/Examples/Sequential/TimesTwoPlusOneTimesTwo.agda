module Examples.Sequential.TimesTwoPlusOneTimesTwo where

open import Data.Nat using (ℕ)
open import Specifications.Functional
open import Specifications.Functorial
open import Specifications.Sequential

open import Examples.Functional.Primitives using (timesTwoFunction; plusOne; timesTwo)

open Functional {{...}}
open Functorial {{...}}
open Sequential {{...}}

timesTwoPlusOneTimesTwo : 
  {program : Set → Set → Set} 
  {{_ : Functional program}} 
  {{_ : Functorial program}} 
  {{_ : Sequential program}} → program ℕ ℕ
timesTwoPlusOneTimesTwo = timesTwo >>> plusOne >== timesTwoFunction



