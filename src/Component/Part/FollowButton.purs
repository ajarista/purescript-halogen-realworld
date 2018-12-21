module Conduit.Component.Part.FollowButton 
  ( followButton
  , follow
  , unfollow
  ) where

import Prelude

import Conduit.Capability.LogMessages (class LogMessages, logError)
import Conduit.Capability.ManageResource (class ManageAuthResource, followUser, unfollowUser)
import Conduit.Component.HTML.Utils (css)
import Conduit.Data.Author (Author, isFollowed)
import Conduit.Data.Author as Author
import Conduit.Data.Username (Username)
import Conduit.Data.Username as Username
import Data.Either (Either(..))
import Data.Foldable (for_)
import Data.Lens (Traversal', preview, set)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE

-- Our follow button will have behavior that depends on the author we are interacting
-- with. Since the author's type already includes information about whether we
-- follow this author, we can use that to control the behavior of this HTML with
-- the author type and some embedded queries alone.

followButton 
  :: forall i p
   . H.Action p
  -> H.Action p
  -> Author 
  -> HH.HTML i (p Unit)
followButton followQuery unfollowQuery author = case author of
  Author.Following _ -> 
    HH.button
      [ css "btn btn-sm action-btn btn-secondary" 
      , HE.onClick $ HE.input_ unfollowQuery
      ]
      [ HH.text $ " Unfollow " <> Username.toString (Author.username author) ]
  Author.NotFollowing _ -> 
    HH.button
      [ css "btn btn-sm action-btn btn-outline-secondary" 
      , HE.onClick $ HE.input_ followQuery
      ]
      [ HH.i 
        [ css "ion-plus-round"]
        []
      , HH.text $ " Follow " <> Username.toString (Author.username author)
      ]
  Author.You _ -> HH.text ""


-- In addition to this pure HTML renderer, however, we'd also like to supply the logic 
-- that will work with the queries we've embedded. These two functions will take care
-- of everything we need in `eval` for a component which loads an author and then
-- performs follow / unfollow actions on it.
--
-- In most cases I don't make assumptions about what is in state nor modify it, but 
-- in this case I'm willing to adopt the convention that somewhere in state is an
-- author that can be modified.
--
-- The following two functions will handle safely making the request, logging errors,
-- and updating state with the result.

follow  
  :: forall s f g p o m
   . ManageAuthResource m
  => LogMessages m
  => Traversal' s Author
  -> H.HalogenM s f g p o m Unit
follow _author = act (not <<< isFollowed) followUser _author

unfollow  
  :: forall s f g p o m
   . ManageAuthResource m
  => LogMessages m
  => Traversal' s Author
  -> H.HalogenM s f g p o m Unit
unfollow _author = act isFollowed unfollowUser _author

-- This will be kept internal.

act  
  :: forall s f g p o m
   . ManageAuthResource m
  => LogMessages m
  => (Author -> Boolean)
  -> (Username -> m (Either String Author))
  -> Traversal' s Author
  -> H.HalogenM s f g p o m Unit
act cond f _author = do
  st <- H.get
  for_ (preview _author st) \author -> do
    when (cond author) do
      new <- H.lift $ f (Author.username author)
      case new of
        Left str -> logError str
        Right newAuthor -> 
          H.modify_ (set _author newAuthor)
