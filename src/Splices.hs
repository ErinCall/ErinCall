
module Splices where

import           Control.Monad.Trans.Class (lift)
import           Heist.Interpreted         as I
import           Snap.Core
import           Data.ByteString           (append)
import qualified Data.Text.Encoding        as T

currentPath :: MonadSnap n => I.Splice n
currentPath = do
  requestPath <- lift $ withRequest $ \request -> do
    let url  = rqURI request
        host = rqServerName request
    return (host `append` url)
  I.textSplice $ T.decodeUtf8 $ urlEncode requestPath
