#! /bin/bash

echo "running Mains.Function.Functional.PlusOne"
./src/PlusOne

echo "running Mains.Function.Functorial.PlusOneTimesTwo"
./src/PlusOneTimesTwo

echo "running Mains.Function.Sequential.TimesTwoPlusOne_TimesTwo"
./src/TimesTwoPlusOne_TimesTwo

echo "running Mains.Function.Creational.PlusOne_Add_TimesTwo"
./src/PlusOne_Add_TimesTwo

echo "running Mains.Function.Creational.TimesTwo_Add_PlusOne"
./src/TimesTwo_Add_PlusOne

echo "running Mains.Function.Creational.Self_Add_PlusOne"
./src/Self_Add_PlusOne

echo "running Mains.Function.Creational.Self_Add_PlusOne_WithEnv"
./src/Self_Add_PlusOne_WithEnv

echo "running Mains.Function.Creational.EnvResulting_Self_Add_PlusOne_WithEnv"
./src/EnvResulting_Self_Add_PlusOne_WithEnv

echo "running Mains.Function.Conditional.Fibonacci"
./src/Fibonacci

echo "running Mains.Function.Conditional.Factorial"
./src/Factorial

echo "running Mains.IdComputationValuedFunction.IdTimesTwo_Add_PlusOne"
./src/IdTimesTwo_Add_PlusOne

echo "running Mains.IdStateTComputationValuedFunction.FibonacciWithState"
./src/FibonacciWithState

echo "running Mains.IdStateTComputationValuedFunction.FibonacciWithStatePair"
./src/FibonacciWithStatePair

echo "running Mains.IdContTComputationValuedFunction.FibonacciWithCont"
./src/FibonacciWithCont

echo "running Mains.DramaActorContTComputationValuedFunction.FibonacciWithPar"
./src/FibonacciWithPar