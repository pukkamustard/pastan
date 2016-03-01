module Page.Queue (..) where

import Signal
import Html exposing (Html)
import Update exposing (Action(..))
import Model exposing (Model)
import Item exposing (Item)


view : Signal.Address Action -> Model -> Html
view address model =
  Html.text "Helloww"
