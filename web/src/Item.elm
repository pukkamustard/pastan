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
  , albumartist : String
  }


decode : Json.Decoder Item
decode =
  Json.object8
    (\id track artist title length album album_id albumartist ->
      { id = id
      , track = track
      , artist = artist
      , title = title
      , length = length
      , album = album
      , album_id = album_id
      , albumartist = albumartist
      }
    )
    ("id" := Json.int)
    ("track" := Json.int)
    ("artist" := Json.string)
    ("title" := Json.string)
    ("length" := Json.float)
    ("album" := Json.string)
    ("album_id" := Json.int)
    ("albumartist" := Json.string)


decodeList : Json.Decoder (List Item)
decodeList =
  Json.list decode


fileUrl : Item -> String
fileUrl i =
  "http://localhost:8338/items/" ++ (toString i.id) ++ "/file"


compareItem : Item -> Item -> Order
compareItem a b =
  let
    c =
      [ compareStringField .albumartist a b
      , compareIntField .album_id a b
      , compareIntField .track a b
      , compareStringField .title a b
      , compareIntField .id a b
      ]
  in
    List.foldr difference EQ c


compareStringField : (Item -> String) -> Item -> Item -> Order
compareStringField field a b =
  compare (field a) (field b)


compareIntField : (Item -> Int) -> Item -> Item -> Order
compareIntField field a b =
  compare (field a) (field b)



-- compareRecord : List (a -> comparable) -> a -> a -> Order
-- compareRecord fields a b =
--   let
--     ca =
--       List.map (\f -> f a) fields
--
--     cb =
--       List.map (\f -> f b) fields
--   in
--     List.foldr difference EQ (List.map2 compare ca cb)


difference : Order -> Order -> Order
difference x y =
  case x of
    EQ ->
      y

    _ ->
      x
