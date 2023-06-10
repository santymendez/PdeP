module Spec where
import PdePreludat
import Test.Hspec

correrTests :: IO ()
correrTests = hspec $ do
    describe "prueba" $ do
        it "prueba" $ do
            2 * 2 `shouldBe` 4