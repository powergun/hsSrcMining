module Main where

import qualified Control.Monad        as M
import qualified Control.Monad.Writer as W
import           Data.List
import           System.Environment   (getArgs)
import qualified Walk

-- (_, r) <- W.runWriterT (walkM "..")
-- display r

-- CA infra
-- (_, r2) <- W.runWriterT (walkM "/Users/weining/work/canva/infrastructure")
-- display r2

-- CA main
-- (_, r3) <- W.runWriterT (Walk.walkM "/Users/weining/work/canva/canva")
-- display r3

-- traverse the source tree and collect the contents

-- main :: IO ()
-- main = do
--   args <- getArgs
--   M.when (length args /= 1) $ do
--     putStrLn "Usage: prog <filename>"
--     error "Incorrect args."
--   (_, r) <- W.runWriterT (Walk.walkM (head args))
--   Walk.display r

-- use git ls-files as a shortcut to avoid the traversal step
-- git ls-files | <program>
main :: IO ()
main = do
  (_, r) <- W.runWriterT . Walk.analysis . lines =<< getContents
  Walk.display r
