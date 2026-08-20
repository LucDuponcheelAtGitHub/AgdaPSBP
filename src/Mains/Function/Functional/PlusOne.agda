{-# OPTIONS --guardedness #-}
module Mains.Function.Functional.PlusOne where

open import Data.Nat using (ℕ)
open import Data.Nat.Show using (show)

open import IO

open import Implementations.Function using (functionFunctional)

open import Materializations.Function using (materializeFunction)

open import Examples.Functional.Primitives using (plusOne)

instance
  _ = functionFunctional

materializedPlusOne : ℕ → ℕ
materializedPlusOne = materializeFunction plusOne

n = 10

main : Main
main = run (
  do 
    putStr (show n)
    putStr " + 1 = "
    putStrLn (show (materializedPlusOne n))
  )