# Documentation

```agda
{-# OPTIONS --guardedness #-}

module Documentation where
```

The goal of this project is to write a pointfree programming DSL, called `PSBP` in `Agda`.

DSL stands for Domain Specific Language.

`PSBP` stands for Program Specification Based Programming.

This documentation is not an `Agda` course.

This documentation is a, somewhat opinionated, programming course.

Using this DSL you can write programs (in fact they are program specifications) that are closed
software components that can be compared with hardware components that can be used without opening
them.

We stricly distinguish the word 'program', belonging to the DSL. from the word 'code' belonging to
the `Agda` encoding of the DSL.

You can argue that this goal has already be achieved,
see [Backus FP](https://en.wikipedia.org/wiki/FP_(programming_language)), but `FP` only deals with
pure functions in a pointfree way.

Moreover `FP` is an implementation level programming language. `PSBP` is a specification level
programming library providing more flexibility.

This documentation has examples that are compilable/runnable code.

*Please go to the very end of this file to comment out the example that you want to compile/run.*

## Introduction

Let us say we have two functions `plusone` and `timesTwo`

```agda
module Introduction where

  open import Data.Nat using (ℕ; _+_; _*_)

  plusOne : ℕ → ℕ 
  plusOne z = z + 1

  timesTwo : ℕ → ℕ 
  timesTwo z = z * 2  
```

Below we define `_apply_`, applying a function to a value and _`bind_`, binding a value to a
function.

```agda
  infixr 8 _apply_
  _apply_ : {A B : Set} → (A → B) → A → B
  f apply z = f z 

  infixl 8 _bind_ 
  _bind_ : {A B : Set} → A → (A → B) → B
  z bind f = f z
```

The two definitions are equivalent. From a syntax point of view one can argue that expressions
using `_bind_` are more convenient to read from left to right. More about this later.

We can now define function composition `_o_` and `_>>>_`, and those kind of things are what library
devolpers do all the time.

```agda
  infixr 8 _o_
  _o_ : {A B C : Set} → (B → C) → (A → B) → (A → C)
  g o f = λ z → g apply f apply z

  infixl 8 _>>>_
  _>>>_ : {A B C : Set} → (A → B) → (B → C) → (A → C)
  f >>> g = λ z → z bind f bind g 
```

A pointfree programming library would allow library users to only use expressions like `g o f` and
`f >>> g`, that do not mention any values, a.k.a. points, like `z`. More about this later.

Functions like `f` and `g` can then be seen as closed components that are combined using
combinators like `_o_` and `_>>>_`.  Below is another combinator `_|x|_`.

```agda
  open import Data.Product using (_×_; _,_)

  infixr 7 _|x|_
  _|x|_ : (ℕ → ℕ) → (ℕ → ℕ) → (ℕ → ℕ × ℕ) 
  f |x| g = λ z → (f z , g z)
```

Using both `_>>>_` and `_|x|_` library users can write functions like `λ z → (z + 1) + (z * 2)` in
a pointfree way.

```agda
  add : (ℕ × ℕ) → ℕ
  add = λ (z , y) → z + y

  plusOne_Add_TimesTwo : ℕ → ℕ
  plusOne_Add_TimesTwo = (plusOne |x| timesTwo) >>> add
```

All this starts looking like combining hardware components.

So far we have been using pure functions, but programming is also about side effects, external
ones such as reading from the console and writing to the console, internal ones such as
changing the content of a region of memory. 

Side effects are typically handled by using computations that, when executed, may perform
side effects as opposed to expressions that, when evaluated, must not perform side
effects.

Computations are modeles using monads.

```agda
open import Data.Nat using (ℕ; _+_)

record Monad (M : Set → Set) : Set₁ where
  field
    mResult : ∀ {Z : Set} → Z → M Z
    _mBind_ : ∀ {Z Y : Set} → M Z → (Z → M Y) → M Y
```

Using monads one can write code like the one below

```agda
open Monad {{...}}

mPlusOne_Add_TimesTwo : {M : Set → Set} → {{_ : Monad M}} → M ℕ → M ℕ → M ℕ
mPlusOne_Add_TimesTwo mz my =
  mz mBind (λ z → my mBind (λ y → mResult (z + y)))
```

The expression that defines `mPlusOne_Add_TimesTwo mz my` can conveniently be read from left to
right as follows : first execute computation `mz` yielding a result `z`, and then execute
computation `my` yielding a result `y`, and then yield the trivial computation 
`mResult (z + y)` as final result.

Clearly programming with computations is not pointfree programming.

Computations are also components that can be combined with combinators `mBind` and `mResult`.

Clearly they are not closed components. In order to have both `z` and `y` available for
`mResult` we had to open `mz` and `my` using `mz mBind (λ z → ...)` and `my mBind (λ y → ...)`.
That would be like opening a Lego component in order to find something in it to connect it with
another component.

Is pointfree programming the "silver bullet"? Well, no, it is not.

Programming is not only about power of expression but also about elegance.

Elegance is a subjective notion, but I find expressions like
`(plusOne |x| timesTwo) >>> add` more elegant than, say expressions like
`mPlusOne mBind (λ z → mTimesTwo mBind (λ y → mResult (add z y)))`.

Moreover the more there are intermediate values `z`, `y`, `x`, ... involved the more there is
a risk to make mistakes. Ok, you can use meaningful names, but even experienced FP programmes
do not always use meaningful names, which, by the way, I find strange.

But, yes, translating pointful code with many intermediate values to pointfree code is
painful, and the resulting pointfree code can hardly be called elegant.

The `PSBP` library enables positional programming which can be seen as pointful programming in
a pointfree way. Positional code is, in no way, more elegant than, say, traditional pointful code,
but the idea behind pointfree programming using the `PSBP` library is to limit positional
programming to, say, simple script like sequential programs.

Recall Erik Meyer's quote "Great programmers write baby code".

## `Functional`

### `function`

We define a synonym `function Z Y` for functions `Z → Y` in order to distinguish functions of
the DSL from functions of the encoding of the DSL.

```agda
function : Set → Set → Set
function Z Y = Z → Y
```

### `Functional` specification

The `Functional` specification declares `asProgram` treating functions `function Z Y` as programs
`program Z Y`. 

The specification also defines `identity`, the identity program.

```agda
record Functional (program : Set → Set → Set) : Set1 where
  field
    asProgram : {Z Y : Set} → function Z Y → program Z Y

  identity : {Z : Set} → program Z Z
  identity = asProgram (λ z → z)
```

### Primitives programs

Simple functions are treated as primitive programs.

Which functions are considered to be primitive is a choice.

Note that they are the functions that cannot enjoy the benefits of `PSBP`.

For now we define some primitive programs. Some like `duplicate`, are generic, others, like
`plusOne` are specific, others, like `one` are mixed.

Expect the amount of primitive programs to grow by need.

```agda
open import Data.Product using (_×_; _,_)

open import Data.Nat using (ℕ; _+_; _*_; pred; suc)
open import Data.Bool using (Bool; true; false)

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
```

### Program examples

Primitives programs, like `plusOne` are program examples.

### `functionFunctional` implementation

It should not come as a surprise that functions, `function`, are a `Functional` implementation.

```agda
functionFunctional : Functional function
functionFunctional = record { asProgram = λ f → f }
```

### `materializeFunction` materialization

It should not come as a surprise that functions, `function Z Y`, are materialized as functions
`Z → Y` using `materializeFunction`.


```agda
materializeFunction : {Z Y : Set} → function Z Y → (Z → Y)
materializeFunction = λ f → f
```

### `mainPlusOne` using `plusOne`

```agda
open import Data.Nat.Show using (show)

open import IO hiding (_>>=_)

instance
  _ = functionFunctional

materializedPlusOne : ℕ → ℕ
materializedPlusOne = materializeFunction plusOne

n = 10

mainPlusOne : Main
mainPlusOne = run (
  do 
    putStr (show n)
    putStr " + 1 = "
    putStrLn (show (materializedPlusOne n))
  )
```

After compiling, running `./Documentation` yields

```txt
$ ./Documentation 
10 + 1 = 11
```

## `Functorial`

### `Functorial` specification

The next specification declares `functionAction` letting functions `function Y X` act upon programs
`program Z Y` yielding programs `program Z X`.

The specification also defines `_>==_`, an infix version of `functionAction`.

```agda
record Functorial (program : Set → Set → Set) : Set₁ where
  field
    functionAction : {Z Y X : Set} → function Y X → (program Z Y → program Z X)

  infixl 8 _>==_
  _>==_ : {Z Y X : Set} → program Z Y → function Y X → program Z X
  _>==_ p f = functionAction f p
```

### Program examples

Program `plusOneTimesTwo` acts upon program `plusOne` multiplying its result by `2`.

```agda
open Functorial {{...}}

plusOneTimesTwo : 
  {program : Set → Set → Set} 
  {{_ : Functional program}} 
  {{_ : Functorial program}} → program ℕ ℕ
plusOneTimesTwo = plusOne >== timesTwoFunction
```

### `functionFunctorial` implementation

It should not come as a surprise that functions, `function`, are a `Functorial` implementation.

```agda
open import Function using (_∘_)

functionFunctorial : Functorial function
functionFunctorial = record { functionAction = λ f g → f ∘ g }
```

### `mainPlusOneTimesTwo` using `plusOneTimesTwo`

```agda
instance
  _ = functionFunctorial

materializedPlusOneTimesTwo : ℕ → ℕ
materializedPlusOneTimesTwo = materializeFunction plusOneTimesTwo

mainPlusOneTimesTwo : Main
mainPlusOneTimesTwo = run (
  do 
    putStr "("
    putStr (show n)
    putStr " + 1) * 2 = "
    putStrLn (show (materializedPlusOneTimesTwo n))
  )
```

After compiling, running `./Documentation` yields

```txt
$ ./Documentation 
(10 + 1) * 2 = 22
```

## `Sequential`

### `Sequential` specification

The next specification declares `andThenProgram` sequentially composing programs `program Z Y` with
programs `program Y X` yielding programs `program Z X`.

The specification also defines `_>>>_`, an infix version of `andThenProgram`.

```agda
record Sequential (program : Set → Set → Set) : Set₁ where
  field
    andThenProgram : {Z Y X : Set} → program Z Y → program Y X → program Z X

  infixl 8 _>>>_
  _>>>_ : {Z Y X : Set} → program Z Y → program Y X → program Z X
  _>>>_ lp rp = andThenProgram lp rp
```

### Program examples

Program `timesTwoPlusOne_TimesTwo` sequentially composes program `timesTwo` and `plusOne`, and then
`timesTwoFunction` acts upon the composition by multiplying its result by `2`.

```agda
open Sequential {{...}}

timesTwoPlusOne_TimesTwo : 
  {program : Set → Set → Set} 
  {{_ : Functional program}} 
  {{_ : Functorial program}} 
  {{_ : Sequential program}} → program ℕ ℕ
timesTwoPlusOne_TimesTwo = timesTwo >>> plusOne >== timesTwoFunction
```

### `functionSequential` implementation

It should not come as a surprise that functions, `function`, are a `Sequential` implementation.

```agda
functionSequential : Sequential function
functionSequential = record { andThenProgram = λ f g → g ∘ f }
```

### `mainTimesTwoPlusOneTimesTwo` using `timesTwoPlusOne_TimesTwo`

```agda
instance
  _ = functionSequential

materializedTimesTwoPlusOneTimesTwo : ℕ → ℕ
materializedTimesTwoPlusOneTimesTwo = materializeFunction timesTwoPlusOne_TimesTwo

mainTimesTwoPlusOneTimesTwo : Main
mainTimesTwoPlusOneTimesTwo = run (
  do 
    putStr "(2 * "
    putStr (show n)
    putStr " + 1) * 2 = "
    putStrLn (show (materializedTimesTwoPlusOneTimesTwo n))
  )
```

After compiling, running `./Documentation` yields

```txt
$ ./Documentation
(2 * 10 + 1) * 2 = 42
```

## `Creational`

The next specification declares `sequentialProduct` sequentially using programs `program Z Y` and
programs `program Z X` yielding programs `program Z (Y × X)` producing a product `Y × X`.

The specification also defines `_|x|_`, an infix version of `sequentialProduct`.

The specification also defines `LET_IN_`, a pointfree library level version of the pointful
language level `let ... in ...` . 

Think of `LET_IN_` as follows: given a program `program Z Y` and a `Z` that can be used to create
an intermediate result `Y`, a given program `program (Z × Y) X` can then use the pair `Z × Y`,
consisting of the given `Z` and the created `Y` to yield a result `Z`. Think of `Z` as an argument,
think of the intermediate result `Y` as local value, and think of `X` as a final result.

As such, nested `LET_IN_`s can be used to create an environment, consisting of an argument and many
intermediate results as local values. 

The specification also defines `_AT_ANDTHEN_` which uses this environment explicitly. It also
defines environment positions like `P1`, `P2` and `P21` to access the argument and/or local values
of this environment at their position.

Think of using `_AT_ANDTHEN_` together with argument and local value positions like `P1`, `P2` and
`P21`, as pointful programming in a pointfree way. Agreed we introduce pointfree programming again,
using natural number indices to access local values in the environment, but, typically,
`_AT_ANDTHEN_` is used for simple, script like sequential programs with a simple environment.

### `Creational` specification

```agda
record Creational (program : Set → Set → Set) : Set₁ where
  field
    sequentialProduct : {Z Y X : Set} → program Z Y → program Z X → program Z (Y × X)

  infixr 7 _|x|_
  _|x|_ : {Z Y X : Set} → program Z Y → program Z X → program Z (Y × X)
  _|x|_ lp rp = sequentialProduct lp rp

  infix 0 LET_IN_
  LET_IN_ :
    {{_ : Functional program}} 
    {{_ : Sequential program}} 
      → {Z Y X : Set} → program Z Y → program (Z × Y) X → program Z X
  LET lp IN ip = (identity |x| lp) >>> ip

  infixr 10 _AT_ANDTHEN_
  _AT_ANDTHEN_ :
    {{_ : Functional program}} 
    {{_ : Sequential program}} 
      → {E Z Y X : Set} → program Z Y → program E Z → program (E × Y) X → program E X  
  p AT e ANDTHEN e×y = LET e >>> p IN e×y
  -- p AT e ANDTHEN e×y = (identity |x| e >>> p) >>> e×y -- LET e >>> ap IN e×y

P1 :
  {program : Set → Set → Set} 
  {{_ : Functional program}} 
    → {E Z : Set} → program (E × Z) Z
P1 = asProgram (λ (_ , z) → z)

P2 :
  {program : Set → Set → Set} 
  {{_ : Functional program}} 
    → {E Z Y : Set} → program ((E × Z) × Y) Z
P2 = asProgram (λ ((_ , z) , _) → z)

P21 :
  {program : Set → Set → Set} 
  {{_ : Functional program}} 
    → {E Z Y : Set} → program ((E × Z) × Y) (Z × Y)
P21 = asProgram (λ ((_ , z) , y) → (z , y))
```

### Program examples

Program `plusOne_Add_TimesTwo` uses the sequential program product of `plusOne` and `timesTwo`
and lets `addFunction` act upon its product result adding its parts.

```agda
open Creational {{...}}

plusOne_Add_TimesTwo : 
  {program : Set → Set → Set} 
  {{_ : Functional program}} 
  {{_ : Functorial program}} 
  {{_ : Creational program}} → program ℕ ℕ
plusOne_Add_TimesTwo = (plusOne |x| timesTwo) >== addFunction
```

### `functionCreational` implementation

It should not come as a surprise that functions, `function`, are a `Creational` implementation.

```agda
functionCreational : Creational function
functionCreational = record { sequentialProduct = λ f g z → (f z , g z) }
```

### `mainPlusOne_Add_TimesTwo` using `plusOne_Add_TimesTwo`

```agda
instance
  _ = functionCreational

materializedPlusOne_Add_TimesTwo : ℕ → ℕ
materializedPlusOne_Add_TimesTwo = materializeFunction plusOne_Add_TimesTwo

mainPlusOne_Add_TimesTwo : Main
mainPlusOne_Add_TimesTwo = run (
  do 
    putStr "("
    putStr (show n)
    putStr " + 1) + ("
    putStr (show n)
    putStr " * 2) = "
    putStrLn (show (materializedPlusOne_Add_TimesTwo n))
  )
```

After compiling, running `./Documentation` yields

```txt
$ ./Documentation
(10 + 1) + (10 * 2) = 31
```

### Program examples

Program `timesTwo_Add_PlusOne` uses the sequential program product of `timesTwo` and `plusOne`
composed with program `add` adding the parts of its product result.

```agda
timesTwo_Add_PlusOne : 
  {program : Set → Set → Set} 
  {{_ : Functional program}} 
  {{_ : Sequential program}} 
  {{_ : Creational program}} → program ℕ ℕ
timesTwo_Add_PlusOne = (timesTwo |x| plusOne) >>> add
```

### `mainTimesTwo_Add_PlusOne` using `timesTwo_Add_PlusOne`

```agda
materializedTimesTwo_Add_PlusOne : ℕ → ℕ
materializedTimesTwo_Add_PlusOne = materializeFunction timesTwo_Add_PlusOne

mainTimesTwo_Add_PlusOne : Main
mainTimesTwo_Add_PlusOne = run (
  do 
    putStr "("
    putStr (show n)
    putStr " * 2) + ("
    putStr (show n)
    putStr " + 1) = "
    putStrLn (show (materializedTimesTwo_Add_PlusOne n))
  )
```

After compiling, running `./Documentation` yields

```txt
$ ./Documentation
(10 * 2) + (10 + 1) = 31
```

### Program examples

Program `self_Add_PlusOne` creates a local value that is the intermediate result of `plusOne`
and then uses `add` to add its argument and that local value.

```agda
self_Add_PlusOne : 
  {program : Set → Set → Set} 
  {{_ : Functional program}} 
  {{_ : Sequential program}} 
  {{_ : Creational program}} → program ℕ ℕ
self_Add_PlusOne = LET plusOne IN add
```

### `mainSelf_Add_PlusOne` using `self_Add_PlusOne`

```agda
materializedTimesTwoAddPlusOne : ℕ → ℕ
materializedTimesTwoAddPlusOne = materializeFunction self_Add_PlusOne

mainSelf_Add_PlusOne : Main
mainSelf_Add_PlusOne = run (
  do 
    putStr (show n)
    putStr " + ("
    putStr (show n)
    putStr " + 1) = "
    putStrLn (show (materializedTimesTwoAddPlusOne n))
  )
```

After compiling, running `./Documentation` yields

```txt
$ ./Documentation
10 + (10 + 1) = 21
```

### Program examples

Program `self_Add_PlusOne_WithEnv` is a variation of `self_Add_PlusOne` that explicitly uses
the environment, starting with the empty environment, modeled as the singleton type `⊤`,
together with an argument.

```agda
open import Data.Unit using (⊤)

self_Add_PlusOne_WithEnv :
  {program : Set → Set → Set} 
  {{_ : Functional program}} 
  {{_ : Sequential program}} 
  {{_ : Creational program}} → program (⊤ × ℕ) ℕ
self_Add_PlusOne_WithEnv =
  plusOne AT P1 ANDTHEN
  plusOne AT P2 ANDTHEN
  add AT P21 ANDTHEN
  P1
```

### `mainSelf_Add_PlusOne_WithEnv` using `self_Add_PlusOne_WithEnv`

```agda
open import Data.Unit using (tt)

materializedSelf_Add_PlusOne_WithEnv : (⊤ × ℕ) → ℕ
materializedSelf_Add_PlusOne_WithEnv = materializeFunction self_Add_PlusOne_WithEnv

mainSelf_Add_PlusOne_WithEnv : Main
mainSelf_Add_PlusOne_WithEnv = run (
  do 
    putStr "self_Add_PlusOne_WithEnv (tt, "
    putStr (show n)
    putStr ") = "
    putStrLn (show (materializedSelf_Add_PlusOne_WithEnv (tt , n)))
  )
```

After compiling, running `./Documentation` yields

```txt
$ ./Documentation
self_Add_PlusOne_WithEnv (tt, 10) = 22
```

So why is this result `22`?

- The first `plusOne AT P1` accesses the argument `10` at position `1` since the environment at
that that usage point is
  - `(⊤ , 10)`.
- The second `plusOne AT P2` accesses the argument `10` at position `2` since the environment at
that that usage point is
  - `((⊤ , 10) , 11)`. 
- The third `add AT P21` accesses the local values `11` and `11` at position `2` and `1`, since
the environment at that usage point is
  - `(((⊤ , 10) , 11), 11)`.

So, if, for example, `plusOne AT P2` is replaced by `plusOne AT P1` the final result is `23`.

You will soon get used to this positional programming.

### Program examples 

Program `envResulting_Self_Add_PlusOne_WithEnv` is a variation of `self_Add_PlusOne_WithEnv`
yielding the environment.

```agda
envResulting_Self_Add_PlusOne_WithEnv :
  {program : Set → Set → Set} 
  {{_ : Functional program}} 
  {{_ : Sequential program}} 
  {{_ : Creational program}} → program (⊤ × ℕ) ((((⊤ × ℕ) × ℕ) × ℕ) × ℕ)
envResulting_Self_Add_PlusOne_WithEnv =
  plusOne AT P1 ANDTHEN
  plusOne AT P2 ANDTHEN
  add AT P21 ANDTHEN
  identity
```

### `mainEnvResulting_Self_Add_PlusOne_WithEnv` using `envResulting_Self_Add_PlusOne_WithEnv`

Program `mainEnvResulting_Self_Add_PlusOne_WithEnv` is a variation of `self_Add_PlusOneWithEnv`
that, using `identity`, has the environment as final result.

```agda
materializedEnvResulting_Self_Add_PlusOne_WithEnv :
  (⊤ × ℕ) → ((((⊤ × ℕ) × ℕ) × ℕ) × ℕ)
materializedEnvResulting_Self_Add_PlusOne_WithEnv = 
  materializeFunction envResulting_Self_Add_PlusOne_WithEnv

mainEnvResulting_Self_Add_PlusOne_WithEnv : Main
mainEnvResulting_Self_Add_PlusOne_WithEnv = run (
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
```

After compiling, running `./Documentation` yields

```txt
$ ./Documentation
result trace
argument = 10
intermediate result1 = 11
intermediate result2 = 11
final result3 = 22
```

## `Conditional`

The next specification declares `sum` using programs `program Z X` and
programs `program Y X` yielding programs `program (Z ⊎ Y) X` consuming a sum `Z ⊎ Y`.

The specification also defines `_|+|_`, an infix version of `sum`.

The specification also defines `IF_THEN_ELSE_`, a pointfree library level version of the language
level `if ... then ... else ...` . 

### `Conditional` specification

```agda
open import Data.Sum using (_⊎_; inj₁; inj₂)

open import Data.Bool using (Bool; true; false)

record Conditional (program : Set → Set → Set) : Set₁ where
  field
    sum : {Z Y X : Set} → program Z X → program Y X → program (Z ⊎ Y) X

  infixr 6 _|+|_
  _|+|_ : {Z Y X : Set} → program Z X → program Y X → program (Z ⊎ Y) X
  _|+|_ lp rp = sum lp rp

  infix 0 IF_THEN_ELSE_
  IF_THEN_ELSE_ :
    {{_ : Functional program}} 
    {{_ : Sequential program}} 
    {{_ : Creational program}} 
      → {Z X : Set} → program Z Bool → program Z X → program Z X → program Z X
  IF bp THEN tp ELSE fp = 
    (LET bp IN asProgram chooseBranch) >>> (tp |+| fp)
    where
      chooseBranch : {Z : Set} → (Z × Bool) → (Z ⊎ Z)
      chooseBranch (z , true)  = inj₁ z
      chooseBranch (z , false) = inj₂ z
```

### Program examples

Program `fibonacci` is a recursive program.

The type system needs to be bypassed using `{-# TERMINATING #-}`.

```agda
open Conditional {{...}}

{-# TERMINATING #-}
fibonacci : 
  {program : Set → Set → Set} 
  {{_ : Functional program}} 
  {{_ : Sequential program}} 
  {{_ : Creational program}} 
  {{_ : Conditional program}} → program ℕ ℕ
fibonacci =  
  IF isZero 
    THEN 
      one 
    ELSE
      IF isOne 
        THEN 
          one 
        ELSE 
          (minusOne >>> fibonacci |x| minusTwo >>> fibonacci) >>> add
```

### `functionConditional` implementation

It should not come as a surprise that functions, `function`, are a `Conditional` implementation.

```agda
functionConditional : Conditional function
functionConditional = record { sum = λ { f g (inj₁ z) → f z ; f g (inj₂ y) → g y } }
```

### `mainFibonacci` using `fibonacci`

```agda
instance
  _ = functionConditional

materializedFibonacci : ℕ → ℕ
materializedFibonacci = materializeFunction fibonacci

mainFibonacci : Main
mainFibonacci = run (
  do 
    putStr "fibonacci("
    putStr (show n)
    putStr ") = "
    putStrLn (show (materializedFibonacci n))
  )
```

After compiling, running `./Documentation` yields

```txt
$ ./Documentation
fibonacci(10) = 89
```

### Program examples

Program `factorial` is also a recursive program.

The type system needs to be bypassed using `{-# TERMINATING #-}`.

```agda
{-# TERMINATING #-}
factorial : 
  {program : Set → Set → Set} 
  {{_ : Functional program}} 
  {{_ : Sequential program}} 
  {{_ : Creational program}} 
  {{_ : Conditional program}} → program ℕ ℕ
factorial = 
  IF isZero 
    THEN 
      one 
    ELSE 
      LET 
        minusOne >>> factorial 
      IN 
        times
```

### `mainFactorial` using `factorial`

```agda
materializedFactorial : ℕ → ℕ
materializedFactorial = materializeFunction factorial

mainFactorial : Main
mainFactorial = run (
  do 
    putStr "factorial("
    putStr (show n)
    putStr ") = "
    putStrLn (show (materializedFactorial n))
  )
```

After compiling, running `./Documentation` yields

```txt
$ ./Documentation
factorial(10) = 3628800
```

## Computations

### `computationValuedFunction M` instances

In the introduction we already mentioned computations `M : Set → Set`.

Agda comes with its own `RawMonad` that comes with `do ... return ...` syntax.

Below we define `computationValuedFunction`

```agda
computationValuedFunction : (Set → Set) → Set → Set → Set
computationValuedFunction M Z Y = Z → M Y
```

Below are instances defined for `Functional`, `Functorial`, `Sequential`, `Creational` and
`Conditional`. They are defined in a `module` in order not to have to repeat `M`, `monad` and
universe level `zero` all the time.

```agda
open import Level using (zero)

open import Effect.Monad using (RawMonad)

module ComputationValuedFunctionInstances 
    {M : Set → Set} (monad : RawMonad {zero} {zero} M) where
  open RawMonad monad

  computationValuedFunctionFunctional : Functional (computationValuedFunction M)
  computationValuedFunctionFunctional = record
    { asProgram = λ f z → return (f z)
    }

  computationValuedFunctionFunctorial : Functorial (computationValuedFunction M)
  computationValuedFunctionFunctorial = record
    { functionAction = λ g f z → do
        y ← f z
        return (g y)
    }

  computationValuedFunctionSequential : Sequential (computationValuedFunction M)
  computationValuedFunctionSequential = record
    { andThenProgram = λ f g z → do
        y ← f z
        g y
    }

  computationValuedFunctionCreational : Creational (computationValuedFunction M)
  computationValuedFunctionCreational = record
    { sequentialProduct = λ f g z → do
        y ← f z
        x ← g z
        return (y , x)
    }

  computationValuedFunctionConditional : Conditional (computationValuedFunction M)
  computationValuedFunctionConditional = record
    { sum = λ { f g (inj₁ z) → f z ; f g (inj₂ y) → g y }
    }
```

### `materializeIdComputationValuedFunction` materialization

It should not come as a surprise that computation valued functions,
`computationValuedFunction Identity Z Y`, are materialized as functions
`Z → Y` using `materializeIdComputationValuedFunction`.

```agda
open import Effect.Monad.Identity as IdentityModule public
  using (Identity; runIdentity)

materializeIdComputationValuedFunction :
  {Z Y : Set} →
  computationValuedFunction Identity Z Y → (Z → Y)
materializeIdComputationValuedFunction f z = runIdentity (f z)
```

### `mainIdTimesTwoAddPlusOne` using `timesTwoAddPlusOne`

```agda
open import Effect.Monad.Identity using (Identity)

open import Effect.Monad.Identity as IdentityModule public using (monad)

open ComputationValuedFunctionInstances monad

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

mainIdTimesTwoAddPlusOne : Main
mainIdTimesTwoAddPlusOne = run (
  do
    putStrLn "Id computation-valued timesTwo_Add_PlusOne"
    putStr "("
    putStr (show n)
    putStr " * 2) + ("
    putStr (show n)
    putStr " + 1) = "
    putStrLn (show (materializedIdTimesTwoAddPlusOne n))
  )
```

After compiling, running `./Documentation` yields

```txt
$ ./Documentation
Id computation-valued timesTwo_Add_PlusOne
(10 * 2) + (10 + 1) = 31
```

## `WithState`

### `WithState` specification

The `WithState (S : Set)` specification declares `readState` a `program Z S` and `writeState` a
`program S ⊤`, where the result type is modeled as the singleton type `⊤`.

The specification also defines `modifyStateWithFunction` and `modifyStateWith`. 

```agda
open import Data.Product using (proj₁)

record WithState (S : Set) (program : Set → Set → Set) : Set1 where
  field
    readState  : {Z : Set} → program Z S
    writeState : program S ⊤

  modifyStateWithFunction :
    {{_ : Functional program}} 
    {{_ : Sequential program}} 
    {{_ : Creational program}} →
    {Z : Set} → function S S → program Z Z
  modifyStateWithFunction f =
    LET (readState >>> asProgram f >>> writeState) IN asProgram proj₁

  modifyStateWith :
    {{_ : Functional program}} 
    {{_ : Sequential program}} 
    {{_ : Creational program}} →
    {Z : Set} → program S S → program Z Z
  modifyStateWith p =
    LET (readState >>> p >>> writeState) IN asProgram proj₁
```

### Program examples

`fibonacciWithState` is a program consisting of `readState` for using the state as an argument, 
sequentially composed with `fibonacci`, sequentially composed with incrementing the state using
`modifyStateWith plusOne` as a, somewhat unusual, side effect.

```agda
open WithState {{...}}

{-# TERMINATING #-}
fibonacciWithState :
  {program : Set → Set → Set}
  {{_ : Functional program}}
  {{_ : Sequential program}}
  {{_ : Creational program}}
  {{_ : Conditional program}}
  {{_ : WithState ℕ program}} → program ⊤ ℕ
fibonacciWithState =
  readState >>> fibonacci >>> modifyStateWith plusOne
```

### `stateTMonad` and `stateTWithState` implementation

`StateT S` transforms a computation to a computation that threads a state along its execution. 

Below are instances defined for `RawMonad` and `WithState S`. They are defined in a `module` in
order not to have to repeat `S`, `M`, `monad` and universe level `zero` all the time.


```agda
open import Data.Unit using (tt)

open import Effect.Monad.State.Transformer as StateTModule public using (StateT; mkStateT)

module StateTInstances {S : Set} {M : Set → Set} (monad : RawMonad {zero} {zero} M) where
  open RawMonad monad

  stateTMonad : RawMonad {zero} {zero} (StateT S M)
  stateTMonad = StateTModule.monad monad

  open ComputationValuedFunctionInstances stateTMonad public

  stateTWithState : WithState S (computationValuedFunction (StateT S M))
  stateTWithState = record
    { readState = λ _ → mkStateT (λ s → RawMonad.pure monad (s , s))
    ; writeState = λ s' → mkStateT (λ s → RawMonad.pure monad (s' , tt))
    }
```

### `IdStateTInstance`

`IdStateTInstance` uses `Identity` and `IdentityModule.monad`.

```agda
module IdStateTInstance {S : Set} where
  open StateTInstances {S} {Identity} IdentityModule.monad public
```

### `materializeIdStateT` materialization

The most verbose way to materialize computation valued functions
`computationValuedFunction (StateT S Id) Z Y` is as functions
`(Z → (S → (Y × S)))`


```agda
open import Effect.Monad.State.Transformer as StateTModule public using (runStateT)

materializeIdStateT :
  {S Z Y : Set} →
  computationValuedFunction (StateT S Identity) Z Y → (Z → (S → (Y × S)))
materializeIdStateT f z s =
  let (s' , y) = runIdentity (runStateT (f z) s)
  in (y , s')
```

### `mainFibonacciWithState` using `fibonacciWithState`

```agda
instance
  _ = IdStateTInstance.computationValuedFunctionFunctional {ℕ}
instance
  _ = IdStateTInstance.computationValuedFunctionSequential {ℕ}
instance
  _ = IdStateTInstance.computationValuedFunctionCreational {ℕ}
instance
  _ = IdStateTInstance.computationValuedFunctionConditional {ℕ}
instance
  _ = IdStateTInstance.stateTWithState {ℕ}

materializedFibonacciWithState : ⊤ → ℕ → (ℕ × ℕ)
materializedFibonacciWithState = 
  materializeIdStateT 
    (fibonacciWithState {program = computationValuedFunction (StateT ℕ Identity)})

mainFibonacciWithState : Main
mainFibonacciWithState = run (
  do 
    let (res , finalState) = materializedFibonacciWithState tt n
    putStr "fibonacciWithState initial state = "
    putStr (show n)
    putStr "\nFibonacci result = "
    putStr (show res)
    putStr "\nFinal state after increment (+1) = "
    putStrLn (show finalState)
  )
```

After compiling, running `./Documentation` yields

```txt
$ ./Documentation
fibonacciWithState initial state = 10
Fibonacci result = 89
Final state after increment (+1) = 11
```

### Program examples

`fibonacciWithStatePair` is simply defined as the product of `fibonacciWithState` with itself.

```agda
{-# TERMINATING #-}
fibonacciWithStatePair :
  {program : Set → Set → Set}
  {{_ : Functional program}}
  {{_ : Sequential program}}
  {{_ : Creational program}}
  {{_ : Conditional program}}
  {{_ : WithState ℕ program}} → program ⊤ (ℕ × ℕ)
fibonacciWithStatePair = fibonacciWithState |x| fibonacciWithState
```

### `mainFibonacciWithStatePair` using `fibonacciWithStatePair`

```agda
materializedFibonacciWithStatePair : ⊤ → ℕ → ((ℕ × ℕ) × ℕ)
materializedFibonacciWithStatePair = materializeIdStateT (
  fibonacciWithStatePair {program = computationValuedFunction (StateT ℕ Identity)})

mainFibonacciWithStatePair : Main
mainFibonacciWithStatePair = run (
  do 
    let ((fib1 , fib2) , finalState) = materializedFibonacciWithStatePair tt n
    putStr "fibonacciWithStatePair initial state = "
    putStrLn (show n)
    putStr "First fibonacciPair result = "
    putStrLn (show fib1)
    putStr "Second fibonacciPair result = "
    putStrLn (show fib2)
    putStr "Final state after two increments (+2) = "
    putStrLn (show finalState)
  )
```

After compiling, running `./Documentation` yields

```txt
$ ./Documentation 
fibonacciWithStatePair initial state = 10
First fibonacciPair result = 89
Second fibonacciPair result = 144
Final state after two increments (+2) = 12
```

## Continuations

### `contTMonad` and `stateTWithState` implementation

The continuation monad transformer `ContT R M Z = (Z → M R) → M R` transforms a computation into a
continuation-passing style computation and, for the moment, define our own.

Note that Agda has delimited continuations, where continuations are a special case of.

We deal with delimited continuations later.

```agda
ContT : Set → (Set → Set) → Set → Set
ContT R M A = (A → M R) → M R

module ContTInstances {R : Set} {M : Set → Set} (monad : RawMonad {zero} {zero} M) where
  open RawMonad monad

  contTMonad : RawMonad {zero} {zero} (ContT R M)
  contTMonad = record
    { rawApplicative = record
        { rawFunctor = record
            { _<$>_ = λ f ma k → ma (λ a → k (f a))
            }
        ; pure = λ a k → k a
        ; _<*>_ = λ mf mx k → mf (λ f → mx (λ x → k (f x)))
        }
    ; _>>=_ = λ ma f k → ma (λ a → f a k)
    }

  open ComputationValuedFunctionInstances contTMonad public
```

### `IdContTInstance`

```agda
module IdContTInstance {R : Set} where
  open ContTInstances {R} {Identity} IdentityModule.monad public
```

### `materializeIdContT` materialization

```agda
materializeIdContT :
  {R Z Y : Set} →
  computationValuedFunction (ContT R Identity) Z Y → (Z → ((Y → Identity R) → Identity R))
materializeIdContT f = f
```

### `mainFibonacciWithCont` using `fibonacci`

```agda
open import Effect.Monad.Identity as IdentityModule public using (mkIdentity)

instance
  _ = IdContTInstance.computationValuedFunctionFunctional
instance
  _ = IdContTInstance.computationValuedFunctionFunctorial
instance
  _ = IdContTInstance.computationValuedFunctionSequential
instance
  _ = IdContTInstance.computationValuedFunctionCreational
instance
  _ = IdContTInstance.computationValuedFunctionConditional

materializedFibonacciWithCont : ℕ → (ℕ → Identity ℕ) → Identity ℕ
materializedFibonacciWithCont = 
  materializeIdContT 
    (fibonacci {program = computationValuedFunction (ContT ℕ Identity)})

mainFibonacciWithCont : Main
mainFibonacciWithCont = run (
  do
    putStr "fibonacciWithCont("
    putStr (show n)
    putStr ") = "
    putStrLn (show (runIdentity (materializedFibonacciWithCont n mkIdentity)))
  )
```

After compiling, running `./Documentation` yields

```txt
$ ./Documentation 
fibonacciWithCont(10) = 89
```

## `WithPar`

### `WithPar` specification

The `WithPar` specification declares `par` using programs `program Z Z` and
programs `program Y W` in parallel yielding programs `rogram (Z × Y) (X × W)` consuming a
product `Z × Y` and producing a product `X × W`.

The specification also defines `_|||_`, an infix version of `par`.

```agda
record WithPar (program : Set → Set → Set) : Set1 where
  field
    par : {Z Y X W : Set} → program Z X → program Y W → program (Z × Y) (X × W)

infixr 7 _|||_
_|||_ : {program : Set → Set → Set} {{_ : WithPar program}} →
        {Z Y X W : Set} → program Z X → program Y W → program (Z × Y) (X × W)
_|||_ {{p}} = WithPar.par p
```

### Program examples

When using `duplicate`, `fibonacciWithPar` below is defined in a similar way as `fibonacci`.

`fibonacciWithPar` can also be defined without using `duplicate` (commented out).

```agda
{-# TERMINATING #-}
fibonacciWithPar :
  {program : Set → Set → Set}
  {{_ : Functional program}}
  {{_ : Sequential program}}
  {{_ : Creational program}}
  {{_ : Conditional program}}
  {{_ : WithPar program}} → program ℕ ℕ
fibonacciWithPar =
  IF isZero THEN
    one
  ELSE
    IF isOne THEN
      one
    ELSE
      duplicate >>> 
        (minusOne >>> fibonacciWithPar ||| minusTwo >>> fibonacciWithPar) >>> 
          add
      -- (minusOne |x| minusTwo) >>> (fibonacciWithPar ||| fibonacciWithPar) >>> add
```

### `dramaActorMonad` and `dramaActorWithPar` implementation

The implementations below use the Haskell actor library `drama`.

```agda
data Pair (A B : Set) : Set where
  pair : A → B → Pair A B

{-# COMPILE GHC Pair = data (,) ((,)) #-}

postulate
  DramaActor : Set → Set → Set

  dramaActorMonad : {msg : Set} → RawMonad {zero} {zero} (DramaActor msg)

  dramaActorPar : 
    {msg Z Y X W : Set} →
      computationValuedFunction (ContT ⊤ (DramaActor msg)) Z X →
      computationValuedFunction (ContT ⊤ (DramaActor msg)) Y W →
      Pair Z Y → ContT ⊤ (DramaActor msg) (Pair X W)

{-# FOREIGN GHC import qualified Haskell.DramaActor as Drama #-}
{-# FOREIGN GHC import qualified Drama as D #-}
{-# FOREIGN GHC import Control.Monad.Trans.Cont (ContT(..)) #-}
{-# FOREIGN GHC import Unsafe.Coerce (unsafeCoerce) #-}

{-# COMPILE GHC DramaActor = type D.Actor #-}
{-# COMPILE GHC 
  dramaActorPar = \ _ _ _ _ _ z2x y2w -> 
    unsafeCoerce (Drama.parDrama (unsafeCoerce z2x) (unsafeCoerce y2w)) #-}

module DramaActorInstance {msg : Set} where
  open ContTInstances {R = ⊤} (dramaActorMonad {msg}) public

  dramaActorWithPar : WithPar (computationValuedFunction (ContT ⊤ (DramaActor msg)))
  dramaActorWithPar = record
    { par = 
        λ {Z} {Y} {X} {W} f g (z , y) k → 
          dramaActorPar f g (pair z y) (λ { (pair x w) → k (x , w) })
    }
```

###  Haskell code

The Haskell code implementing `parDrama` is below


```haskell
{-# LANGUAGE GADTs #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Haskell.DramaActor where

import Drama ( cast, receive, spawn, wait, Actor, Address )
import Control.Monad.IO.Class (liftIO)
import Unsafe.Coerce (unsafeCoerce)

data Message x w res where
  LeftReact  :: x -> Message x w ()
  RightReact :: w -> Message x w ()

showVal :: a -> String
showVal v = show (unsafeCoerce v :: Integer)

parDrama :: forall z y x w.
            (z -> (x -> Actor (Message x w) ()) -> Actor (Message x w) ())
         -> (y -> (w -> Actor (Message x w) ()) -> Actor (Message x w) ())
         -> (z, y)
         -> ((x, w) -> Actor (Message x w) ())
         -> Actor (Message x w) ()
parDrama z2x y2w (z, y) cont = do
  reactorAddr <- spawn (reactor cont)
  _ <- spawn (leftActor reactorAddr)
  _ <- spawn (rightActor reactorAddr)
  wait
  where
    reactor :: ((x, w) -> Actor (Message x w) ()) -> Actor (Message x w) ()
    reactor cont = receive $ \case
      LeftReact x -> do
        liftIO $ putStrLn $ "\t [Reactor] receives LeftReact (" ++ showVal x ++ ")"
        receive $ \case
          RightReact w -> do
            liftIO $ putStrLn $ 
              "\t [Reactor] receives RightReact (" ++ showVal w ++ ")" ++ 
                " -> combining (" ++ showVal x ++ ", " ++ showVal w ++ ")"
            cont (x, w)
          LeftReact _ -> error "Unexpected duplicate LeftReact"
      RightReact w -> do
        liftIO $ putStrLn $ "\t [Reactor] receives RightReact (" ++ showVal w ++ ")"
        receive $ \case
          LeftReact x -> do
            liftIO $ putStrLn $ 
              "\t [Reactor] receives LeftReact (" ++ showVal x ++ ")" ++
                " -> combining (" ++ showVal x ++ ", " ++ showVal w ++ ")"
            cont (x, w)
          RightReact _ -> error "Unexpected duplicate RightReact"

    leftActor :: Address (Message x w) -> Actor (Message x w) ()
    leftActor reactorAddr = do
      z2x z (\x -> do
        liftIO $ putStrLn $ 
          "\t [LeftActor] finished left branch" ++
            " -> sending LeftReact (" ++ showVal x ++ ")"
        cast reactorAddr (LeftReact x))

    rightActor :: Address (Message x w) -> Actor (Message x w) ()
    rightActor reactorAddr = do
      y2w y (\w -> do
        liftIO $ putStrLn $
          "\t [RightActor] finished right branch" ++
            " -> sending RightReact (" ++ showVal w ++ ")"
        cast reactorAddr (RightReact w))
```

### `materializeDramaActorContT` materialization

```agda
materializeDramaActorContT :
  {msg Z Y : Set} →
  computationValuedFunction (ContT ⊤ (DramaActor msg)) Z Y → 
    Z → ((Y → DramaActor msg ⊤) → DramaActor msg ⊤)
materializeDramaActorContT f z k = f z k
```

### `mainFibonacciWithPar` using `fibonacciWithPar`

```agda
open import Agda.Builtin.IO using () renaming (IO to AgdaIO)

postulate
  DramaMessage : Set → Set → Set

  printFibResult : ℕ → ℕ → DramaActor (DramaMessage ℕ ℕ) ⊤

  runDramaActor : {msg : Set} → DramaActor msg ⊤ → AgdaIO ⊤

{-# FOREIGN GHC import qualified Haskell.DramaActor as Drama #-}
{-# FOREIGN GHC import qualified Drama as D #-}
{-# FOREIGN GHC import Control.Monad.IO.Class (liftIO) #-}

{-# COMPILE GHC DramaMessage = type Drama.Message #-}
{-# COMPILE GHC printFibResult = 
  \ n res -> liftIO (putStrLn 
    ("fibonacciWithPar(" ++ show n ++ ") = " ++ show res)) #-}
{-# COMPILE GHC runDramaActor = \ _ -> D.runActor #-}

instance
  _ = DramaActorInstance.computationValuedFunctionFunctional
instance
  _ = DramaActorInstance.computationValuedFunctionFunctorial
instance
  _ = DramaActorInstance.computationValuedFunctionSequential
instance
  _ = DramaActorInstance.computationValuedFunctionCreational
instance
  _ = DramaActorInstance.computationValuedFunctionConditional
instance
  _ = DramaActorInstance.dramaActorWithPar

materializedFibonacciWithPar : 
  ℕ → (ℕ → DramaActor (DramaMessage ℕ ℕ) ⊤) → DramaActor (DramaMessage ℕ ℕ) ⊤
materializedFibonacciWithPar = 
  materializeDramaActorContT 
  (fibonacciWithPar 
    {program = computationValuedFunction (ContT ⊤ (DramaActor (DramaMessage ℕ ℕ)))})

mainFibonacciWithPar : Main
mainFibonacciWithPar = run (
  do
    lift′ (runDramaActor (materializedFibonacciWithPar n (λ res → printFibResult n res)))
  )
```

After compiling, running `./Documentation` yields

```txt
$ ./Documentation
$ src/Documentation 
         [LeftActor] finished left branch -> sending LeftReact (1)
         [RightActor] finished right branch -> sending RightReact (1)
         [Reactor] receives LeftReact (1)
         [Reactor] receives RightReact (1) -> combining (1, 1)
         [RightActor] finished right branch -> sending RightReact (2)
         [LeftActor] finished left branch -> sending LeftReact (1)
...
         [RightActor] finished right branch -> sending RightReact (34)
         [LeftActor] finished left branch -> sending LeftReact (34)
         [Reactor] receives RightReact (34)
         [Reactor] receives LeftReact (34) -> combining (34, 21)
         [LeftActor] finished left branch -> sending LeftReact (55)
         [Reactor] receives LeftReact (55) -> combining (55, 34)
fibonacciWithPar(10) = 89
```

## `main`

**Please uncomment the example that you want to run.**

```agda
main : Main
main = 
  -- mainPlusOne
  -- mainPlusOneTimesTwo
  -- mainTimesTwoPlusOneTimesTwo
  -- mainSelf_Add_PlusOneTimesTwo
  -- mainPlusOne_Add_TimesTwo
  -- mainTimesTwo_Add_PlusOne
  -- mainSelf_Add_PlusOne
  -- mainSelf_Add_PlusOne_WithEnv
  -- mainEnvResulting_Self_Add_PlusOne_WithEnv
  -- mainFibonacci
  -- mainFactorial
  -- mainIdTimesTwoAddPlusOne
  -- mainFibonacciWithState
  -- mainFibonacciWithStatePair
  -- mainFibonacciWithCont
  mainFibonacciWithPar
```