module Page.Items (..) where

import Signal
import Html exposing (Html, Attribute)
import Html.Attributes as Attributes
import Html.Events as Events
import Json.Decode as Json
import Svg exposing (Svg)
import Svg.Attributes
import Material.Icons.Av exposing (queue, play_arrow)
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
    [ queryInput address model.query
    , buttons address model
    ]


queryInput : Signal.Address Action -> String -> Html
queryInput address itemsQuery =
  Html.div
    [ Attributes.class "col-md-11" ]
    [ Html.input
        [ Attributes.id "query-field"
        , Attributes.value itemsQuery
        , onEnter Events.targetValue (\query -> Signal.message address (GetItems query))
        ]
        []
    ]



-- Copied from Html.Shorthand.Event


onEnter : Json.Decoder a -> (a -> Signal.Message) -> Attribute
onEnter dec f =
  Events.on
    "keydown"
    (Json.customDecoder (Json.object2 (,) Events.keyCode dec)
      <| \( c, val ) ->
          if c == 13 then
            Ok val
          else
            Err "expected key code 13"
    )
    f


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
        [ icon size ]
    ]



-- Items table


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
            ]
        ]
    , Html.tbody [] (List.map (itemRow address) list)
    ]


itemRow : Signal.Address Action -> Item -> Html
itemRow address item =
  Html.tr
    []
    [ Html.td [] [ Html.text item.title ]
    , Html.td [] [ artistLink address item ]
    , Html.td [] [ albumLink address item ]
    , Html.td [] [ playButton address item ]
    , Html.td [] [ queueButton (add Color.lightCharcoal) 32 address [ item ] ]
    ]


artistLink : Signal.Address Action -> Item -> Html
artistLink address item =
  Html.a
    [ Events.onClick address (GetItems ("albumartist is " ++ toString item.albumartist))
    ]
    [ Html.text item.artist ]


albumLink : Signal.Address Action -> Item -> Html
albumLink address item =
  Html.a
    [ Events.onClick address (GetItems ("album_id is " ++ toString item.album_id))
    ]
    [ Html.text item.album ]


playButton : Signal.Address Action -> Item -> Html
playButton address item =
  Html.a
    [ Attributes.class "icon-button"
    , Attributes.href (Item.fileUrl item)
    , Attributes.target "_blank"
    ]
    [ Svg.svg
        [ Svg.Attributes.width (toString 32), Svg.Attributes.height (toString 32) ]
        [ play_arrow Color.lightCharcoal 32 ]
    ]


addToQueue : Signal.Address Action -> List Item -> Attribute
addToQueue address =
  (\items -> Events.onClick address (AddToQueue items))
