module Update (..) where

import List
import Effects exposing (Effects)
import Task
import Http
import Model exposing (Model)
import Item exposing (Item)
import Album exposing (Album)
import Page exposing (Page(..))


type Action
  = NoOp
  | ReceivedItems (Maybe (List Item))
  | QueryItems String
  | ReceivedAlbums (Maybe (List Album))
  | AddToQueue Item
  | ChangePage Page


apiUrl : String
apiUrl =
  "http://localhost:8338/"


queryItems : String -> Effects Action
queryItems query =
  Http.get Item.decodeList (apiUrl ++ "items?q=" ++ query)
    |> Task.toMaybe
    |> Task.map ReceivedItems
    |> Effects.task


queryAlbums : String -> Effects Action
queryAlbums query =
  Http.get Album.decodeList (apiUrl ++ "albums")
    |> Task.toMaybe
    |> Task.map ReceivedAlbums
    |> Effects.task


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case action of
    ReceivedItems maybeItems ->
      ( { model | currentPage = PageItems, items = List.sortWith Item.compareItem (Maybe.withDefault model.items maybeItems) }, Effects.none )

    QueryItems query ->
      ( model, queryItems query )

    ReceivedAlbums maybeAlbums ->
      ( { model | albums = Maybe.withDefault model.albums maybeAlbums }, Effects.none )

    AddToQueue item ->
      ( { model | queue = List.append model.queue [ item ] }, Effects.none )

    ChangePage page ->
      ( { model | currentPage = page }, Effects.none )

    _ ->
      ( model, Effects.none )
