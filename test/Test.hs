{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}

module Main
    where

import Test.Framework (defaultMain, Test)

import TestOpenIDProvidence as OID
import TestDatabase         as DB

main :: IO ()
main = defaultMain tests

tests :: [Test]
tests = OID.testGroups
     ++ DB.testGroups
