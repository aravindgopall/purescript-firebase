module Web.Firebase.UnsafeRef
  ( refFor
  ) where

import Control.Monad.Aff
import Control.Monad.Eff.Class (liftEff)
import Data.Either.Unsafe  (fromRight)
import Data.URI (runParseURI)
import qualified Web.Firebase as FB
import qualified Web.Firebase.Types as FBT

-- | Unsafely read a string that might be a reference, and turn it into a firebase reference
-- may throw javascript exceptions, intended to keep test code terse, not meant for production usage
refFor :: String -> forall eff. Aff (firebase :: FBT.FirebaseEff | eff) FBT.Firebase
refFor s = do
  let fbUri = fromRight (runParseURI s)
  liftEff (FB.newFirebase fbUri)