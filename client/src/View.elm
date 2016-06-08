module View exposing (view)

import Html as H exposing (Html)


-- import Html.Attributes as HA
-- import Html.Events as HE

import Model exposing (Model)
import Update exposing (Msg(..))


view : Model -> Html Msg
view model =
    H.div []
        [ H.h1 [] [ H.text "Hello, my name is pastan!" ]
        ]
