module Materializations.DramaActorContTComputationValuedFunction where

open import Data.Unit using (⊤)

open import Utilities.Function

open import Utilities.ComputationValuedFunction

open import Implementations.ContT using (ContT)

open import Implementations.DramaActorContT using (DramaActor)

materializeDramaActorContT :
  {msg Z Y : Set} →
  computationValuedFunction (ContT ⊤ (DramaActor msg)) Z Y → 
    Z → ((Y → DramaActor msg ⊤) → DramaActor msg ⊤)
materializeDramaActorContT f z k = f z k
