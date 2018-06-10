module Main where

main :: IO ()
main = putStrLn "Hello, Haskell!"

data Program mod m = Program
  { model :: mod
  , view  :: mod -> m ()
  }

beginnerProgram p = mdo
  foldDynM
--  msg <- widgetHold (view model) $
--  foldDyn model update

# https://guide.elm-lang.org/architecture/user_input/buttons.html
model = 0

data Msg = Increment | Decrement

update = \case
  Increment -> (+1)
  Decrement -> (-1)

view model = el "div" $ do
  dec <- button "-"
  el "div" $ display model
  inc <- button "+"
  pure $ leftmost [Decrement <$ dec, Increment <$ inc]
