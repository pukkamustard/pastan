module Item (..) where

import Json.Decode as Json exposing ((:=))


type alias Item =
  { id : Int
  , artist : String
  , title : String
  , length : Float
  , album : String
  , album_id : Int
  }


decode : Json.Decoder Item
decode =
  Json.object6
    (\id artist title length album album_id -> { id = id, artist = artist, title = title, length = length, album = album, album_id = album_id })
    ("id" := Json.int)
    ("artist" := Json.string)
    ("title" := Json.string)
    ("length" := Json.float)
    ("album" := Json.string)
    ("album_id" := Json.int)


decodeList : Json.Decoder (List Item)
decodeList =
  Json.list decode


fileUrl : Item -> String
fileUrl i =
  "http://localhost:8338/items/" ++ (toString i.id) ++ "/file"
