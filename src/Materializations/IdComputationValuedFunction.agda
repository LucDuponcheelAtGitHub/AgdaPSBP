module Materializations.IdComputationValuedFunction where

open import Effect.Monad.Identity as IdentityModule public
  using (Identity; runIdentity)

open import Utilities.Function

open import Utilities.ComputationValuedFunction

materializeIdComputationValuedFunction :
  {Z Y : Set} →
  computationValuedFunction Identity Z Y → (Z → Y)
materializeIdComputationValuedFunction f z = runIdentity (f z)
