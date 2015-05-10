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
import           Data.Monoid
import           Snap.Core
import           Snap.Snaplet
import           Snap.Snaplet.Heist.Interpreted
import           Heist
import           Snap.Util.FileServe
------------------------------------------------------------------------------
import           Application
import           Splices

page :: ByteString -> Handler App App ()
page template = method GET $ render template

routes :: [(ByteString, Handler App App ())]
routes = [ ("/resume",                    page "resume")
         , ("/small_languages",           page "small_languages")
         , ("/secrets_in_source_control", page "secrets_in_source_control")
         , ("/pgp",                       page "pgp")
         , ("/about_transgender",         page "about_transgender")
         , ("/robots.txt",                serveFile "static/robots.txt")
         , ("/",                          ifTop $ page "index")
         , ("/static",                    serveDirectory "static")
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

