{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -fno-warn-missing-signatures #-}

module TestDatabase (testGroups) where

import           Test.Framework                 (testGroup)
import           Test.Framework.Providers.HUnit (testCase)
import           Test.HUnit.Base                (assertEqual)
import qualified Data.Map                       as M

import Database (databaseUrl')

testGroups = [
    testGroup "figure out database url"
      [ testCase "when it is present in the environment" test_get_from_env
      , testCase "make an inference from $USER" test_infer_from_user
      , testCase "when env is empty" test_with_empty_env
      ]
  ]

test_get_from_env = do
  let env = M.fromList [("DATABASE_URL", "anythingatall")]
      url = databaseUrl' env
  assertEqual "database url wasn't read from the environment"
              "anythingatall"
              url

test_infer_from_user = do
  let env = M.fromList [("USER", "charles")]
      url = databaseUrl' env
  assertEqual "database url wasn't inferred"
              "postgresql://charles@localhost/andrewlorente"
              url

test_with_empty_env = do
  let url = databaseUrl' M.empty
  assertEqual "database url wasn't guessed"
              "postgresql://andrewlorente@localhost/andrewlorente"
              url
