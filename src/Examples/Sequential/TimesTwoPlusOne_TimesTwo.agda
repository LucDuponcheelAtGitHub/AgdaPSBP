module Examples.Sequential.TimesTwoPlusOne_TimesTwo where

open import Data.Nat using (ℕ)
open import Specifications.Functional
open import Specifications.Functorial
open import Specifications.Sequential

open import Examples.Functional.Primitives using (timesTwoFunction; plusOne; timesTwo)

open Functional {{...}}
open Functorial {{...}}
open Sequential {{...}}

timesTwoPlusOne_TimesTwo : 
  {program : Set → Set → Set} 
  {{_ : Functional program}} 
  {{_ : Functorial program}} 
  {{_ : Sequential program}} → program ℕ ℕ
timesTwoPlusOne_TimesTwo = timesTwo >>> plusOne >== timesTwoFunction



