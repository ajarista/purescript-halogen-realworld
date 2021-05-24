module Component.Lazy where

import Conduit.Capability.Navigate (class Navigate)
import Conduit.Capability.Resource.Article (class ManageArticle)
import Conduit.Capability.Resource.Tag (class ManageTag)
import Conduit.Page.Home as Home
import Conduit.Store as Store
import Control.Applicative (pure)
import Control.Bind (bind, discard)
import Data.Unit (Unit)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Aff.Class (class MonadAff)
import Effect.Aff.Compat (EffectFnAff, fromEffectFnAff)
import Effect.Class (liftEffect)
import Halogen as H
import Halogen.Aff.Driver.State (initDriverState)
import Halogen.Store.Monad (class MonadStore)

-- import Halogen.Store.Monad (class MonadStore)

foreign import clog :: forall x. x -> Effect Unit
foreign import debug :: Effect Unit

foreign import importHome_ :: forall q o m. EffectFnAff {component :: H.Component q Unit o m}

importHome
  :: forall q o m
   . MonadAff m
  => MonadStore Store.Action Store.Store m
  => Navigate m
  => ManageTag m
  => ManageArticle m
  => Aff {component :: H.Component q Unit o m}
importHome = do
  home <- fromEffectFnAff importHome_
  liftEffect (clog home)
  -- liftEffect debug
  pure home

-- initDriverState

-- importHome :: forall q o m. Aff {component :: H.Component q Unit o m}
-- importHome = fromEffectFnAff importHome_

-- importHome :: forall q o m. Aff {component :: H.Component q Unit o m}
-- importHome = pure {component: Home.component}
