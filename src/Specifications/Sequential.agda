module Specifications.Sequential where

record Sequential (program : Set → Set → Set) : Set1 where
  field
    andThenProgram : {Z Y X : Set} → program Z Y → program Y X → program Z X

  infixl 8 _>>>_
  _>>>_ : {Z Y X : Set} → program Z Y → program Y X → program Z X
  _>>>_ lp rp = andThenProgram lp rp