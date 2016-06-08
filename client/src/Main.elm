module Main exposing (..)

import Html.App as HApp

import Model
import Update
import View

main : Program Never
main =
    HApp.program
        { init = ( Model.init, Update.init )
        , update = Update.update
        , subscriptions = Update.subscriptions
        , view = View.view
        }
