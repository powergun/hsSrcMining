{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}

module Workspace.Organizer
    ( someFunc
    )
where

import           Prelude.Compat

import           Control.Applicative            ( empty )
import           Data.Aeson

someFunc :: IO ()
someFunc = do
    let req = decode "{ \"foo\": false, \"bar\": [1, 2, 3] }" :: Maybe Value
    print req
    let r = encode req
    print r

