port module Player exposing (..)

import Task
import Set exposing (Set)


--

import Html as H exposing (Html)
import Color
import Html.Attributes as HA
import Html.Events as HE
import FontAwesome


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
    | Paused


init : Model
init =
    { queue = []
    , cache = Set.empty
    , state = Paused
    }



-- Update


type Msg
    = Queue (List Item)
    | Play
    | Pause
    | Next
      --
    | Ended


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ ended (always Ended)
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Queue items ->
            let
                queue' =
                    items
                        |> List.append model.queue
            in
                ( { model | queue = queue' }
                , Cmd.none
                )

        Play ->
            case model.queue of
                head :: _ ->
                    ( { model | state = Playing }, play (Pastan.fileUrl head) )

                _ ->
                    ( model, Pause |> Task.succeed |> Task.perform identity identity )

        Pause ->
            ( { model | state = Paused }, pause () )

        Ended ->
            ( model, Next |> Task.succeed |> Task.perform identity identity )
                |> Debug.log "Ended"

        Next ->
            case model.queue of
                head :: [] ->
                    ( { model | queue = [], state = Paused }, pause () )

                head :: tail ->
                    let
                        play =
                            if model.state == Playing then
                                Play |> Task.succeed |> Task.perform identity identity
                            else
                                Cmd.none
                    in
                        ( { model | queue = tail }, play )

                [] ->
                    ( model, Cmd.none )



--  Helpers


inQueue : Model -> Item -> Bool
inQueue model item =
    List.member item model.queue



-- view


view : Model -> Html Msg
view model =
    let
        playStop =
            case model.state of
                Playing ->
                    H.a [ HE.onClick Pause ] [ FontAwesome.pause Color.red 50 ]

                _ ->
                    H.a [ HE.onClick Play ] [ FontAwesome.play Color.green 50 ]

        next =
            H.a [ HE.onClick Next ] [ FontAwesome.fast_forward Color.blue 50 ]

        item =
            case model.queue of
                head :: _ ->
                    H.div []
                        [ H.h4 [] [ H.text (head.artist ++ " - " ++ head.title) ]
                        ]

                _ ->
                    H.text ""
    in
        H.div [ HA.class "container" ]
            [ H.div [ HA.class "row" ]
                [ H.div [ HA.class "three columns" ]
                    [ playStop, next ]
                , H.div [ HA.class "nine columns" ]
                    [ item ]
                ]
            ]



-- Ports


port play : String -> Cmd msg


port pause : () -> Cmd msg


port ended : (Bool -> msg) -> Sub msg
