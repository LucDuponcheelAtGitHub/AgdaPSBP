{-# OPTIONS --guardedness #-}
module Mains.IdStateTComputationValuedFunction.FibonacciWithState where

open import Data.Unit using (⊤; tt)

open import Data.Product using (_×_; _,_)

open import Data.Nat using (ℕ)
open import Data.Nat.Show using (show)

open import IO

open import Utilities.ComputationValuedFunction using (computationValuedFunction)

open import Examples.WithState.FibonacciWithState using (fibonacciWithState)

open import Implementations.StateT

open import Materializations.IdStateTComputationValuedFunction using (materializeIdStateT)

open import Examples.WithState.FibonacciWithState using (fibonacciWithState)

open IdStateTInstance {ℕ}

instance
  _ = computationValuedFunctionFunctional
instance
  _ = computationValuedFunctionSequential
instance
  _ = computationValuedFunctionCreational
instance
  _ = computationValuedFunctionConditional
instance
  _ = stateTWithState

materializedFibonacciWithState : ⊤ → ℕ → (ℕ × ℕ)
materializedFibonacciWithState = 
  materializeIdStateT 
    (fibonacciWithState {program = computationValuedFunction (StateT ℕ Identity)})

n = 10

main : Main
main = run (
  do 
    let (res , finalState) = materializedFibonacciWithState tt n
    putStr "fibonacciWithState initial state = "
    putStr (show n)
    putStr "\nFibonacci result = "
    putStr (show res)
    putStr "\nFinal state after increment (+1) = "
    putStrLn (show finalState)
  )
