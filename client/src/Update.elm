module Update exposing (Msg(..), update, init, subscriptions)

import Model exposing (Model)
import Item exposing (Item)
import Album exposing (Album)


type Msg
    = NoOp
    | ReceivedItems String (Maybe (List Item))
    | GetItems String
    | ReceivedAlbums (Maybe (List Album))
    | AddToQueue (List Item)
    -- | ChangePage Page


apiUrl : String
apiUrl =
    -- "http://localhost:8338/api/"
    "/api/"


init : Cmd Msg
init =
    Cmd.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        _ ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
