import Test.Hspec
import Node

main = hspec $ do

    describe "node" $ do

        it "can be created from file" $ do
            node <- nodeFromFile "README.markdown"
            header node `shouldBe` "README.markdown"

    describe "nodes" $ do

        it "can be created from nodes" $ do
            node <- nodeFromFile "README.markdown"
            let nodes = nodesFromNodes [node]
            getSelected nodes `shouldBe` node
