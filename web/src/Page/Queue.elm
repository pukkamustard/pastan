module Page.Queue (..) where

import Signal
import Html exposing (Html)
import Html.Attributes as Attributes
import Svg
import Svg.Attributes
import Color
import String
import Base64
import Material.Icons.Image exposing (music_note)
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
        [ (items address model.queue) ]
    ]


topMenu : Signal.Address Action -> Model -> Html
topMenu address model =
  Html.div
    [ Attributes.class "row" ]
    [ Html.div
        [ Attributes.class "col-md-12" ]
        [ downloadPlaylistButton model ]
    ]


downloadPlaylistButton : Model -> Html
downloadPlaylistButton model =
  let
    size =
      64
  in
    Html.a
      [ Attributes.href (dataURI "application/vnd.apple.mpegurl" (m3u model.queue)) ]
      [ Svg.svg
          [ Svg.Attributes.width (toString size)
          , Svg.Attributes.height (toString size)
          ]
          [ play_circle_filled Color.grey size ]
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


itemIcon : Signal.Address Action -> Item -> Html
itemIcon address i =
  let
    size =
      48
  in
    Html.div
      [ Attributes.class "media-object" ]
      [ Svg.svg
          [ Svg.Attributes.class "icon-note"
          , Svg.Attributes.width (toString size)
          , Svg.Attributes.height (toString size)
          ]
          [ music_note Color.grey size ]
      ]


items : Signal.Address Action -> List Item -> Html
items address list =
  Html.ul
    [ Attributes.class "media-list items col-md-6" ]
    (List.map (item address) list)


m3u : List Item -> String
m3u items =
  String.join "\n" <| List.map Item.fileUrl items


dataURI : String -> String -> String
dataURI mediaType data =
  "data:" ++ mediaType ++ ";base64," ++ (Result.withDefault "" (Base64.encode data))
