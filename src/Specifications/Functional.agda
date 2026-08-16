module Specifications.Functional where

open import Utilities.Function

record Functional (program : Set → Set → Set) : Set1 where
  field
    asProgram : {Z Y : Set} → function Z Y → program Z Y

  identity : {Z : Set} → program Z Z
  identity = asProgram (λ z → z)
