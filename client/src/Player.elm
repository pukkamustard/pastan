port module Player exposing (..)

import Task


--

import Pastan
import Pastan.Item exposing (Item)


-- Model


type QueueItem
    = Loading Item
    | ErrorLoading Item
    | ItemLoaded Item


type alias Model =
    { queue : List QueueItem
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

                queue' =
                    items
                        |> List.map Loading
                        |> List.append model.queue
            in
                ( { model | queue = queue' }
                , items
                    |> List.map loadCmd
                    |> Cmd.batch
                )

        Play ->
            case model.queue of
                (ItemLoaded head) :: _ ->
                    ( { model | state = Playing }, play head.id )

                _ ->
                    ( model, Stop |> Task.succeed |> Task.perform identity identity )

        Stop ->
            ( { model | state = Stopping }, stop () )

        Loaded id ->
            let
                id' =
                    id |> Debug.log "loaded id"

                queue' =
                    List.map
                        (\qI ->
                            if (toItem >> .id) qI == id then
                                ItemLoaded (toItem qI)
                            else
                                qI
                        )
                        model.queue
            in
                ( { model | queue = queue' }, Cmd.none )

        Ended ->
            case model.state of
                Stopping ->
                    ( { model | state = Stopped }, Cmd.none )
                        |> Debug.log "ended from stopping"

                Playing ->
                    ( model, Next |> Task.succeed |> Task.perform identity identity )
                        |> Debug.log "ended from playing"

                _ ->
                    ( model, Cmd.none )
                        |> Debug.log "ended from _"

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
                            |> Debug.log "next"

                    _ ->
                        ( model, Stop |> Task.succeed |> Task.perform identity identity )



-- Helpers


toItem : QueueItem -> Item
toItem qI =
    case qI of
        Loading item ->
            item

        ErrorLoading item ->
            item

        ItemLoaded item ->
            item



-- Ports


port load : { id : Int, url : String } -> Cmd msg


port loaded : (Int -> msg) -> Sub msg


port ended : (Bool -> msg) -> Sub msg


port play : Int -> Cmd msg


port stop : () -> Cmd msg
