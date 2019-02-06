{-# LANGUAGE OverloadedStrings #-}

------------------------------------------------------------------------------
-- | This module is where all the routes and handlers are defined for your
-- site. The 'app' function is the initializer that combines everything
-- together and is exported by this module.
module Site
  ( app
  ) where

------------------------------------------------------------------------------
import           Data.ByteString (ByteString)
import qualified Data.ByteString as B
import           Data.Monoid
import           Snap.Core
import           Snap.Snaplet
import           Snap.Snaplet.Heist.Interpreted
import           Heist
import           Snap.Util.FileServe
------------------------------------------------------------------------------
import           Application
import           Splices

page :: ByteString -> (ByteString, Handler App App ())
page name = (B.concat ["/", name], method GET $ render name)

routes :: [(ByteString, Handler App App ())]
routes = [ page "small_languages"
         , page "secrets_in_source_control"
         , page "pgp"
         , page "frustrate_them_for_a_lifetime"
         , ("/robots.txt", serveFile "static/robots.txt")
         , ("/",           ifTop $ method GET $ render "index")
         , ("/static",     serveDirectory "static")
         ]

------------------------------------------------------------------------------
-- | The application initializer.
app :: SnapletInit App App
app = makeSnaplet "erincall" "My wubsite" Nothing $ do
    let config = mempty {
        hcInterpretedSplices = do
            "currentPath" ## currentPath
      }
    h <- nestSnaplet "heist" heist $ heistInit "templates"
    addConfig h config
    addRoutes routes
    return $ App h

