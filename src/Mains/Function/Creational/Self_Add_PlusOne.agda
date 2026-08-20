{-# OPTIONS --guardedness #-}
module Mains.Function.Creational.Self_Add_PlusOne where

open import Data.Nat using (ℕ)
open import Data.Nat.Show using (show)

open import IO

open import Implementations.Function using
  (functionFunctional; functionSequential; functionCreational)

open import Materializations.Function using (materializeFunction)

open import Examples.Creational.Self_Add_PlusOne using (self_Add_PlusOne)

instance
  _ = functionFunctional

instance
  _ = functionSequential

instance
  _ = functionCreational

materializedSelf_Add_PlusOne : ℕ → ℕ
materializedSelf_Add_PlusOne = materializeFunction self_Add_PlusOne

n = 10

main : Main
main = run (
  do 
    putStr (show n)
    putStr " + ("
    putStr (show n)
    putStr " + 1) = "
    putStrLn (show (materializedSelf_Add_PlusOne n))
  )
