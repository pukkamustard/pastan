port module Player exposing (..)

import Task
import Set exposing (Set)


--

import Pastan
import Pastan.Item exposing (Item)


-- Model


type alias Model =
    { queue : List Item
    , cache : Set Int
    , state : State
    }


type State
    = Playing
    | Stopped


init : Model
init =
    { queue = []
    , cache = Set.empty
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
    | Ended Bool


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ loaded Loaded
        , ended Ended
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
                        |> List.append model.queue
            in
                ( { model | queue = queue' }
                , items
                    |> List.map loadCmd
                    |> Cmd.batch
                )

        Play ->
            case model.queue of
                head :: _ ->
                    ( { model | state = Playing }, play head.id )

                _ ->
                    ( model, Stop |> Task.succeed |> Task.perform identity identity )

        Stop ->
            ( model, stop () )

        Loaded id ->
            let
                id' =
                    id |> Debug.log "loaded id"

                cache' =
                    Set.insert id model.cache
            in
                ( { model | cache = cache' }, Cmd.none )

        Ended manual ->
            let
                m =
                    manual |> Debug.log "manual"

                ( state', cmd ) =
                    (if manual then
                        ( Stopped, Cmd.none )
                     else
                        ( model.state, Next |> Task.succeed |> Task.perform identity identity )
                    )
                        |> Debug.log "Ended"
            in
                ( { model | state = state' }, cmd )

        Next ->
            case model.queue of
                head :: [] ->
                    ( { model | queue = [] }, Stop |> Task.succeed |> Task.perform identity identity )

                head :: tail ->
                    let
                        play =
                            if model.state == Playing then
                                Play |> Task.succeed |> Task.perform identity identity
                            else
                                Cmd.none
                    in
                        ( { model | queue = tail }, play )

                _ ->
                    ( model, Stop |> Task.succeed |> Task.perform identity identity )



-- Ports


port load : { id : Int, url : String } -> Cmd msg


port loaded : (Int -> msg) -> Sub msg


{-|
Signal is True if stop was caused manually (not by song finishing)
-}
port ended : (Bool -> msg) -> Sub msg


port play : Int -> Cmd msg


port stop : () -> Cmd msg
