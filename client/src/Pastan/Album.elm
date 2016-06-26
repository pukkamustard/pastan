module Album exposing (..)

import Json.Decode as Json exposing ((:=))


type alias Album =
    { id : Int
    , albumartist : String
    , album : String
    , year : Int
    , added : Float
    , mb_albumid : String
    }


decode : Json.Decoder Album
decode =
    Json.object6 (\id albumartist album year added mb_albumid -> { id = id, albumartist = albumartist, album = album, year = year, added = added, mb_albumid = mb_albumid })
        ("id" := Json.int)
        ("albumartist" := Json.string)
        ("album" := Json.string)
        ("year" := Json.int)
        ("added" := Json.float)
        ("mb_albumid" := Json.string)
