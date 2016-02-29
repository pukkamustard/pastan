module Main (..) where

import Item exposing (Item)
import View
import Html exposing (Html)
import Signal exposing (Signal)
import Task exposing (Task, andThen)
import Http
import Json.Decode as Json exposing ((:=))


main : Signal Html
main =
  Signal.map View.items list.signal


list : Signal.Mailbox (List Item)
list =
  Signal.mailbox []


report : List Item -> Task x ()
report items =
  Signal.send list.address items


port fetch : Task Http.Error ()
port fetch =
  Http.get items url `andThen` report


items : Json.Decoder (List Item)
items =
  Json.list Item.decode


url : String
url =
  "http://localhost:8338/items"
