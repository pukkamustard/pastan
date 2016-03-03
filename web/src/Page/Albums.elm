module Page.Albums (..) where

import Html exposing (Html, Attribute)
import Html.Attributes as Attributes
import Html.Events as Events
import Signal
import List
import Album exposing (Album)
import Update exposing (Action(..))
import Model exposing (Model)


view : Signal.Address Action -> Model -> Html
view address model =
  Html.div
    []
    [ albumGrid address model.albums ]


albumGrid : Signal.Address Action -> List Album -> Html
albumGrid address albums =
  let
    grid =
      chunksOfLeft 6 albums
  in
    Html.div [] (List.map (albumRow address) grid)


albumRow : Signal.Address Action -> List Album -> Html
albumRow address albums =
  Html.div [ Attributes.class "row album-row" ] (List.map (albumTile address) albums)


albumTile : Signal.Address Action -> Album -> Html
albumTile address album =
  Html.div
    [ Attributes.class "col-md-2 album-tile"
    , onClick address album
    ]
    [ Html.div
        [ Attributes.class "square" ]
        []
    , Html.h4 [] [ Html.text album.album ]
    , Html.text album.albumartist
    ]


onClick : Signal.Address Action -> Album -> Attribute
onClick address album =
  Events.onClick address (QueryItems ("album_id is " ++ toString album.id))


chunksOfLeft : Int -> List a -> List (List a)
chunksOfLeft k xs =
  let
    len =
      List.length xs
  in
    if len > k then
      List.take k xs :: chunksOfLeft k (List.drop k xs)
    else
      [ xs ]
