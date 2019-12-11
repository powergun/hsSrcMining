{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}

module Workspace.Organizer
  ( someFunc
  )
where

import           Data.Aeson
import qualified Data.Aeson.Encode.Pretty      as JP
import qualified Data.HashMap.Strict           as HM
import qualified Data.ByteString.Lazy          as B
import qualified Data.List                     as Ls
import qualified Data.Ord                      as O
import           Data.Maybe
import           Data.Text
import           GHC.Generics
import qualified System.FilePath.Posix         as Sys

data ProjectDir = ProjectDir
  { path :: String
  } deriving (Generic, Show, Ord, Eq)

data Workspace = Workspace
  { folders  :: [ProjectDir]
  , settings :: Value
  } deriving (Generic, Show)

instance ToJSON ProjectDir
instance FromJSON ProjectDir
instance ToJSON Workspace
instance FromJSON Workspace where
  parseJSON (Object v) = do
    folders_  <- v .: "folders"
    settings_ <- v .:? "settings"
    let settings_' = fromMaybe (Object HM.empty) settings_
    return $ Workspace folders_ settings_'

someFunc :: FilePath -> IO ()
someFunc filename = do
  s <- B.readFile filename
  let result = (decode s) :: Maybe Workspace
      conf   = JP.defConfig { JP.confIndent = JP.Spaces 2 }
  case result of
    Just ws ->
      B.writeFile filename $ JP.encodePretty' conf (updateProjectDirs ws)
    _ -> error $ "failed to parse the workspace file:\n" ++ filename

sortByBaseName :: [ProjectDir] -> [ProjectDir]
sortByBaseName = Ls.sortBy
  (\l r -> O.compare (Sys.takeBaseName . path $ l) (Sys.takeBaseName . path $ r)
  )

updateProjectDirs :: Workspace -> Workspace
updateProjectDirs ws =
  let flds = sortByBaseName $ folders ws in Workspace flds (settings ws)
