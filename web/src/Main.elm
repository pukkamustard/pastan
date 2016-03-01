module Main (..) where

import Effects exposing (Never, Effects)
import Html exposing (Html)
import StartApp exposing (start)
import Task
import Update exposing (update, Action)
import View exposing (view)
import Pastan
import Model exposing (Model)
import Page exposing (Page(..))

app : StartApp.App Model
app =
  start
    { init = init
    , update = update
    , view = view
    , inputs = []
    }

init : (Model, Effects Action)
init =
  ( { items = [], queue = [], currentPage = PageItems }, Pastan.getItems )


main : Signal Html
main =
  app.html


port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks
