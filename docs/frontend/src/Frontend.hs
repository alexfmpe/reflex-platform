{-# LANGUAGE DataKinds #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE RecursiveDo #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TypeFamilies #-}
module Frontend where

import qualified Data.Text as T
import Reflex.Dom.Core

import Common.Api
import Static

frontend :: (StaticWidget x (), Widget x ())
frontend = (head', body)
  where
    head' = el "title" $ text "Obelisk Minimal Example"
    body = do
      text "Welcome to Obelisk!"
      el "p" $ text $ T.pack commonStuff
      elAttr "img" ("src" =: static @"obelisk.jpg") blank

elm1 :: MonadWidget t m => m ()
elm1 = tea $ Program { _model = model, _view = view, _update = update }

data Program t m = Program
  { _model  :: Model
  , _view   :: Model -> m (Event t Msg)
  , _update :: Msg -> Model -> Model
  }

tea :: MonadWidget t m => Program t m -> m ()
tea Program {..} = mdo
  dynModel :: Dynamic t Model <- foldDyn _update _model evMsg
  evView :: Event t (Event t Msg) <- dyn $ fmap view dynModel
  evMsg :: Event t Msg <- switchHold never evView
  blank

-- https://guide.elm-lang.org/architecture/user_input/buttons.html
type Model = Int

model :: Model
model = 0

data Msg = Increment | Decrement

update :: Msg -> Model -> Model
update = \case
  Increment -> succ
  Decrement -> pred

view :: MonadWidget t m => Model -> m (Event t Msg)
view model = el "div" $ do
  dec <- button "-"
  el "div" $ text $ T.pack $ show $ model
  inc <- button "+"
  pure $ leftmost [Decrement <$ dec, Increment <$ inc]
