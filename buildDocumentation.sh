#! /bin/bash

export PATH="$HOME/.cabal/bin:$PATH"

agda --compile --ghc-flag=-package --ghc-flag=transformers --ghc-flag=-package --ghc-flag=text --ghc-flag=-v0 src/Documentation.lagda.md
