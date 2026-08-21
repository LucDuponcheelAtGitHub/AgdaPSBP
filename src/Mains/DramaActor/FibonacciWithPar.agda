{-# OPTIONS --guardedness #-}
module Mains.DramaActor.FibonacciWithPar where

open import Data.Nat using (ℕ)
open import Data.Nat.Show using (show)

open import Data.Unit using (⊤; tt)

open import Agda.Builtin.IO using () renaming (IO to AgdaIO)

open import IO

open import Utilities.Function

open import Utilities.ComputationValuedFunction using (computationValuedFunction)

open import Implementations.ContT using (ContT)

open import Implementations.DramaActorContT using (DramaActor; module DramaActorInstance)

open import Materializations.DramaActorContTComputationValuedFunction using 
  (materializeDramaActorContT)

open import Examples.WithPar.FibonacciWithPar using (fibonacciWithPar)

open import Agda.Builtin.IO using () renaming (IO to AgdaIO)

postulate
  DramaMessage : Set → Set → Set

  printFibResult : ℕ → ℕ → DramaActor (DramaMessage ℕ ℕ) ⊤

  runDramaActor : {msg : Set} → DramaActor msg ⊤ → AgdaIO ⊤

{-# FOREIGN GHC import qualified Haskell.DramaActor as Drama #-}
{-# FOREIGN GHC import qualified Drama as D #-}
{-# FOREIGN GHC import Control.Monad.IO.Class (liftIO) #-}

{-# COMPILE GHC DramaMessage = type Drama.Message #-}
{-# COMPILE GHC printFibResult = 
  \ n res -> liftIO (putStrLn 
    ("Parallel Fibonacci via Drama Actors: fibonacci(" ++ show n ++ ") = " ++ show res)) #-}
{-# COMPILE GHC runDramaActor = \ _ -> D.runActor #-}

open DramaActorInstance {DramaMessage ℕ ℕ}

instance
  _ = computationValuedFunctionFunctional
instance
  _ = computationValuedFunctionFunctorial
instance
  _ = computationValuedFunctionSequential
instance
  _ = computationValuedFunctionCreational
instance
  _ = computationValuedFunctionConditional
instance
  _ = dramaActorWithPar

materializedFibonacciWithPar : 
  ℕ → (ℕ → DramaActor (DramaMessage ℕ ℕ) ⊤) → DramaActor (DramaMessage ℕ ℕ) ⊤
materializedFibonacciWithPar = 
  materializeDramaActorContT 
  (fibonacciWithPar 
    {program = computationValuedFunction (ContT ⊤ (DramaActor (DramaMessage ℕ ℕ)))})

n = 10

main : Main
main = run (
  do
    lift′ (runDramaActor (materializedFibonacciWithPar n (λ res → printFibResult n res)))
  )
