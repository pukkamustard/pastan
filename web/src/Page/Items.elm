module Page.Items (..) where

import Signal
import Html exposing (Html, Attribute)
import Html.Attributes as Attributes
import Html.Events as Events
import Svg exposing (Svg)
import Svg.Attributes
import Material.Icons.Av exposing (queue)
import Material.Icons.Content exposing (add)
import Color


-- Pastan related imports

import Update exposing (Action(..))
import Model exposing (Model)
import Item exposing (Item)


view : Signal.Address Action -> Model -> Html
view address model =
  Html.div
    []
    [ Html.div
        [ Attributes.class "row" ]
        [ Html.div
            []
            [ topMenu address model ]
        ]
    , Html.div
        [ Attributes.class "row" ]
        [ Html.div
            [ Attributes.class "col-md-12" ]
            [ (itemsTable address model.items) ]
        ]
    ]


topMenu : Signal.Address Action -> Model -> Html
topMenu address model =
  Html.div
    [ Attributes.class "top-menu" ]
    [ queryInput address model.itemsQuery
    , buttons address model
    ]


queryInput : Signal.Address Action -> String -> Html
queryInput address itemsQuery =
  Html.div
    [ Attributes.class "col-md-11" ]
    [ Html.input
        [ Attributes.id "query-field"
        , Attributes.placeholder itemsQuery
          -- , Attributes.value model.itemsQuery
        , Events.on "input" Events.targetValue (\query -> Signal.message address (QueryItems query))
        ]
        []
    ]


buttons : Signal.Address Action -> Model -> Html
buttons address model =
  Html.div
    [ Attributes.class "col-md-1 buttons" ]
    [ queueButton (queue Color.lightCharcoal) 48 address model.items ]


queueButton : (Int -> Svg) -> Int -> Signal.Address Action -> List Item -> Html
queueButton icon size address items =
  Html.a
    [ Attributes.class "icon-button"
    , addToQueue address items
    ]
    [ Svg.svg
        [ Svg.Attributes.width (toString size), Svg.Attributes.height (toString size) ]
        [ icon size]
    ]


itemRow : Signal.Address Action -> Item -> Html
itemRow address item =
  Html.tr
    []
    [ Html.td [] [ Html.text item.title ]
    , Html.td [] [ Html.text item.artist ]
    , Html.td [] [ Html.text item.album ]
    , Html.td [] [ Html.a [ Attributes.href (Item.fileUrl item), Attributes.target "_blank" ] [ Html.text "..." ] ]
    , Html.td [] [ queueButton (add Color.lightCharcoal) 32 address [ item ] ]
    ]


addToQueue : Signal.Address Action -> List Item -> Attribute
addToQueue address =
  (\items -> Events.onClick address (AddToQueue items))


itemsTable : Signal.Address Action -> List Item -> Html
itemsTable address list =
  Html.table
    [ Attributes.class "table table-hover col-md-12" ]
    [ Html.thead
        []
        [ Html.tr
            []
            [ Html.th [] [ Html.text "Title" ]
            , Html.th [] [ Html.text "Artist" ]
            , Html.th [] [ Html.text "Album" ]
            , Html.th [] [ Html.text "Link" ]
            , Html.th [] [ Html.text "Queue" ]
            ]
        ]
    , Html.tbody [] (List.map (itemRow address) list)
    ]
