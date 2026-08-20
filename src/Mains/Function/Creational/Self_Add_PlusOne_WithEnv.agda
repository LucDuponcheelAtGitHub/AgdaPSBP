{-# OPTIONS --guardedness #-}
module Mains.Function.Creational.Self_Add_PlusOne_WithEnv where

open import Data.Product using (_×_; _,_)

open import Data.Unit using (⊤; tt)

open import Data.Nat using (ℕ)
open import Data.Nat.Show using (show)

open import IO

open import Implementations.Function using
  (functionFunctional; functionSequential; functionCreational)

open import Materializations.Function using (materializeFunction)

open import Examples.Creational.Self_Add_PlusOne_WithEnv 
  using (self_Add_PlusOne_WithEnv)

instance
  _ = functionFunctional

instance
  _ = functionSequential

instance
  _ = functionCreational

materializedSelf_Add_PlusOne_WithEnv : (⊤ × ℕ) → ℕ
materializedSelf_Add_PlusOne_WithEnv = materializeFunction self_Add_PlusOne_WithEnv

n = 10

main : Main
main = run (
  do 
    putStr "self_Add_PlusOne_WithEnv (tt, "
    putStr (show n)
    putStr ") = "
    putStrLn (show (materializedSelf_Add_PlusOne_WithEnv (tt , n)))
    -- let ((((tt , n0) , result1) , result2) , result3) = materializedEnvResultingTimesTwoPlusOne (tt , n)
    -- putStr "result trace: result1 = "
    -- putStr (show result1)
    -- putStr ", result2 = "
    -- putStr (show result2)
    -- putStr ", result3 = "
    -- putStrLn (show result3)
  )
