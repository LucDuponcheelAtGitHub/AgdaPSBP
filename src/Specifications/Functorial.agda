module Specifications.Functorial where

open import Utilities.Function

record Functorial (program : Set → Set → Set) : Set1 where
  field
    functionAction : {Z Y X : Set} → function Y X → program Z Y → program Z X

  infixl 8 _>==_
  _>==_ : {Z Y X : Set} → program Z Y → function Y X → program Z X
  _>==_ p f = functionAction f p
