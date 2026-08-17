{-# OPTIONS --guardedness #-}
module Mains.IdStateTComputationValuedFunction.FibonacciWithState where

open import Data.Nat using (ℕ)
open import Data.Nat.Show using (show)
open import Data.Unit using (⊤; tt)
open import Data.Product using (_×_; _,_)
open import IO

open import Utilities.Function
open import Utilities.ComputationValuedFunction using (computationValuedFunction)
open import Examples.WithState.FibonacciWithState using (fibonacciWithState)
open import Implementations.IdComputation using (Id)
open import Implementations.StateTComputationWithState
open import Materializations.IdStateTComputationValuedFunction using (materializeIdStateTComputationValuedFunction)

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
  _ = computationValuedFunctionStateTWithState

materializedFibonacciWithState : ℕ → (ℕ × ℕ)
materializedFibonacciWithState = materializeIdStateTComputationValuedFunction (fibonacciWithState {program = computationValuedFunction (StateT ℕ Id)}) tt

n = 10

main : Main
main = run (
  do 
    let 
      initialState = n
      (result , finalState) = materializedFibonacciWithState initialState
    putStr "fibonacciWithState initial state = "
    putStr (show initialState)
    putStr "\nFibonacci result = "
    putStr (show result)
    putStr "\nFinal state after increment (+1) = "
    putStrLn (show finalState)
  )

