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
open import Implementations.StateT
open import Materializations.IdStateTComputationValuedFunction using (materializeIdStateT)

open import Effect.Monad.State.Transformer as StateTModule public
  using (StateT; mkStateT; runStateT)

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

materializedFibonacciWithStatePair : ⊤ → ℕ → ((ℕ × ℕ) × ℕ)
materializedFibonacciWithStatePair = materializeIdStateT (
  fibonacciWithStatePair {program = computationValuedFunction (StateT ℕ Identity)})

n = 10

main : Main
main = run (
  do 
    let ((fib1 , fib2) , finalState) = materializedFibonacciWithStatePair tt n
    putStr "fibonacciWithStatePair initial state = "
    putStrLn (show n)
    putStr "First fibonacciPair result = "
    putStrLn (show fib1)
    putStr "Second fibonacciPair result = "
    putStrLn (show fib2)
    putStr "Final state after two increments (+2) = "
    putStrLn (show finalState)
  )
