module Materializations.DramaActorComputationValuedFunction where

open import Data.Unit using (⊤)
open import Utilities.Function
open import Utilities.ComputationValuedFunction
open import Implementations.ContT using (ContT)
open import Implementations.DramaActor using (DramaActor)

materializeDramaActorComputationValuedFunction :
  {msg Z Y : Set} →
  computationValuedFunction (ContT ⊤ (DramaActor msg)) Z Y → 
    function Z ((Y → DramaActor msg ⊤) → DramaActor msg ⊤)
materializeDramaActorComputationValuedFunction f z k = f z k
