module Model exposing (Model, init)

import Pastan.Item exposing (Item)
import Queue exposing (Queue)


type alias Model =
    { items : List Item
    , queue : Queue
    , query : String
    }


init : Model
init =
    { items = []
    , query = "artist is Moby"
    , queue = []
    }
