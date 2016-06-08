module Model exposing (Model, init)

import Item exposing (Item)


type alias Model =
    { items : List Item
    , queue : List Item
    }


init : Model
init =
    { items = []
    , queue = []
    }
