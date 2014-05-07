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
import           Snap.Extras.CSRF (secureForm)
import           Snap.Snaplet
import           Snap.Snaplet.Heist.Interpreted
import           Snap.Snaplet.Session (csrfToken)
import           Snap.Snaplet.Session.Backends.CookieSession (initCookieSessionManager)
import           Heist
import           Snap.Util.FileServe
------------------------------------------------------------------------------
import           Application
import           Site.Login (showLogin, doLogin, logout)
import           Splices

resume :: Handler App App ()
resume = method GET $ render "resume"

index :: Handler App App ()
index = method GET $ render "index"

smallLanguages :: Handler App App ()
smallLanguages = method GET $ render "small_languages"

routes :: [(ByteString, Handler App App ())]
routes = [ ("/resume",          resume)
         , ("/small_languages", smallLanguages)
         , ("/robots.txt",      serveFile "static/robots.txt")
         , ("/login",           showLogin)
         , ("/login",           doLogin)
         , ("/logout",          logout)
         , ("/",                ifTop index)
         , ("/static",          serveDirectory "static")
         ]

------------------------------------------------------------------------------
-- | The application initializer.
app :: SnapletInit App App
app = makeSnaplet "andrewlorente" "My wubsite" Nothing $ do
    s <- nestSnaplet "sess" sess $
            initCookieSessionManager "session_key.txt" "session" (Just (60 * 60 * 24))
    let config = mempty {
        hcInterpretedSplices = do
            "currentPath" ## currentPath
            "form" ## (secureForm $ with sess csrfToken)
      }
    h <- nestSnaplet "heist" heist $ heistInit "templates"
    addConfig h config
    addRoutes routes
    return $ App h s

