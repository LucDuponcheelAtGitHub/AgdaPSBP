#! /bin/bash

export PATH="$HOME/.cabal/bin:$PATH"

# echo -e "\e[31mbuilding Mains.Function.Functional.PlusOne\e[0m"
# agda --compile --ghc-flag="-v0" src/Mains/Function/Functional/PlusOne.agda 

# echo -e "\e[31mbuilding Mains.Function.Functorial.PlusOneTimesTwo\e[0m"
# agda --compile --ghc-flag="-v0" src/Mains/Function/Functorial/PlusOneTimesTwo.agda

# echo -e "\e[31mbuilding Mains.Function.Sequential.TimesTwoPlusOneTimesTwo\e[0m"
# agda --compile --ghc-flag="-v0" src/Mains/Function/Sequential/TimesTwoPlusOneTimesTwo.agda

# echo -e "\e[31mbuilding Mains.Function.Creational.PlusOne_Add_TimesTwo\e[0m"
# agda --compile --ghc-flag="-v0" src/Mains/Function/Creational/PlusOne_Add_TimesTwo.agda

# echo -e "\e[31mbuilding Mains.Function.Creational.TimesTwo_Add_PlusOne\e[0m"
# agda --compile --ghc-flag="-v0" src/Mains/Function/Creational/TimesTwo_Add_PlusOne.agda

# echo -e "\e[31mbuilding Mains.Function.Creational.Self_Add_PlusOne\e[0m"
# agda --compile --ghc-flag="-v0" src/Mains/Function/Creational/Self_Add_PlusOne.agda

# echo -e "\e[31mbuilding Mains.Function.Creational.Self_Add_PlusOne_WithEnv\e[0m"
# agda --compile --ghc-flag="-v0"  src/Mains/Function/Creational/Self_Add_PlusOne_WithEnv.agda

# echo -e "\e[31mbuilding Mains.Function.Creational.EnvResulting_Self_Add_PlusOne_WithEnv\e[0m"
# agda --compile --ghc-flag="-v0" src/Mains/Function/Creational/EnvResulting_Self_Add_PlusOne_WithEnv.agda

# echo -e "b\e[31muilding Mains.Function.Conditional.Fibonacci\e[0m"
# agda --compile --ghc-flag="-v0" src/Mains/Function/Conditional/Fibonacci.agda

# echo -e "\e[31mbuilding Mains.Function.Conditional.Factorial\e[0m"
# agda --compile --ghc-flag="-v0" src/Mains/Function/Conditional/Factorial.agda

# echo -e "\e[31mbuilding Mains.ComputationValuedFunction.IdTimesTwo_Add_PlusOne\e[0m"
# agda --compile --ghc-flag="-v0" src/Mains/ComputationValuedFunction/IdTimesTwo_Add_PlusOne.agda

echo -e "\e[31mbuilding Mains.IdStateTComputationValuedFunction.FibonacciWithState\e[0m"
agda --compile --ghc-flag="-v0" src/Mains/IdStateTComputationValuedFunction/FibonacciWithState.agda

echo -e "\e[31mbuilding Mains.IdStateTComputationValuedFunction.FibonacciWithStatePair\e[0m"
agda --compile --ghc-flag="-v0" src/Mains/IdStateTComputationValuedFunction/FibonacciWithStatePair.agda