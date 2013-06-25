import Test.Hspec
import Node

main = hspec $ do

    describe "node" $ do

        it "can be created from file" $ do
            node <- nodeFromFile "test_data/nodes/node1"
            header node `shouldBe` "test_data/nodes/node1"

    describe "nodes" $ do

        it "can return all nodes" $ do
            node1 <- nodeFromFile "test_data/nodes/node1"
            node2 <- nodeFromFile "Tests.hs"
            let nodes = nodesFromNodes [node1, node2]
            getTopLevelNodes nodes `shouldBe` [node1, node2]

    describe "selected node" $ do

        it "is the first" $ do
            node1 <- nodeFromFile "test_data/nodes/node1"
            node2 <- nodeFromFile "test_data/nodes/node2"
            let nodes = nodesFromNodes [node1, node2]
            getSelected nodes `shouldBe` node1

        it "can be moved down" $ do
            node1 <- nodeFromFile "test_data/nodes/node1"
            node2 <- nodeFromFile "test_data/nodes/node2"
            let nodes = moveDown (nodesFromNodes [node1, node2])
            getSelected nodes `shouldBe` node2

        it "can be moved up" $ do
            node1 <- nodeFromFile "test_data/nodes/node1"
            node2 <- nodeFromFile "test_data/nodes/node2"
            let nodes = moveUp (moveDown (nodesFromNodes [node1, node2]))
            getSelected nodes `shouldBe` node1
