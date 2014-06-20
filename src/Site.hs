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

resume :: Handler App App ()
resume = method GET $ render "resume"

index :: Handler App App ()
index = method GET $ render "index"

smallLanguages :: Handler App App ()
smallLanguages = method GET $ render "small_languages"

pgp :: Handler App App ()
pgp = method GET $ render "pgp"

routes :: [(ByteString, Handler App App ())]
routes = [ ("/resume",          resume)
         , ("/small_languages", smallLanguages)
         , ("/pgp",             pgp)
         , ("/robots.txt",      serveFile "static/robots.txt")
         , ("/",                ifTop index)
         , ("/static",          serveDirectory "static")
         ]

------------------------------------------------------------------------------
-- | The application initializer.
app :: SnapletInit App App
app = makeSnaplet "andrewlorente" "My wubsite" Nothing $ do
    let config = mempty {
        hcInterpretedSplices = do
            "currentPath" ## currentPath
      }
    h <- nestSnaplet "heist" heist $ heistInit "templates"
    addConfig h config
    addRoutes routes
    return $ App h

