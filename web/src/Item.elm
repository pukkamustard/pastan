module Item (..) where

import Json.Decode as Json exposing ((:=))


type alias Item =
  { id : Int
  , track : Int
  , artist : String
  , title : String
  , length : Float
  , album : String
  , album_id : Int
  }


decode : Json.Decoder Item
decode =
  Json.object7
    (\id track artist title length album album_id -> { id = id, track = track, artist = artist, title = title, length = length, album = album, album_id = album_id })
    ("id" := Json.int)
    ("track" := Json.int)
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


compareItem : Item -> Item -> Order
compareItem a b =
  compareRecord [ .artist, (toString << .album_id), (toString << .track), .title] a b


compareRecord : List (a -> comparable) -> a -> a -> Order
compareRecord fields a b =
  let
    ca =
      List.map (\f -> f a) fields

    cb =
      List.map (\f -> f b) fields
  in
    List.foldr difference EQ (List.map2 compare ca cb)


difference : Order -> Order -> Order
difference x y =
  case x of
    EQ ->
      y

    _ ->
      x
