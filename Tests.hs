import Test.Hspec
import Node

main = hspec $ do

    describe "node" $ do

        it "can be created from file" $ do
            node <- nodeFromFile "test_data/nodes/node1"
            header node `shouldBe` "test_data/nodes/node1"

    describe "nodes" $ do

        it "can be created from nodes" $ do
            node <- nodeFromFile "test_data/nodes/node1"
            let nodes = nodesFromNodes [node]
            getSelected nodes `shouldBe` node

        it "can return all nodes" $ do
            node1 <- nodeFromFile "test_data/nodes/node1"
            node2 <- nodeFromFile "Tests.hs"
            let nodes = nodesFromNodes [node1, node2]
            getTopLevelNodes nodes `shouldBe` [node1, node2]
