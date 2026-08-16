{-# OPTIONS --guardedness #-}
module Mains.Function.Conditional.Factorial where

open import Data.Nat using (ℕ)
open import Data.Nat.Show using (show)
open import IO

open import Examples.Conditional.Factorial using (factorial)
open import Implementations.Function using
  (functionFunctional; functionFunctorial; functionSequential; functionCreational; functionConditional)
open import Materializations.Function using (materializeFunction)

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

materializedFactorial : ℕ → ℕ
materializedFactorial = materializeFunction factorial

n = 10

main : Main
main = run (
  do 
    putStr "factorial("
    putStr (show n)
    putStr ") = "
    putStrLn (show (materializedFactorial n))
  )
