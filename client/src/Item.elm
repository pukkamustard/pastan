module Item exposing (..)

import Json.Decode exposing ((:=))
import Http


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


decode : Json.Decode.Decoder Item
decode =
    Json.Decode.object8
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
        ("id" := Json.Decode.int)
        ("track" := Json.Decode.int)
        ("artist" := Json.Decode.string)
        ("title" := Json.Decode.string)
        ("length" := Json.Decode.float)
        ("album" := Json.Decode.string)
        ("album_id" := Json.Decode.int)
        ("albumartist" := Json.Decode.string)


get : String -> String -> Platform.Task Http.Error (List Item)
get apiUrl query =
    Http.get (Json.Decode.list decode) (apiUrl ++ "items?q=" ++ query)


fileUrl : Item -> String
fileUrl i =
    -- "http://localhost:8338/api/items/" ++ (toString i.id) ++ "/file"
    "/api/items/" ++ (toString i.id) ++ "/file"
