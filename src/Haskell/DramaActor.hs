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
        -- liftIO $ putStrLn $ "\t [Reactor] receives LeftReact (" ++ showVal x ++ ")"
        receive $ \case
          RightReact w -> do
            -- liftIO $ putStrLn $ 
            --   "\t [Reactor] receives RightReact (" ++ showVal w ++ ")" ++ 
            --     " -> combining (" ++ showVal x ++ ", " ++ showVal w ++ ")"
            cont (x, w)
          LeftReact _ -> error "Unexpected duplicate LeftReact"
      RightReact w -> do
        -- liftIO $ putStrLn $ "\t [Reactor] receives RightReact (" ++ showVal w ++ ")"
        receive $ \case
          LeftReact x -> do
            -- liftIO $ putStrLn $ 
            --   "\t [Reactor] receives LeftReact (" ++ showVal x ++ ")" ++
            --     " -> combining (" ++ showVal x ++ ", " ++ showVal w ++ ")"
            cont (x, w)
          RightReact _ -> error "Unexpected duplicate RightReact"

    leftActor :: Address (Message x w) -> Actor (Message x w) ()
    leftActor reactorAddr = do
      z2x z (\x -> do
        -- liftIO $ putStrLn $ 
        --   "\t [LeftActor] finished left branch" ++
        --     " -> sending LeftReact (" ++ showVal x ++ ")"
        cast reactorAddr (LeftReact x))

    rightActor :: Address (Message x w) -> Actor (Message x w) ()
    rightActor reactorAddr = do
      y2w y (\w -> do
        -- liftIO $ putStrLn $
        --   "\t [RightActor] finished right branch" ++
        --     " -> sending RightReact (" ++ showVal w ++ ")"
        cast reactorAddr (RightReact w))
