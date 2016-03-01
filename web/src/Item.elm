module Item (..) where

import Json.Decode as Json exposing ((:=))


type alias Item =
  { id : Int
  , artist : String
  , title : String
  }


decode : Json.Decoder Item
decode =
  Json.object3
    (\id artist title -> { id = id, artist = artist, title = title })
    ("id" := Json.int)
    ("artist" := Json.string)
    ("title" := Json.string)


decodeList : Json.Decoder (List Item)
decodeList =
  Json.list decode


fileUrl : Item -> String
fileUrl i =
  "http://localhost:8338/items/" ++ (toString i.id) ++ "/file"
