{-# OPTIONS --guardedness #-}
module Mains.Function.Functorial.PlusOneTimesTwo where

open import Data.Nat using (ℕ)
open import Data.Nat.Show using (show)
open import IO

open import Examples.Functorial.PlusOneTimesTwo using (plusOneTimesTwo)
open import Implementations.Function using 
  (functionFunctional; functionFunctorial)

open import Materializations.Function using (materializeFunction)

instance
  _ = functionFunctional

instance
  _ = functionFunctorial

materializedPlusOneTimesTwo : ℕ → ℕ
materializedPlusOneTimesTwo = materializeFunction plusOneTimesTwo

n = 10

main : Main
main = run (
  do 
    putStr "("
    putStr (show n)
    putStr " + 1) * 2 = "
    putStrLn (show (materializedPlusOneTimesTwo n))
  )