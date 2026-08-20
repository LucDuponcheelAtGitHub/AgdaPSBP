module Examples.WithPar.FibonacciWithPar where

open import Data.Product using (_×_; _,_)

open import Data.Nat using (ℕ; _+_)

open import Specifications.Functional
open import Specifications.Sequential
open import Specifications.Creational
open import Specifications.Conditional
open import Specifications.WithPar

open import Examples.Functional.Primitives using 
  (duplicate; isZero; isOne; one; minusOne; minusTwo; add)

open Functional {{...}}
open Sequential {{...}}
open Creational {{...}}
open Conditional {{...}}
open WithPar {{...}}

{-# TERMINATING #-}
fibonacciWithPar :
  {program : Set → Set → Set}
  {{_ : Functional program}}
  {{_ : Sequential program}}
  {{_ : Creational program}}
  {{_ : Conditional program}}
  {{_ : WithPar program}} → program ℕ ℕ
fibonacciWithPar =
  IF isZero THEN
    one
  ELSE
    IF isOne THEN
      one
    ELSE
      duplicate >>> 
        (minusOne >>> fibonacciWithPar ||| minusTwo >>> fibonacciWithPar) >>> 
          add
      -- (minusOne |x| minusTwo) >>> (fibonacciWithPar ||| fibonacciWithPar) >>> add
