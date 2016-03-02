module Update (..) where

import List
import Effects exposing (Effects)
import Model exposing (Model)
import Item exposing (Item)
import Album exposing (Album)
import Page exposing (Page)


type Action
  = NoOp
  | ReceivedItems (Maybe (List Item))
  | ReceivedAlbums (Maybe (List Album))
  | AddToQueue Item
  | ChangePage Page


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case action of
    ReceivedItems maybeItems ->
      ( { model | items = List.sortWith Item.compareItem (Maybe.withDefault model.items maybeItems) }, Effects.none )

    ReceivedAlbums maybeAlbums ->
      ( { model | albums = Maybe.withDefault model.albums maybeAlbums }, Effects.none )

    AddToQueue item ->
      ( { model | queue = List.append model.queue [ item ] }, Effects.none )

    ChangePage page ->
      ( { model | currentPage = page }, Effects.none )

    _ ->
      ( model, Effects.none )
