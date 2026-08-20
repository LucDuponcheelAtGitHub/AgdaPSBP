module Specifications.WithState where

open import Data.Unit using (⊤)

open import Data.Product using (_×_; proj₁)

open import Utilities.Function

open import Specifications.Functional
open import Specifications.Sequential
open import Specifications.Creational

open Functional {{...}}
open Sequential {{...}}
open Creational {{...}}

record WithState (S : Set) (program : Set → Set → Set) : Set1 where
  field
    readState  : {Z : Set} → program Z S
    writeState : program S ⊤

  modifyStateWithFunction :
    {{_ : Functional program}} 
    {{_ : Sequential program}} 
    {{_ : Creational program}} →
    {Z : Set} → function S S → program Z Z
  modifyStateWithFunction f =
    LET (readState >>> asProgram f >>> writeState) IN asProgram proj₁

  modifyStateWith :
    {{_ : Functional program}} 
    {{_ : Sequential program}} 
    {{_ : Creational program}} →
    {Z : Set} → program S S → program Z Z
  modifyStateWith p =
    LET (readState >>> p >>> writeState) IN asProgram proj₁
