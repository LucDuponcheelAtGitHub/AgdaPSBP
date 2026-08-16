module Examples.Conditional.Factorial where

open import Data.Nat using (ℕ)
open import Data.Product using (_×_)
open import Specifications.Functional
open import Specifications.Sequential
open import Specifications.Creational
open import Specifications.Conditional

open import Examples.Functional.Primitives using (isZero; minusOne; one; times)

open Functional {{...}}
open Sequential {{...}}
open Creational {{...}}
open Conditional {{...}}

{-# TERMINATING #-}
factorial : 
  {program : Set → Set → Set} 
  {{_ : Functional program}} 
  {{_ : Sequential program}} 
  {{_ : Creational program}} 
  {{_ : Conditional program}} → program ℕ ℕ
factorial = 
  IF isZero 
    THEN 
      one 
    ELSE 
      LET 
        minusOne >>> factorial 
      IN 
        times
