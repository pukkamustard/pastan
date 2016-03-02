module Page.Items (..) where

import Signal
import Html exposing (Html, Attribute)
import Html.Attributes as Attributes
import Html.Events as Events
import Update exposing (Action(..))
import Model exposing (Model)
import Item exposing (Item)


view : Signal.Address Action -> Model -> Html
view address model =
  Html.div
    [ Attributes.class "row" ]
    [ Html.div
        [ Attributes.class "col-md-12" ]
        [ (itemsTable address model.items) ]
    ]


itemRow : Signal.Address Action -> Item -> Html
itemRow address item =
  Html.tr
    []
    [ Html.td [] [ Html.text item.title ]
    , Html.td [] [ Html.text item.artist ]
    , Html.td [] [ Html.text item.album ]
    , Html.td [] [ Html.a [ Attributes.href (Item.fileUrl item), Attributes.target "_blank" ] [ Html.text "..." ] ]
    ]



-- [ Html.div [ Attributes.class "media-left" ] [ itemIcon address i ]
-- , Html.div
--     [ Attributes.class "media-body" ]
--     [ Html.h4 [ Attributes.class "media-heading" ] [ Html.text (i.artist ++ " - " ++ i.title) ]
--     , Html.a [ Attributes.href (Item.fileUrl i), Attributes.target "_blank" ] [ Html.text "file " ]
--     ]
-- ]


addToQueue : Signal.Address Action -> Item -> Attribute
addToQueue address =
  (\i -> Events.onClick address (AddToQueue i))


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
            ]
        ]
    , Html.tbody [] (List.map (itemRow address) list)
    ]
