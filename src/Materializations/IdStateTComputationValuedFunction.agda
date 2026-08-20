module Materializations.IdStateTComputationValuedFunction where

open import Data.Product using (_×_; _,_)

open import Effect.Monad.Identity as IdentityModule public
  using (Identity; runIdentity)

open import Effect.Monad.State.Transformer as StateTModule public
  using (StateT; runStateT)

open import Utilities.Function

open import Utilities.ComputationValuedFunction

materializeIdStateTComputationValuedFunction :
  {S Z Y : Set} →
  computationValuedFunction (StateT S Identity) Z Y → function Z (function S (Y × S))
materializeIdStateTComputationValuedFunction f z s =
  let (s' , y) = runIdentity (runStateT (f z) s)
  in (y , s')
