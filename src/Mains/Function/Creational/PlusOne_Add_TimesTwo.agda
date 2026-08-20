{-# OPTIONS --guardedness #-}
module Mains.Function.Creational.PlusOne_Add_TimesTwo where

open import Data.Nat using (ℕ)
open import Data.Nat.Show using (show)

open import IO

open import Implementations.Function using
  (functionFunctional; functionFunctorial; functionCreational)

open import Materializations.Function using (materializeFunction)

open import Examples.Creational.PlusOne_Add_TimesTwo using (plusOne_Add_TimesTwo)

instance
  _ = functionFunctional

instance
  _ = functionFunctorial

instance
  _ = functionCreational

materializedPlusOne_Add_TimesTwo : ℕ → ℕ
materializedPlusOne_Add_TimesTwo = materializeFunction plusOne_Add_TimesTwo

n = 10

main : Main
main = run (
  do 
    putStr "("
    putStr (show n)
    putStr " + 1) + ("
    putStr (show n)
    putStr " * 2) = "
    putStrLn (show (materializedPlusOne_Add_TimesTwo n))
  )