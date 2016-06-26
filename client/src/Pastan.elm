module Pastan exposing (..)

import Task exposing (Task)
import Http
import Json.Decode as JD


--

import Pastan.Item as Item exposing (Item)
import Pastan.Config as Config


items : String -> Task Http.Error (List Item)
items query =
    Http.get (JD.list Item.decode) (Config.url ++ "items?q=" ++ query)


fileUrl : Item -> String
fileUrl i =
    Config.url ++ "items/" ++ (toString i.id) ++ "/file"
