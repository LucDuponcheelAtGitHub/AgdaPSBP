module Examples.Functional.Primitives where

open import Data.Product using (_×_; _,_)

open import Data.Nat using (ℕ; _+_; _*_; pred; suc)
open import Data.Bool using (Bool; true; false)

open import Utilities.Function using (function)

open import Specifications.Functional

open Functional {{...}}

duplicateFunction : {Z : Set} → function Z (Z × Z)
duplicateFunction = λ z → (z , z)

plusOneFunction : function ℕ ℕ
plusOneFunction = λ n → n + 1

timesTwoFunction : function ℕ ℕ
timesTwoFunction = λ n → n * 2

isZeroFunction : function ℕ Bool
isZeroFunction 0       = true
isZeroFunction (suc _) = false

isOneFunction : function ℕ Bool
isOneFunction 0       = false
isOneFunction (suc 0) = true
isOneFunction (suc _) = false

minusOneFunction : function ℕ ℕ
minusOneFunction = λ n → pred n

minusTwoFunction : function ℕ ℕ
minusTwoFunction = λ n → pred (pred n)

oneFunction : {Z : Set} → function Z ℕ
oneFunction = λ _ → 1

addFunction : function (ℕ × ℕ) ℕ
addFunction (ln , rn) = ln + rn

timesFunction : function (ℕ × ℕ) ℕ
timesFunction (ln , rn) = ln * rn

duplicate :
   {program : Set → Set → Set}
   {{_ : Functional program}} → {Z : Set} → program  Z (Z × Z)
duplicate = asProgram duplicateFunction 

plusOne : 
  {program : Set → Set → Set}
  {{_ : Functional program}} → program ℕ ℕ
plusOne = asProgram plusOneFunction

timesTwo : 
  {program : Set → Set → Set} 
  {{_ : Functional program}} → program ℕ ℕ
timesTwo = asProgram timesTwoFunction

isZero : 
  {program : Set → Set → Set}
  {{_ : Functional program}} → program ℕ Bool
isZero = asProgram isZeroFunction

isOne : 
  {program : Set → Set → Set}
  {{_ : Functional program}} → program ℕ Bool
isOne = asProgram isOneFunction

minusOne : 
  {program : Set → Set → Set}
  {{_ : Functional program}} → program ℕ ℕ
minusOne = asProgram minusOneFunction

minusTwo : 
  {program : Set → Set → Set}
  {{_ : Functional program}} → program ℕ ℕ
minusTwo = asProgram minusTwoFunction

one :
  {Z : Set}
  {program : Set → Set → Set}
  {{_ : Functional program}} → program Z ℕ
one = asProgram oneFunction

add :
  {program : Set → Set → Set} 
  {{_ : Functional program}} → program (ℕ × ℕ) ℕ
add = asProgram addFunction

times :
  {program : Set → Set → Set} 
  {{_ : Functional program}} → program (ℕ × ℕ) ℕ
times = asProgram timesFunction

