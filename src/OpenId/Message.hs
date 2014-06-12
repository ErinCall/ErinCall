{-# LANGUAGE OverloadedStrings #-}

module OpenId.Message
( Message(..)
, fromPostArgs
) where

import qualified Data.Bimap      as Bimap
import qualified Data.ByteString as B
import qualified Data.Map.Lazy   as Map
import           Network.URI     (URI)
import           Snap.Core       (Params)

type Alias = B.ByteString
type NamespaceMap = Bimap.Bimap Namespace Alias

data Namespace = Namespace B.ByteString
               | BareNS
               | NullNS
  deriving (Eq, Ord, Show)

data Message = Message {
    namespaces :: NamespaceMap
  , openidNsUri :: Maybe URI
  , args        :: Map.Map (Namespace, B.ByteString) B.ByteString
  }

fromPostArgs :: Params -> Message
fromPostArgs params = oidMessage {args = allArgs}
  where
    allArgs = union otherParams $ args oidMessage
    oidMessage= fromOpenIdArgs openIdParams
    openIdParams = Map.mapKeys (B.drop $ length "openid.") openIdParams'
    otherParams = Map.mapKeys (BareNS, ) openIdParams'
    (openIdParams', otherParams') = Map.partitionWithKey
        (\k, _ -> "openid." `B.isPrefixOf` k) $
        Map.map head params

fromOpenIdArgs :: Params -> Message
fromOpenIdArgs params = Message {
    args = otherArgs
  , namespaces = Bimap.fromList $ Map.toList namespaces
  , openidNsUri = head <$> Map.lookup "ns" params
  }
  where
    namespaces = Map.mapKeys (B.drop $ length "ns.") namespaces'
    otherArgs = Map.mapKeys (\k -> (fromJust $ Map.lookup (fst $ aliasAndKey k) namespaces, snd $ aliasAndKey k)) otherArgs'
    -- ^^^ This fromJust is unsafe, so
    --     a) exceptions are possible and
    --     b) we don't support OpenID 1.x
    (namespaces', otherArgs') = Map.partitionWithKey
      (\k, _ -> fst (aliasAndKey k) == "ns") $
      Map.map head params
    aliasAndKey param = case B.breakSubstring "." param of
      (wholeThing, "") -> (NullNS, wholeThing)
      (alias, key) -> (alias, key)

toPostArgs :: Message -> [(B.ByteString, B.ByteString)]
toPostArgs Message {namespaces=names, args=arguments} =
    namespacesAsArgs ++ argsAsArgs
  where
    namespacesAsArgs = Bimap.fold (\uri alias -> (:) (argKey alias, uri))
                                  [] names
    argKey (Namespace alias) =  "openid.ns." `B.append` alias
    argKey _ = "openid.ns"

    argsAsArgs = Map.foldr (\param value -> (:) (getKey param, value)) [] arguments

    getKey (BareNS, key) = key
    getKey (NullNS, key) = "openid." `B.append` key
    getKey (Namespace name, key) = "openid." `B.append`
                                   (getAlias name) `B.append`
                                   key
    getAlias name = fromJust $ Bimap.lookup name names

toArgs :: Message -> [(B.ByteString, B.ByteString)]
toArgs = map noBares . toPostArgs
  where
    noBares (key, value) | not "openid." `B.isPrefixOf` key = error "oh no"
                         | otherwise = (B.drop prefixLength key, value)
    prefixLength = B.length "openid."
