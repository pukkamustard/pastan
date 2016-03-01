module View (..) where

import Item exposing (Item)
import Html exposing (Html, Attribute)
import Html.Attributes as Attributes
import List
import Signal
import Model exposing (Model)
import Update exposing (Action(..))


item : Item -> Html
item i =
  Html.div
    [ myStyle ]
    [ Html.h4 [] [ Html.text (i.artist ++ " - " ++ i.title) ]
    , Html.a [ Attributes.href (Item.fileUrl i) ] [ Html.text "file" ]
    ]


myStyle : Attribute
myStyle =
  Attributes.style
    [ ( "width", "100%" )
    , ( "padding", "20px" )
    ]


items : List Item -> Html
items list =
  Html.div
    []
    (List.map item list)


view : Signal.Address Action -> Model -> Html
view address model =
  items model.items
