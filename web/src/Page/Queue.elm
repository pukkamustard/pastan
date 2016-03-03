module Page.Queue (..) where

import Signal
import Html exposing (Html)
import Html.Attributes as Attributes
import Svg
import Svg.Attributes
import Color
import String
import Base64


-- import Material.Icons.Image exposing (music_note)

import Material.Icons.Av exposing (play_circle_filled)
import Update exposing (Action(..))
import Model exposing (Model)
import Item exposing (Item)


view : Signal.Address Action -> Model -> Html
view address model =
  Html.div
    []
    [ topMenu address model
    , queue address model
    ]


queue : Signal.Address Action -> Model -> Html
queue address model =
  Html.div
    [ Attributes.class "row" ]
    [ Html.div
        [ Attributes.class "col-md-12" ]
        [ (itemsTable address model.queue) ]
    ]


topMenu : Signal.Address Action -> Model -> Html
topMenu address model =
  Html.div
    [ Attributes.class "row" ]
    [ buttons address model
    ]


buttons : Signal.Address Action -> Model -> Html
buttons address model =
  Html.div
    [ Attributes.class "col-md-1 col-md-offset-11 buttons" ]
    [ downloadPlaylistButton model.queue ]


downloadPlaylistButton : List Item -> Html
downloadPlaylistButton items =
  let
    size =
      48
  in
    Html.a
      [ Attributes.class "icon-button"
      , Attributes.href (dataURI "application/vnd.apple.mpegurl" (m3u items))
      ]
      [ Svg.svg
          [ Svg.Attributes.width (toString size)
          , Svg.Attributes.height (toString size)
          ]
          [ play_circle_filled Color.grey size ]
      ]


-- item : Signal.Address Action -> Item -> Html
-- item address i =
--   Html.li
--     [ Attributes.class "media item" ]
--     [ Html.div [ Attributes.class "media-left" ] [ itemIcon address i ]
--     , Html.div
--         [ Attributes.class "media-body" ]
--         [ Html.h4 [ Attributes.class "media-heading" ] [ Html.text (i.artist ++ " - " ++ i.title) ]
--         , Html.a [ Attributes.href (Item.fileUrl i), Attributes.target "_blank" ] [ Html.text "file " ]
--         ]
--     ]
-- items : Signal.Address Action -> List Item -> Html
-- items address list =
--   Html.ul
--     [ Attributes.class "media-list items col-md-6" ]
--     (List.map (item address) list)
--


itemRow : Signal.Address Action -> Item -> Html
itemRow address item =
  Html.tr
    []
    [ Html.td [] [ Html.text item.title ]
    , Html.td [] [ Html.text item.artist ]
    , Html.td [] [ Html.text item.album ]
    , Html.td [] [ Html.a [ Attributes.href (Item.fileUrl item), Attributes.target "_blank" ] [ Html.text "..." ] ]
    ]


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


m3u : List Item -> String
m3u items =
  "#EXTM3U\n\n"
    ++ (String.join "\n" <| List.map m3uEntry items)


m3uEntry : Item -> String
m3uEntry item =
  "#EXTINF:" ++ (toString item.length) ++ "," ++ item.artist ++ " - " ++ item.title ++ "\n" ++ (Item.fileUrl item)


dataURI : String -> String -> String
dataURI mediaType data =
  "data:" ++ mediaType ++ ";base64," ++ (Result.withDefault "" (Base64.encode data))
