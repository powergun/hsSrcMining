module Walk
  ( walkM
  , display
  , analysis
  ) where

import           Control.Monad         (forM, forM_)
import qualified Control.Monad.Writer  as W
import qualified Data.ByteString       as B
import qualified Data.ByteString.Char8 as BC
import           Data.List             (isSuffixOf, sortBy)
import qualified Data.Map              as M
import qualified Data.Text             as T
import           System.Directory      (doesDirectoryExist,
                                        getDirectoryContents,
                                        pathIsSymbolicLink)
import           System.FilePath       ((</>))
import           System.FilePath.Posix (takeExtension)
import           System.Posix.Files    (getSymbolicLinkStatus)

-- the basic skeleton of a static analysis tool

readFileSafe :: FilePath -> IO String
readFileSafe pth = do
  bytes <- B.readFile pth
  return $ BC.unpack bytes

preFilter :: (FilePath, FilePath) -> Bool
preFilter (pth, baseName)
  | head baseName == '.' = False
  -- | takeExtension baseName == "" = False
  | baseName `elem` [".", "..", ".git", ".terraform"] = False
  | otherwise = True

getRecursiveContents :: FilePath -> IO [FilePath]
getRecursiveContents topDir = do
  names <- getDirectoryContents topDir
  let pathAndNames = map (\n -> (topDir </> n, n)) names
  paths <- forM (filter preFilter pathAndNames) $ \(pth, name) -> do
    let path = topDir </> name
    isSymlink <- pathIsSymbolicLink pth
    isDirectory <- doesDirectoryExist path
    if isDirectory
      then getRecursiveContents path
      else
        if isSymlink
          then return []
          else return [path]
  return (concat paths)

analysis :: [FilePath] -> W.WriterT WalkResult IO ()
analysis [] = return ()
analysis (pth:pths) = do
  let ext = takeExtension pth
  contents <- W.lift (readFileSafe pth)
  W.tell $ WalkResult $ M.fromList [(ext, (length . lines) contents)]
  analysis pths

walkM :: FilePath -> W.WriterT WalkResult IO ()
walkM topDir = do
  pths <- W.lift $ getRecursiveContents topDir
  analysis pths

newtype WalkResult = WalkResult (M.Map String Int)
                     deriving (Show)
emptyResult = WalkResult M.empty
instance Semigroup WalkResult where
  (<>) = mappend
instance Monoid WalkResult where
  mempty = emptyResult
  mappend (WalkResult m1) (WalkResult m2) =
    WalkResult (M.unionWith (+) m1 m2)

display :: WalkResult -> IO ()
display (WalkResult m) = do
  let sorted = sortBy (\(k1, v1) (k2, v2) -> v2 `compare` v1) $ M.toList m
  forM_ sorted $ \(k, v) -> do
    let vStr = T.pack (show v)
        pStr = T.unpack (T.justifyRight 10 ' ' vStr)
    putStrLn $ pStr ++ "  " ++ k
