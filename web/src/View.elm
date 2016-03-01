module View (..) where

import Item exposing (Item)
import Html exposing (Html, Attribute)
import Html.Attributes as Attributes
import Html.Events as Events
import List
import Signal
import Model exposing (Model)
import Update exposing (Action(..))
import Material.Icons.Image exposing (music_note)
import Svg
import Svg.Attributes
import Color


item : Signal.Address Action -> Item -> Html
item address i =
  Html.li
    [ Attributes.class "media item" ]
    [ Html.div [ Attributes.class "media-left", addToQueue address i ] [ itemIcon ]
    , Html.div
        [ Attributes.class "media-body" ]
        [ Html.h4 [ Attributes.class "media-heading" ] [ Html.text (i.artist ++ " - " ++ i.title) ]
        , Html.a [ Attributes.href (Item.fileUrl i) ] [ Html.text "file " ]
        ]
    ]


addToQueue : Signal.Address Action -> Item -> Attribute
addToQueue address =
  (\i -> Events.onClick address (AddToQueue i))


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
      [ music_note Color.white size ]


items : Signal.Address Action -> List Item -> Html
items address list =
  Html.ul
    [ Attributes.class "media-list items col-md-6" ]
    (List.map (item address) list)


queue : Signal.Address Action -> List Item -> Html
queue address list =
  Html.ul
    [ Attributes.class "media-list queue col-md-6" ]
    (List.map (item address) list)


view : Signal.Address Action -> Model -> Html
view address model =
  Html.div
    [ Attributes.class "row" ]
    [ items address model.items
    , queue address model.queue
    ]
