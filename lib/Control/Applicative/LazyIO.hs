module Control.Applicative.LazyIO 
  ( LazyIO 
  , liftLazyIO
  , runLazyIO 
  ) where

import System.IO.Unsafe (unsafeInterleaveIO) 

-- | Internals guarantee work does not repeat across threads (unsafeInterleaveIO) 
newtype LazyIO a = LazyIO { unLazyIO :: IO a } 

instance Functor LazyIO where
  fmap f io = LazyIO $ fmap f (unsafeInterleaveIO $ unLazyIO io) 

instance Applicative LazyIO where
  pure = LazyIO . pure 
  f <*> g = LazyIO $ do
    f' <- unsafeInterleaveIO $ unLazyIO f 
    g' <- unsafeInterleaveIO $ unLazyIO g 
    pure $ f' g'  
  

-- | IO action should be commutative (order independent) 
liftLazyIO :: IO a -> LazyIO a 
liftLazyIO = LazyIO 

runLazyIO :: LazyIO a -> IO a 
runLazyIO = unsafeInterleaveIO . unLazyIO 


