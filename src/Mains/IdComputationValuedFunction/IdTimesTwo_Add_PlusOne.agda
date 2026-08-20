{-# OPTIONS --guardedness #-}
module Mains.IdComputationValuedFunction.IdTimesTwo_Add_PlusOne where

open import Data.Nat using (ℕ)
open import Data.Nat.Show using (show)
open import IO

open import Effect.Monad.Identity using (Identity)

open import Effect.Monad.Identity as IdentityModule public
  using (Identity; mkIdentity; runIdentity; monad)

open import Utilities.ComputationValuedFunction

open import Implementations.ComputationValuedFunction

open ComputationValuedFunctionInstances monad

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
    (timesTwo_Add_PlusOne {program = computationValuedFunction Identity})

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
