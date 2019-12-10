module Main where

import           Options.Applicative
import           Workspace.Organizer (someFunc)

data Options = Options
  { filename :: String
  }

main :: IO ()
main = do
  opts <- parseCLI
  someFunc $ filename opts

parseCLI :: IO Options
parseCLI = execParser
            ( info (helper <*> parseOptions)
              (header "Visual Studio Code Workspace Organizer")
            )

parseOptions :: Parser Options
parseOptions =
  Options <$> ( argument str
                (metavar "filename" <> help "vscode workspace file")
              )
