module Materializations.ComputationValuedFunction where

open import Utilities.ComputationValuedFunction

materializeComputationValuedFunction :
  {M : Set → Set} {Z Y : Set} →
  computationValuedFunction M Z Y → computationValuedFunction M Z Y
materializeComputationValuedFunction f = f
