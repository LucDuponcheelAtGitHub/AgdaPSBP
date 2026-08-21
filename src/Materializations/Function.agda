module Materializations.Function where

open import Utilities.Function

materializeFunction : {Z Y : Set} → function Z Y → (Z → Y)
materializeFunction = λ f → f
