{-# OPTIONS --guardedness #-}
module Mains.IdContTComputationValuedFunction.FibonacciWithCont where

open import Data.Unit using (⊤)

open import Data.Nat using (ℕ)
open import Data.Nat.Show using (show)

open import IO

open import Effect.Monad.Identity as IdentityModule public using 
  (Identity; mkIdentity; runIdentity)

open import Utilities.Function

open import Utilities.ComputationValuedFunction using (computationValuedFunction)

open import Implementations.ContT using (ContT; module IdContTInstance)

open import Materializations.IdContTComputationValuedFunction using 
  (materializeIdContT)

open import Examples.Conditional.Fibonacci using (fibonacci)

instance
  _ = IdContTInstance.computationValuedFunctionFunctional
instance
  _ = IdContTInstance.computationValuedFunctionFunctorial
instance
  _ = IdContTInstance.computationValuedFunctionSequential
instance
  _ = IdContTInstance.computationValuedFunctionCreational
instance
  _ = IdContTInstance.computationValuedFunctionConditional

materializedFibonacciWithCont : ℕ → (ℕ → Identity ℕ) → Identity ℕ
materializedFibonacciWithCont = 
  materializeIdContT 
    (fibonacci {program = computationValuedFunction (ContT ℕ Identity)})

n = 10

main : Main
main = run (
  do
    putStr "fibonacciWithCont("
    putStr (show n)
    putStr ") = "
    putStrLn (show (runIdentity (materializedFibonacciWithCont n mkIdentity)))
  )