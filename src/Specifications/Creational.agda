module Specifications.Creational where

open import Data.Product using (_×_; _,_)

open import Specifications.Functional
open import Specifications.Sequential

open Functional {{...}}
open Sequential {{...}}

record Creational (program : Set → Set → Set) : Set1 where
  field
    sequentialProduct : {Z Y X : Set} → program Z Y → program Z X → program Z (Y × X)

  infixr 7 _|x|_
  _|x|_ : {Z Y X : Set} → program Z Y → program Z X → program Z (Y × X)
  _|x|_ lp rp = sequentialProduct lp rp

  infix 0 LET_IN_
  LET_IN_ :
    {{_ : Functional program}} 
    {{_ : Sequential program}} 
      → {Z Y X : Set} → program Z Y → program (Z × Y) X → program Z X
  LET lp IN ip = (identity |x| lp) >>> ip

  infixr 10 _AT_ANDTHEN_
  _AT_ANDTHEN_ :
    {{_ : Functional program}} 
    {{_ : Sequential program}} 
      → {E Z Y X : Set} → program Z Y → program E Z → program (E × Y) X → program E X  
  p AT e ANDTHEN e×y = LET e >>> p IN e×y
  
P1 :
  {program : Set → Set → Set} 
  {{_ : Functional program}} 
    → {E Z : Set} → program (E × Z) Z
P1 = asProgram (λ (_ , z) → z)

P2 :
  {program : Set → Set → Set} 
  {{_ : Functional program}} 
    → {E Z Y : Set} → program ((E × Z) × Y) Z
P2 = asProgram (λ ((_ , z) , _) → z)

P21 :
  {program : Set → Set → Set} 
  {{_ : Functional program}} 
    → {E Z Y : Set} → program ((E × Z) × Y) (Z × Y)
P21 = asProgram (λ ((_ , z) , y) → (z , y))
