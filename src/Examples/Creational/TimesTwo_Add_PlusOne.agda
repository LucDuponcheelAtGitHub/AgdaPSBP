module Examples.Creational.TimesTwo_Add_PlusOne where

open import Data.Nat using (ℕ)
open import Data.Product using (_×_)

open import Specifications.Functional
open import Specifications.Sequential
open import Specifications.Creational

open import Examples.Functional.Primitives using (plusOne; timesTwo; add)

open Functional {{...}}
open Sequential {{...}}
open Creational {{...}}

timesTwo_Add_PlusOne : 
  {program : Set → Set → Set} 
  {{_ : Functional program}} 
  {{_ : Sequential program}} 
  {{_ : Creational program}} → program ℕ ℕ
timesTwo_Add_PlusOne = (timesTwo |x| plusOne) >>> add