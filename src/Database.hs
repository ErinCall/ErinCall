{-# LANGUAGE OverloadedStrings #-}

module Database where

import           System.Environment (getEnvironment)
import qualified Data.Map           as M
import           Data.Maybe         (fromMaybe)

databaseUrl :: IO String
databaseUrl = do
  env <- getEnvironment
  return $ databaseUrl' $ M.fromList env

databaseUrl' :: M.Map String String -> String
databaseUrl' env = fromMaybe bestGuess envVar
  where
    envVar = M.lookup "DATABASE_URL" env
    bestGuess = "postgresql://" ++ whoami ++ "@localhost/andrewlorente"
    whoami = fromMaybe "andrewlorente" $ M.lookup "USER" env
