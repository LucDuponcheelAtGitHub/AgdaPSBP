{-# OPTIONS --guardedness #-}
module Mains.Function.Sequential.TimesTwoPlusOne_TimesTwo where

open import Data.Nat using (ℕ)
open import Data.Nat.Show using (show)

open import IO

open import Implementations.Function using
  (functionFunctional; functionFunctorial; functionSequential)

open import Materializations.Function using (materializeFunction)

open import Examples.Sequential.TimesTwoPlusOne_TimesTwo using (timesTwoPlusOne_TimesTwo)

instance
  _ = functionFunctional

instance
  _ = functionFunctorial

instance
  _ = functionSequential

materializedTimesTwoPlusOne_TimesTwo : ℕ → ℕ
materializedTimesTwoPlusOne_TimesTwo = materializeFunction timesTwoPlusOne_TimesTwo

n = 10

main : Main
main = run (
  do 
    putStr "(2 * "
    putStr (show n)
    putStr " + 1) * 2 = "
    putStrLn (show (materializedTimesTwoPlusOne_TimesTwo 41))
  )