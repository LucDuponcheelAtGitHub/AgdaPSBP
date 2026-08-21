module Materializations.IdContTComputationValuedFunction where

-- open import Data.Unit using (⊤)

open import Effect.Monad.Identity as IdentityModule public using (Identity)

open import Utilities.Function

open import Utilities.ComputationValuedFunction

open import Implementations.ContT using (ContT)

materializeIdContT :
  {R Z Y : Set} →
  computationValuedFunction (ContT R Identity) Z Y → (Z → ((Y → Identity R) → Identity R))
materializeIdContT f = f
