module Materializations.IdStateTComputationValuedFunction where

open import Data.Product using (_×_; _,_)

open import Utilities.Function

open import Utilities.ComputationValuedFunction

open import Implementations.IdComputation using (Id)

open import Implementations.StateTComputationWithState using (StateT)

materializeIdStateTComputationValuedFunction :
  {S Z Y : Set} →
  computationValuedFunction (StateT S Id) Z Y → function Z (function S (Y × S))
materializeIdStateTComputationValuedFunction f = f
