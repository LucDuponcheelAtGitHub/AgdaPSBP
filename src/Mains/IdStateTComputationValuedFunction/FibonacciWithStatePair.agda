{-# OPTIONS --guardedness #-}
module Mains.IdStateTComputationValuedFunction.FibonacciWithStatePair where

open import Data.Nat using (ℕ; _+_)
open import Data.Nat.Show using (show)
open import Data.Unit using (⊤; tt)
open import Data.Product using (_×_; _,_)
open import IO

open import Utilities.Function
open import Utilities.ComputationValuedFunction using (computationValuedFunction)
open import Examples.WithState.FibonacciWithStatePair using (fibonacciWithStatePair)
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

materializedFibonacciWithStatePair : ℕ → ((ℕ × ℕ) × ℕ)
materializedFibonacciWithStatePair = 
  materializeIdStateTComputationValuedFunction 
    (fibonacciWithStatePair {program = computationValuedFunction (StateT ℕ Id)}) tt

n = 10

main : Main
main = run (
  do 
    let
      initialState = n 
      ((result1 , result2) , finalState) = materializedFibonacciWithStatePair n
    putStr "fibonacciWithStatePair initial state = "
    putStrLn (show initialState)
    putStr "First fibonacciPair result = "
    putStr (show result1)
    putStr "\nSecond fibonacciPair result = "
    putStr (show result2)
    putStr "\nFinal state after two increments (+2) = "
    putStrLn (show finalState)
  )

