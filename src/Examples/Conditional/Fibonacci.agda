module Examples.Conditional.Fibonacci where

open import Data.Product using (_×_)

open import Data.Nat using (ℕ)

open import Specifications.Functional
open import Specifications.Sequential
open import Specifications.Creational
open import Specifications.Conditional

open import Examples.Functional.Primitives using (isZero; isOne; minusOne; minusTwo; one; add)

open Functional {{...}}
open Sequential {{...}}
open Creational {{...}}
open Conditional {{...}}

{-# TERMINATING #-}
fibonacci : 
  {program : Set → Set → Set} 
  {{_ : Functional program}} 
  {{_ : Sequential program}} 
  {{_ : Creational program}} 
  {{_ : Conditional program}} → program ℕ ℕ
fibonacci =  
  IF isZero 
    THEN 
      one 
    ELSE
      IF isOne 
        THEN 
          one 
        ELSE 
          (minusOne >>> fibonacci |x| minusTwo >>> fibonacci) >>> add
  
