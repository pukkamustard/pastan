module Model exposing (Model,Mode(..), init)

import Pastan.Item exposing (Item)
import Queue exposing (Queue)


type alias Model =
    { items : List Item
    , queue : Queue
    , query : String
    , mode : Mode
    }


type Mode
    = Browse
    | Queue


init : Model
init =
    { items = []
    , query = "artist is \"J Dilla\""
    , queue = []
    , mode = Queue
    }
