module Node where

import Control.Monad
import Data.List
import System.Directory

data Nodes = Nodes
    { selected :: String
    , children :: [Node]
    }

data Node = Node
    { header :: String
    , body   :: String
    } deriving (Show, Eq)

getSelected :: Nodes -> Node
getSelected (Nodes selected nodes) = find nodes
    where
        find (x:xs) = if header x == selected
                          then x
                          else find xs

updateBody :: String -> Nodes -> Nodes
updateBody newBody (Nodes selected nodes) = Nodes selected newNodes
    where
        newNodes = map (\node -> if header node == selected then Node selected newBody else node) nodes

nodeFromFile :: FilePath -> IO Node
nodeFromFile path = do
    body <- readFile path
    return $ Node path body

nodesFromDir :: FilePath -> IO Nodes
nodesFromDir path = do
    paths <- getDirectoryContents path
    let fullPaths = map (\x -> path ++ x) paths
    filePaths <- filterM doesFileExist fullPaths
    nodes <- mapM nodeFromFile (sort filePaths)
    return $ nodesFromNodes nodes

nodesFromNodes :: [Node] -> Nodes
nodesFromNodes nodes@(Node { header = header}:_) = Nodes header nodes

getTopLevelNodes :: Nodes -> [Node]
getTopLevelNodes (Nodes _ topLevelNodes) = topLevelNodes

moveDown :: Nodes -> Nodes
moveDown (Nodes selected children) = Nodes (newSelected children) children
    where
        newSelected :: [Node] -> String
        newSelected (node:nodes) = if header node == selected
                                     then header (head nodes)
                                     else newSelected nodes

moveUp :: Nodes -> Nodes
moveUp (Nodes selected children) = Nodes (newSelected children) children
    where
        newSelected :: [Node] -> String
        newSelected (x:y:rest) = if header y == selected
                                   then header x
                                   else newSelected (y:rest)
