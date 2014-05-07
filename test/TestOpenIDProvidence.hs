{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -fno-warn-missing-signatures #-}

module TestOpenIDProvidence (testGroups) where

import           Control.Monad.IO.Class         (liftIO)
import           Control.Exception              (finally)
import qualified Data.ByteString.Char8          as B
import qualified Data.Map                       as M
import           Snap.Core                      (rspStatus, Snap)
import           Snap.Snaplet                   (runSnaplet)
import           Test.Framework                 (testGroup)
import           Test.Framework.Providers.HUnit (testCase)
import           Test.HUnit.Base                (assertEqual)
import           Snap.Test ( runHandler
                           , get
                           , assertRedirectTo
                           )

import           Site                           (app)

testGroups = [
    testGroup "OpenID authorization actions"
      [ testCase "redirect_uri is required" test_redirect_uri_required
      , testCase "response_type is required" test_response_type_required
      , testCase "successful code acquisition" test_successful_code_acquisition
      ]
  ]

test_redirect_uri_required = withSite $ \s -> do
  response <- runHandler (get "/authorize" M.empty) s
  let message = "Expected HTTP 400 but got " ++ (show status)
      status = rspStatus response
  assertEqual message 400 status

test_response_type_required = withSite $ \s -> do
  let params = M.fromList [("redirect_uri", ["http://example.com"])]
  response <- runHandler (get "/authorize" params) s
  assertRedirectTo (B.pack $ "http://example.com?error_description=" ++
                             "param%20%27response_type%27%20is%20required&" ++
                             "error=invalid_request") response

test_successful_code_acquisition = withSite $ \s -> do
  let params = M.fromList [ ("redirect_uri", ["http://example.com/cb"])
                          , ("response_type", ["code"])
                          , ("scope", ["openid"])
                          , ("client_id", ["xbaby"])
                          ]
  response <- runHandler (get "/authorize" params) s
  assertRedirectTo (B.pack "http://example.com/cb?code=superpowered") response

withSite :: (Snap () -> IO b) -> IO b
withSite action = do
  (_, s, tearDown) <- runSnaplet Nothing app
  flip finally (liftIO tearDown) $ action s
