module Specifications.WithPar where

open import Data.Product using (_×_)

record WithPar (program : Set → Set → Set) : Set1 where
  field
    par : {Z Y X W : Set} → program Z X → program Y W → program (Z × Y) (X × W)

infixr 7 _|||_
_|||_ : {program : Set → Set → Set} {{_ : WithPar program}} →
        {Z Y X W : Set} → program Z X → program Y W → program (Z × Y) (X × W)
_|||_ {{p}} = WithPar.par p
