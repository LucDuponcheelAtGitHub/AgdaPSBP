module Specifications.Conditional where

open import Data.Product using (_×_; _,_)

open import Data.Sum using (_⊎_; inj₁; inj₂)

open import Data.Bool using (Bool; true; false)

open import Specifications.Functional
open import Specifications.Sequential
open import Specifications.Creational

open Functional {{...}}
open Sequential {{...}}
open Creational {{...}}

record Conditional (program : Set → Set → Set) : Set1 where
  field
    sum : {Z Y X : Set} → program Z X → program Y X → program (Z ⊎ Y) X

  infixr 6 _|+|_
  _|+|_ : {Z Y X : Set} → program Z X → program Y X → program (Z ⊎ Y) X
  _|+|_ lp rp = sum lp rp

  infix 0 IF_THEN_ELSE_
  IF_THEN_ELSE_ :
    {{_ : Functional program}} 
    {{_ : Sequential program}} 
    {{_ : Creational program}} 
      → {Z X : Set} → program Z Bool → program Z X → program Z X → program Z X
  IF bp THEN tp ELSE fp = 
    (LET bp IN asProgram chooseBranch) >>> (tp |+| fp)
    where
      chooseBranch : {Z : Set} → (Z × Bool) → (Z ⊎ Z)
      chooseBranch (z , true)  = inj₁ z
      chooseBranch (z , false) = inj₂ z

