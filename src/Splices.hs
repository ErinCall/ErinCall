
module Splices where

import           Control.Monad.Trans.Class    (lift)
import           Heist.Compiled               as C
import           Snap.Core
import           Data.Text.Encoding           (decodeUtf8)
import           Data.ByteString              (append)
import           Text.XHtmlCombinators.Escape (escape)

currentPath :: MonadSnap m => C.Splice m
currentPath = return $ C.yieldRuntimeText $ do
  requestPath <- lift $ withRequest $ \request -> do
    let url  = rqURI request
        host = rqServerName request
    return (host `append` url)
  return $ escape $ decodeUtf8 $ urlEncode requestPath
