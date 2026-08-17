module Utilities.ComputationValuedFunction where

computationValuedFunction : (Set → Set) → Set → Set → Set
computationValuedFunction M Z Y = Z → M Y