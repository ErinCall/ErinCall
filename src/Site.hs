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
import           Snap.Core
import           Snap.Snaplet
import           Snap.Snaplet.Heist
import           Snap.Util.FileServe
------------------------------------------------------------------------------
import           Application

resume :: Handler App App ()
resume = method GET $ render "resume"

routes :: [(ByteString, Handler App App ())]
routes = [ ("/resume",   resume)
         , ("",          serveDirectory "static")
         ]


------------------------------------------------------------------------------
-- | The application initializer.
app :: SnapletInit App App
app = makeSnaplet "andrewlorente" "My wubsite" Nothing $ do
    h <- nestSnaplet "" heist $ heistInit "templates"
    addRoutes routes
    return $ App h

