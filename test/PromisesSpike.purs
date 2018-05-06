module Test.PromisesSpike (promisesSpikeSpec) where

import Control.Monad.Aff (Aff)
import Control.Monad.Aff.Compat (EffFnAff(..), fromEffFnAff)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Class (liftEff)
import Prelude (bind, discard, pure, ($), (<<<), (>>=))
import Test.Spec (describe, it)
import Test.Spec.Assertions (shouldEqual)


promisesSpikeSpec = describe "FFI examples" do
  describe "liftEff" do
    it "zero arguments" do
      concat0Lift >>= expectZero
    it "one argument" do
      concat1Lift "one" >>= expectOne
    it "two arguments" do
      concat2Lift "one" "two" >>= expectOneTwo
  where
    expectZero actual = actual `shouldEqual` "zero"
    expectOne actual = actual `shouldEqual` "one"
    expectOneTwo actual = actual `shouldEqual` "onetwo"


runLater = describe  "with promise" do
  -- code from a true story of taming promise chains with purescript by art yerkes on medium
    it "zero arguments" do
      zero <- promiseConcat0
      zero `shouldEqual` "zero"
    it "one argument" do
      one <- promiseConcat1 "one"
      one `shouldEqual` "one"
    it "two argments" do
      concatenated <- promiseConcat2 "promised" "miracle"
      concatenated `shouldEqual` "promisedmiracle"

foreign import promiseConcat0Impl :: forall eff. EffFnAff (eff) String

promiseConcat0 :: forall eff. Aff eff String
promiseConcat0 = fromEffFnAff promiseConcat0Impl

foreign import concat0LiftImpl :: forall eff. Eff (eff) String

concat0Lift :: forall eff. Aff eff String
concat0Lift = liftEff concat0LiftImpl

foreign import concat1LiftImpl :: forall eff. String -> Eff (eff) String

concat1Lift :: forall eff. String -> Aff eff String
concat1Lift = liftEff <<< concat1LiftImpl

foreign import concat2LiftImpl :: forall eff. String -> String -> Eff (eff) String

concat2Lift :: forall eff. String -> String -> Aff eff String
concat2Lift one two = liftEff $ concat2LiftImpl one two

promiseConcat1 l = pure ""
promiseConcat2 l r = pure ""