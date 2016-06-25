module Model exposing (Model, init)

import Pastan.Item exposing (Item)


type alias Model =
    { items : List Item
    , queue : List Item
    , query : String
    }


init : Model
init =
    { items = []
    , query = "artist is Moby"
    , queue = []
    }
