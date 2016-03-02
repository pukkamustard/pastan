module Page.Items (..) where

import Signal
import Html exposing (Html, Attribute)
import Html.Attributes as Attributes
import Html.Events as Events
import Svg
import Svg.Attributes
import Color
import Material.Icons.Image exposing (music_note)
import Material.Icons.Content exposing (add)
import Update exposing (Action(..))
import Model exposing (Model)
import Item exposing (Item)



view : Signal.Address Action -> Model -> Html
view address model =
  Html.div
    [ Attributes.class "row" ]
    [ Html.div
        [ Attributes.class "col-md-12" ]
        [ (items address model.items) ]
    ]


item : Signal.Address Action -> Item -> Html
item address i =
  Html.li
    [ Attributes.class "media item" ]
    [ Html.div [ Attributes.class "media-left" ] [ itemIcon address i ]
    , Html.div
        [ Attributes.class "media-body" ]
        [ Html.h4 [ Attributes.class "media-heading" ] [ Html.text (i.artist ++ " - " ++ i.title) ]
        , Html.a [ Attributes.href (Item.fileUrl i), Attributes.target "_blank" ] [ Html.text "file " ]
        ]
    ]


addToQueue : Signal.Address Action -> Item -> Attribute
addToQueue address =
  (\i -> Events.onClick address (AddToQueue i))


itemIcon : Signal.Address Action -> Item -> Html
itemIcon address i =
  let
    size =
      48
  in
    Html.div
      [ Attributes.class "media-object item-add", addToQueue address i ]
      [ Svg.svg
          [ Svg.Attributes.class "icon-note"
          , Svg.Attributes.width (toString size)
          , Svg.Attributes.height (toString size)
          ]
          [ music_note Color.grey size ]
      , Svg.svg
          [ Svg.Attributes.class "icon-add"
          , Svg.Attributes.width (toString size)
          , Svg.Attributes.height (toString size)
          ]
          [ add Color.grey size ]
      ]


items : Signal.Address Action -> List Item -> Html
items address list =
  Html.ul
    [ Attributes.class "media-list items col-md-6" ]
    (List.map (item address) list)
