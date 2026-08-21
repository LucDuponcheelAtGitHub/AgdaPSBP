module Implementations.DramaActorContT where

open import Level using (zero)
open import Data.Unit using (⊤; tt)
open import Data.Product using (_×_; _,_)
open import Effect.Monad using (RawMonad)

open import Utilities.Function
open import Utilities.ComputationValuedFunction
open import Specifications.Functional
open import Specifications.Functorial
open import Specifications.Sequential
open import Specifications.Creational
open import Specifications.Conditional
open import Specifications.WithPar

open import Implementations.ContT

data Pair (A B : Set) : Set where
  pair : A → B → Pair A B

{-# COMPILE GHC Pair = data (,) ((,)) #-}

postulate
  DramaActor : Set → Set → Set

  dramaActorMonad : {msg : Set} → RawMonad {zero} {zero} (DramaActor msg)

  dramaActorPar : 
    {msg Z Y X W : Set} →
      computationValuedFunction (ContT ⊤ (DramaActor msg)) Z X →
      computationValuedFunction (ContT ⊤ (DramaActor msg)) Y W →
      Pair Z Y → ContT ⊤ (DramaActor msg) (Pair X W)

{-# FOREIGN GHC import qualified Haskell.DramaActor as Drama #-}
{-# FOREIGN GHC import qualified Drama as D #-}
{-# FOREIGN GHC import Control.Monad.Trans.Cont (ContT(..)) #-}
{-# FOREIGN GHC import Unsafe.Coerce (unsafeCoerce) #-}

{-# COMPILE GHC DramaActor = type D.Actor #-}
{-# COMPILE GHC 
  dramaActorPar = \ _ _ _ _ _ z2x y2w -> 
    unsafeCoerce (Drama.parDrama (unsafeCoerce z2x) (unsafeCoerce y2w)) #-}

module DramaActorInstance {msg : Set} where
  open ContTInstances {R = ⊤} (dramaActorMonad {msg}) public

  dramaActorWithPar : WithPar (computationValuedFunction (ContT ⊤ (DramaActor msg)))
  dramaActorWithPar = record
    { par = 
        λ {Z} {Y} {X} {W} f g (z , y) k → 
          dramaActorPar f g (pair z y) (λ { (pair x w) → k (x , w) })
    }
