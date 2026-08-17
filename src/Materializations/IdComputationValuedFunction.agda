module Materializations.IdComputationValuedFunction where

open import Utilities.Function

open import Utilities.ComputationValuedFunction

open import Implementations.IdComputation using (Id)

materializeIdComputationValuedFunction :
  {Z Y : Set} →
  computationValuedFunction Id Z Y → function Z Y
materializeIdComputationValuedFunction f = f
