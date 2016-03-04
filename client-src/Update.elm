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
  | ReceivedItems String (Maybe (List Item))
  | GetItems String
  | ReceivedAlbums (Maybe (List Album))
  | AddToQueue (List Item)
  | ChangePage Page


apiUrl : String
apiUrl =
  "http://localhost:8338/"


getItems : String -> Effects Action
getItems query =
  Http.get Item.decodeList (apiUrl ++ "items?q=" ++ query)
    |> Task.toMaybe
    |> Task.map (ReceivedItems query)
    |> Effects.task


getAlbums : String -> Effects Action
getAlbums query =
  Http.get Album.decodeList (apiUrl ++ "albums")
    |> Task.toMaybe
    |> Task.map ReceivedAlbums
    |> Effects.task


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case action of
    ReceivedItems query maybeItems ->
      case maybeItems of
        Just items ->
          ( { model
              | currentPage = PageItems
              , query =
                  query
              , items = Maybe.withDefault model.items maybeItems
            }
          , Effects.none
          )

        Nothing ->
          ( model, Effects.none )

    GetItems query ->
      ( model, getItems query )

    ReceivedAlbums maybeAlbums ->
      ( { model | albums = Maybe.withDefault model.albums maybeAlbums }, Effects.none )

    AddToQueue items ->
      ( { model | queue = List.append model.queue items }, Effects.none )

    ChangePage page ->
      ( { model | currentPage = page }, Effects.none )

    _ ->
      ( model, Effects.none )
