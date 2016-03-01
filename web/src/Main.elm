module Main (..) where

import Effects exposing (Never)
import Html exposing (Html)
import StartApp exposing (start)
import Task
import Model
import Update exposing (update)
import View exposing (view)
import Pastan


app =
  start
    { init = init
    , update = update
    , view = view
    , inputs = []
    }


init =
  ( { items = [], queue = [] }, Pastan.getItems )


main : Signal Html
main =
  app.html


port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks
