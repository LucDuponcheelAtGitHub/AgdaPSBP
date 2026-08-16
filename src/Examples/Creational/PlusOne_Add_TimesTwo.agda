module Examples.Creational.PlusOne_Add_TimesTwo where

open import Data.Nat using (ℕ)
open import Data.Product using (_×_)
open import Specifications.Functional
open import Specifications.Functorial
open import Specifications.Creational

open import Examples.Functional.Primitives using (plusOne; timesTwo; addFunction)

open Functional {{...}}
open Functorial {{...}}
open Creational {{...}}

plusOne_Add_TimesTwo : 
  {program : Set → Set → Set} 
  {{_ : Functional program}} 
  {{_ : Functorial program}} 
  {{_ : Creational program}} → program ℕ ℕ
plusOne_Add_TimesTwo = (plusOne |x| timesTwo) >== addFunction