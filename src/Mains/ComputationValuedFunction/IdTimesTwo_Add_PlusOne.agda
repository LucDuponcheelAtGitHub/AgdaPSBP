{-# OPTIONS --guardedness #-}
module Mains.ComputationValuedFunction.IdTimesTwo_Add_PlusOne where

open import Data.Nat using (ℕ)
open import Data.Nat.Show using (show)
open import IO

open import Utilities.ComputationValuedFunction

open import Implementations.ComputationValuedFunction
open import Implementations.IdComputation using (Id; idMonad)

open ComputationValuedFunctionInstances idMonad

open import Materializations.IdComputationValuedFunction

open import Examples.Creational.TimesTwo_Add_PlusOne using (timesTwo_Add_PlusOne)

instance
  _ = computationValuedFunctionFunctional
instance
  _ = computationValuedFunctionFunctorial
instance
  _ = computationValuedFunctionSequential
instance
  _ = computationValuedFunctionCreational

materializedIdTimesTwoAddPlusOne : ℕ → ℕ
materializedIdTimesTwoAddPlusOne = 
  materializeIdComputationValuedFunction 
    (timesTwo_Add_PlusOne {program = computationValuedFunction Id})

n = 10

main : Main
main = run (
  do
    putStrLn "Id computation-valued timesTwo_Add_PlusOne"
    putStr "("
    putStr (show n)
    putStr " * 2) + ("
    putStr (show n)
    putStr " + 1) = "
    putStrLn (show (materializedIdTimesTwoAddPlusOne n))
  )