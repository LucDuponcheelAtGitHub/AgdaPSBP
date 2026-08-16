module Examples.Creational.Self_Add_PlusOne where

open import Data.Nat using (ℕ)
open import Specifications.Functional
open import Specifications.Sequential
open import Specifications.Creational

open import Examples.Functional.Primitives using (plusOne; add)

open Functional {{...}}
open Sequential {{...}}
open Creational {{...}}

self_Add_PlusOne : 
  {program : Set → Set → Set} 
  {{_ : Functional program}} 
  {{_ : Sequential program}} 
  {{_ : Creational program}} → program ℕ ℕ
self_Add_PlusOne = LET plusOne IN add


