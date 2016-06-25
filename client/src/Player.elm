port module Player exposing (..)

import Task


--

import Pastan
import Pastan.Item exposing (Item)


-- Model


type alias Model =
    { queue : List Item
    , state : State
    }


type State
    = Playing
    | Stopping
    | Stopped


init : Model
init =
    { queue = []
    , state = Stopped
    }



-- Update


type Msg
    = Queue (List Item)
    | Play
    | Next
    | Stop
      --
    | Loaded Int
    | Ended


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ loaded Loaded
        , ended (always Ended)
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Queue items ->
            let
                loadCmd i =
                    load { id = i.id, url = Pastan.fileUrl i }
            in
                ( { model | queue = List.append model.queue items }
                , items
                    |> List.map loadCmd
                    |> Cmd.batch
                )

        Play ->
            case model.queue of
                head :: _ ->
                    ( { model | state = Playing }, play head.id )

                [] ->
                    ( model, Cmd.none )

        Stop ->
            ( { model | state = Stopping }, stop () )

        Loaded id ->
            let
                id' =
                    id |> Debug.log "loaded id"
            in
                ( model, Cmd.none )

        Ended ->
            case model.state of
                Stopping ->
                    ( { model | state = Stopped }, Cmd.none )

                Playing ->
                    ( model, Next |> Task.succeed |> Task.perform identity identity )

                _ ->
                    ( model, Cmd.none )

        Next ->
            let
                play =
                    case model.state of
                        Playing ->
                            Play |> Task.succeed |> Task.perform identity identity

                        _ ->
                            Cmd.none
            in
                case model.queue of
                    head :: tail ->
                        ( { model | queue = tail }, play )

                    _ ->
                        ( model, Stop |> Task.succeed |> Task.perform identity identity )



-- Ports


port load : { id : Int, url : String } -> Cmd msg


port loaded : (Int -> msg) -> Sub msg


port ended : (Bool -> msg) -> Sub msg


port play : Int -> Cmd msg


port stop : () -> Cmd msg
