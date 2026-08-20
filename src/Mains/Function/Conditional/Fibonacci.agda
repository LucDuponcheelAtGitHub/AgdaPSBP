{-# OPTIONS --guardedness #-}
module Mains.Function.Conditional.Fibonacci where

open import Data.Nat using (ℕ)
open import Data.Nat.Show using (show)

open import IO

open import Implementations.Function using
  (functionFunctional; 
  functionFunctorial;
  functionSequential;
  functionCreational;
  functionConditional)

open import Materializations.Function using (materializeFunction)

open import Examples.Conditional.Fibonacci using (fibonacci)

instance
  _ = functionFunctional

instance
  _ = functionFunctorial

instance
  _ = functionSequential

instance
  _ = functionCreational

instance
  _ = functionConditional

materializedFibonacci : ℕ → ℕ
materializedFibonacci = materializeFunction fibonacci

n = 10

main : Main
main = run (
  do 
    putStr "fibonacci("
    putStr (show n)
    putStr ") = "
    putStrLn (show (materializedFibonacci n))
  )
