{-# OPTIONS --guardedness #-}
module Mains.StateFunction.TestWithState where

open import Level using (zero)
open import Data.Nat using (ℕ; _+_; _*_)
open import Data.Nat.Show using (show)
open import Data.Unit using (⊤; tt)
open import Data.Product using (_×_; _,_)
open import IO
open import Effect.Monad using (RawMonad)
open import Effect.Applicative using (RawApplicative)

open import Utilities.Function
open import Specifications.Functional
open import Specifications.Sequential
open import Specifications.Creational
open import Specifications.Conditional
open import Specifications.WithState

open import Implementations.ComputationValuedFunction
open import Implementations.StateFunction
open import Materializations.ComputationValuedFunction

open Functional {{...}}
open Sequential {{...}}
open Creational {{...}}
open Conditional {{...}}

Id : Set → Set
Id A = A

idApplicative : RawApplicative {zero} {zero} Id
idApplicative = record
  { rawFunctor = record { _<$>_ = λ f x → f x }
  ; pure = λ x → x
  ; _<*>_ = λ f x → f x
  }

idMonad : RawMonad {zero} {zero} Id
idMonad = record
  { rawApplicative = idApplicative
  ; _>>=_ = λ x f → f x
  }

open StateTInstances {ℕ} idMonad

instance
  _ = computationValuedFunctionFunctional
instance
  _ = computationValuedFunctionSequential
instance
  _ = computationValuedFunctionCreational
instance
  _ = computationValuedFunctionConditional

open WithState stateTWithState

plus10State : {Z : Set} → computationValuedFunction (StateT ℕ Id) Z Z
plus10State = modifyStateWithFunction (λ s → s + 10)

readAndDoubleState : {Z : Set} → computationValuedFunction (StateT ℕ Id) Z ℕ
readAndDoubleState = usingInitialStateAsInitialValue (asProgram (λ s → s * 2))

testProgram : {Z : Set} → computationValuedFunction (StateT ℕ Id) Z ℕ
testProgram = plus10State >>> readAndDoubleState

materializedTestProgram : computationValuedFunction (StateT ℕ Id) (⊤ × ℕ) ℕ
materializedTestProgram = materializeComputationValuedFunction {M = StateT ℕ Id} testProgram

n = 5

main : Main
main = run (
  do
    let (res , finalState) = materializedTestProgram (tt , n) n
    putStr "Initial state = "
    putStr (show n)
    putStr "\nAfter modifyStateWithFunction (+10), final state = "
    putStr (show finalState)
    putStr "\nValue produced by readState (state * 2) = "
    putStrLn (show res)
  )
