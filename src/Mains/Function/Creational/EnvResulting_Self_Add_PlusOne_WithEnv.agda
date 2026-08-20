{-# OPTIONS --guardedness #-}
module Mains.Function.Creational.EnvResulting_Self_Add_PlusOne_WithEnv where

open import Data.Unit using (⊤; tt)

open import Data.Product using (_×_; _,_)

open import IO

open import Data.Nat using (ℕ)
open import Data.Nat.Show using (show)

open import Implementations.Function using
  (functionFunctional; functionSequential; functionCreational)

open import Materializations.Function using (materializeFunction)

open import Examples.Creational.EnvResulting_Self_Add_PlusOne_WithEnv using 
  (envResulting_Self_Add_PlusOne_WithEnv)

instance
  _ = functionFunctional

instance
  _ = functionSequential

instance
  _ = functionCreational

materializedEnvResulting_Self_Add_PlusOne_WithEnv : 
  (⊤ × ℕ) → ((((⊤ × ℕ) × ℕ) × ℕ) × ℕ)
materializedEnvResulting_Self_Add_PlusOne_WithEnv = 
  materializeFunction envResulting_Self_Add_PlusOne_WithEnv

n = 10

main : Main
main = run (
  do 
    let
      ((((tt , argument) , result1) , result2) , result3) = 
        materializedEnvResulting_Self_Add_PlusOne_WithEnv (tt , n)
    putStrLn "result trace"
    putStr "argument = "
    putStrLn (show argument)
    putStr "intermediate result1 = "
    putStrLn (show result1)
    putStr "intermediate result2 = "
    putStrLn (show result2)
    putStr "final result3 = "
    putStrLn (show result3)
  )
