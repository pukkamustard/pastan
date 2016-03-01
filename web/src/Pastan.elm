module Pastan (..) where

import Task
import Update exposing (Action(..))
import Item
import Http
import Effects exposing (Effects)


apiUrl : String
apiUrl =
  "http://localhost:8338/"


getItems : Effects Action
getItems =
  Http.get Item.decodeList (apiUrl ++ "items")
    |> Task.toMaybe
    |> Task.map UpdateItems
    |> Effects.task
