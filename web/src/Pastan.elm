module Pastan (..) where

import Task
import Update exposing (Action(..))
import Item
import Album
import Http
import Effects exposing (Effects)


apiUrl : String
apiUrl =
  "http://localhost:8338/"


getItems : Effects Action
getItems =
  Http.get Item.decodeList (apiUrl ++ "items")
    |> Task.toMaybe
    |> Task.map ReceivedItems
    |> Effects.task


getAlbums : Effects Action
getAlbums =
  Http.get Album.decodeList (apiUrl ++ "albums")
    |> Task.toMaybe
    |> Task.map ReceivedAlbums
    |> Effects.task
