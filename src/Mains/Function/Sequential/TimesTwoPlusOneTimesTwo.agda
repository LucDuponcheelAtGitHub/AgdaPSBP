{-# OPTIONS --guardedness #-}
module Mains.Function.Sequential.TimesTwoPlusOneTimesTwo where

open import Data.Nat using (ℕ)
open import Data.Nat.Show using (show)

open import IO

open import Implementations.Function using
  (functionFunctional; functionFunctorial; functionSequential)

open import Materializations.Function using (materializeFunction)

open import Examples.Sequential.TimesTwoPlusOneTimesTwo using (timesTwoPlusOneTimesTwo)

instance
  _ = functionFunctional

instance
  _ = functionFunctorial

instance
  _ = functionSequential

materializedTimesTwoPlusOneTimesTwo : ℕ → ℕ
materializedTimesTwoPlusOneTimesTwo = materializeFunction timesTwoPlusOneTimesTwo

n = 10

main : Main
main = run (
  do 
    putStr "(2 * "
    putStr (show n)
    putStr " + 1) * 2 = "
    putStrLn (show (materializedTimesTwoPlusOneTimesTwo 41))
  )