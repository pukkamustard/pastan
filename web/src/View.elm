module View (..) where

import Item exposing (Item)
import Html exposing (Html, Attribute)
import Html.Attributes as Attributes
import List
import Signal
import Model exposing (Model)
import Update exposing (Action(..))
import Material.Icons.Image exposing (music_note)
import Svg
import Svg.Attributes
import Color


item : Item -> Html
item i =
  Html.li
    [ Attributes.class "media" ]
    [ Html.div [ Attributes.class "media-left" ] [ itemIcon ]
    , Html.div
        [ Attributes.class "media-body" ]
        [ Html.h4 [ Attributes.class "media-heading" ] [ Html.text (i.artist ++ " - " ++ i.title) ]
        , Html.a [ Attributes.href (Item.fileUrl i) ] [ Html.text "file" ]
        ]
    ]


itemIcon : Html
itemIcon =
  let
    size =
      48
  in
    Svg.svg
      [ Svg.Attributes.class "media-object"
      , Svg.Attributes.width (toString size)
      , Svg.Attributes.height (toString size)
      ]
      [ music_note Color.gray size ]


myStyle : Attribute
myStyle =
  Attributes.style
    [ ( "width", "100%" )
    , ( "padding", "20px" )
    ]


items : List Item -> Html
items list =
  Html.ul
    [ Attributes.class "list-group" ]
    (List.map item list)


view : Signal.Address Action -> Model -> Html
view address model =
  items model.items
