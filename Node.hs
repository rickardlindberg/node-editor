module Node where

data Nodes = Nodes
    { selected :: String
    , children :: [Node]
    }

data Node = Node
    { header :: String
    , body   :: String
    } deriving (Show, Eq)

getSelected :: Nodes -> Node
getSelected (Nodes _ [x]) = x

updateBody :: String -> Nodes -> Nodes
updateBody newBody (Nodes x [Node header _]) = Nodes x [Node header newBody]

nodeFromFile :: FilePath -> IO Node
nodeFromFile path = do
    body <- readFile path
    return $ Node path body

nodesFromNodes :: [Node] -> Nodes
nodesFromNodes nodes@(Node { header = header}:_) = Nodes header nodes
