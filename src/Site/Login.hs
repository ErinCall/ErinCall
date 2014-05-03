{-# LANGUAGE OverloadedStrings #-}

module Site.Login
    ( doLogin
    , showLogin
    , logout
    ) where

import           Prelude                        hiding (lookup)
import qualified Data.ByteString                as B
import           Data.Digest.BCrypt             (bcrypt, packBSalt)
import           Data.Maybe                     (isJust, fromJust)
import qualified Data.Text                      as T
import           Heist                          ((##))
import           Heist.SpliceAPI                (Splices)
import qualified Heist.Interpreted              as I
import           Snap.Core                      (method, Method(..), getParam, redirect)
import           Snap.Snaplet                   (Handler, with)
import           Snap.Snaplet.Heist.Interpreted (render, renderWithSplices)
import           Snap.Snaplet.Session           (commitSession, setInSession, getFromSession, deleteFromSession)

import           Application

showLogin :: Handler App App ()
showLogin = method GET $ do
    identity <- with sess $ getFromSession "identity"
    if isJust identity
        then render "logged_in"
        else render "login"

doLogin :: Handler App App ()
doLogin = method POST $ do
    mPassphrase <- getParam "passphrase"
    case mPassphrase of
        Just passphrase | check passphrase -> do
                            with sess $ setInSession "identity" "Andrew"
                            with sess $ commitSession
                            redirect "/login"
                        | otherwise -> renderWithSplices "login" $ errorSplice "Passphrase wasn't correct."
        _ -> renderWithSplices "login" $ errorSplice "Passphrase is required."
  where
    check passphrase = bcrypt passphrase salt == myHashedPassword
    salt = fromJust $ packBSalt myHashedPassword

logout :: Handler App App ()
logout = method GET $ do
    with sess $ deleteFromSession "identity"
    with sess $ commitSession
    renderWithSplices "login" $ infoSplice "Good bye. Hope to see you again soon."

errorSplice :: Monad n => T.Text -> Splices (I.Splice n)
errorSplice msg = "error" ## I.callTemplate "_error" ("error" ## I.textSplice msg)

infoSplice :: Monad n => T.Text -> Splices (I.Splice n)
infoSplice msg = "info" ## I.callTemplate "_info" ("info" ## I.textSplice msg)

myHashedPassword :: B.ByteString
myHashedPassword = "$2a$10$XcUFtgOUkAAZdNH7tkcMqOwE6Mrn00dcVHcqVxUCEHgO683ygxEsC"
