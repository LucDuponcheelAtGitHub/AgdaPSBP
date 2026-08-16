module Examples.Creational.Self_Add_PlusOne_WithEnv where

open import Data.Nat using (ℕ)
open import Data.Unit using (⊤)
open import Data.Product using (_×_)
open import Specifications.Functional
open import Specifications.Sequential
open import Specifications.Creational

open import Examples.Functional.Primitives using (plusOne; add)

open Functional {{...}}
open Sequential {{...}}
open Creational {{...}}

self_Add_PlusOne_WithEnv :
  {program : Set → Set → Set} 
  {{_ : Functional program}} 
  {{_ : Sequential program}} 
  {{_ : Creational program}} → program (⊤ × ℕ) ℕ
self_Add_PlusOne_WithEnv =
  plusOne AT P1 ANDTHEN
  plusOne AT P2 ANDTHEN
  add AT P21 ANDTHEN
  P1