{-# OPTIONS --guardedness #-}
module Mains.Function.Creational.TimesTwo_Add_PlusOne where

open import Data.Nat using (ℕ)
open import Data.Nat.Show using (show)
open import IO

open import Examples.Creational.TimesTwo_Add_PlusOne using (timesTwo_Add_PlusOne)
open import Implementations.Function using
  (functionFunctional; functionSequential; functionCreational)
open import Materializations.Function using (materializeFunction)

instance
  _ = functionFunctional

instance
  _ = functionSequential

instance
  _ = functionCreational

materializedTimesTwo_Add_PlusOne : ℕ → ℕ
materializedTimesTwo_Add_PlusOne = materializeFunction timesTwo_Add_PlusOne

n = 10

main : Main
main = run (
  do 
    putStr "("
    putStr (show n)
    putStr " * 2) + ("
    putStr (show n)
    putStr " + 1) = "
    putStrLn (show (materializedTimesTwo_Add_PlusOne n))
  )