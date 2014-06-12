{-# LANGUAGE OverloadedStrings #-}

module Site.OpenId where

import           OpenId.Message (Message)
--import           Snap.Snaplet   (Handler, with)
--import           Application

--someHandler :: Handler App App ()

class OpenIDRequest a where
  mode :: a -> String
  requiredFields :: a -> [String]
  fromMessage :: Message -> a

data CheckAuthRequest = CheckAuthRequest {
    assocHandle      :: String -- Text? ByteString?
  , signed           :: Message
  , invalidateHandle :: Maybe String
  , namespace        :: String
  }

instance OpenIDRequest CheckAuthRequest where
  mode _ = "check_authentication"

  requiredFields _ = ["identity", "return_to", "response_nonce"]

  fromMessage message = CheckAuthRequest {
    signed = message
  , namespace = (mNamespace message)
  , assocHandle =
  }
