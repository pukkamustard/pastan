module Page.Albums (..) where

import Html exposing (Html)
import Signal
import Update exposing (Action)
import Model exposing (Model)

view : Signal.Address Action -> Model -> Html
view address model =
    Html.text (toString model.albums)
