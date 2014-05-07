{-# LANGUAGE OverloadedStrings #-}

module Site.OpenIDAuth (oidRoutes) where

import qualified Data.ByteString      as B
import qualified Data.ByteString.UTF8 as B
import           Data.List            (isPrefixOf)
import           Data.Maybe           (fromMaybe)
import           Network.HTTP         (urlEncode)
import           Network.URI          (URI(..), parseURI)
import           Snap.Snaplet         (Handler)
import           Snap.Core ( modifyResponse
                           , getParam
                           , redirect
                           , setResponseStatus
                           )

import           Application (App)

oidRoutes :: [(B.ByteString, Handler App App ())]
oidRoutes = [ ("/authorize", authorize)]

authorize :: Handler App App ()
authorize = do
    mRedirectURI <- fmap (>>= (parseURI . B.toString)) (getParam "redirect_uri")
    case mRedirectURI of
      Nothing -> modifyResponse $ setResponseStatus 400 "Bad Request"
      Just uri -> do
        responseType <- getParam' "response_type" uri
        scope <- getParam' "scope" uri
        client_id <- getParam' "client_id" uri
        state <- fmap (fromMaybe "") $ getParam "state"
        redirect $ toBS $ addParam "code" "superpowered" uri
  where
    getParam' :: B.ByteString -> URI -> Handler App App B.ByteString
    getParam' p uri = (getParam p) >>= maybe (err p uri) return
    err p uri = redirect $ toBS $ addParam "error" "invalid_request" $
                                  addParam "error_description" (reqd p) uri
    reqd p = "param '" ++ (B.toString p) ++ "' is required"


----------------------------------------------------------------------
--Convenience functions on URLS that should maybe be in another module
----------------------------------------------------------------------

toBS :: URI -> B.ByteString
toBS = B.fromString . show

addParam :: String -> String -> URI -> URI
addParam k v u | hasParams = u {uriQuery = (uriQuery u) ++ "&" ++ param}
               | otherwise = u {uriQuery = "?" ++ param}
  where
    hasParams = isPrefixOf "?" $ uriQuery u
    param = (urlEncode k) ++ "=" ++ (urlEncode v)
