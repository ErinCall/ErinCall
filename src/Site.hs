{-# LANGUAGE OverloadedStrings #-}

------------------------------------------------------------------------------
-- | This module is where all the routes and handlers are defined for your
-- site. The 'app' function is the initializer that combines everything
-- together and is exported by this module.
module Site
  ( app
  ) where

------------------------------------------------------------------------------
import           Control.Lens (set)
import           Data.ByteString (ByteString)
import qualified Data.ByteString as B
import           Snap.Core
import           Snap.Snaplet
import           Snap.Snaplet.Heist.Interpreted
import           Heist
import           Snap.Util.FileServe
------------------------------------------------------------------------------
import           Application
import           Splices

heistConfig :: SpliceConfig (Handler App App)
heistConfig =
  set scInterpretedSplices ("currentPath" ## currentPath) $
  set scInterpretedSplices defaultInterpretedSplices $
  mempty

page :: ByteString -> (ByteString, Handler App App ())
page name = (B.concat ["/", name], method GET $ render name)

routes :: [(ByteString, Handler App App ())]
routes = [ page "resume"
         , page "small_languages"
         , page "secrets_in_source_control"
         , page "pgp"
         , page "about_transgender"
         , page "frustrate_them_for_a_lifetime"
         , ("/robots.txt", serveFile "static/robots.txt")
         , ("/",           ifTop $ method GET $ render "index")
         , ("/static",     serveDirectory "static")
         ]

------------------------------------------------------------------------------
-- | The application initializer.
app :: SnapletInit App App
app = makeSnaplet "erincall" "My wubsite" Nothing $ do
    h <- nestSnaplet "heist" heist $ heistInit "templates"
    addConfig h heistConfig
    addRoutes routes
    return $ App h

