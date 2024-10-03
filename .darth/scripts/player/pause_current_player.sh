#!/bin/dash

query_playerctl () {
    playerctl -l
}

# general_playing_status () {
    # playerctl status 2>/dev/null
# }

music_playing_state () {
    #ingest ... eg mpd, then check if playing and return Playing/Paused
    for player in $(query_playerctl); do
        case $player in
            "mpd" | "spotify" | "lollypop")
                playerctl -p "$player" status
                ;;
        esac
    done
}

check_running () {
    preg -xc "$@" > /dev/null || pgrep -fc "$@" > /dev/null
}

player_active() {
    # eg output: mpd, spotify
    playerctl metadata --format '{{ playerName }}' | sed '/^$/d'
}

pause_player () {
     local active_player

    #local current_player=$(playerctl metadata --format '{{ playerName }}')
    #local players=$(query_playerctl)
    #local any_playing=$(general_playing_status)

    active_player=$(player_active)

    case ${active_player} in
        "spotify")
            playerctl -p "$(active_player)" play-pause
            ;;
        "Lollypop")
            playerctl -p Lollypop play-pause
            ;;
        "mpd")
            mpc toggle
            ;;
        firefox* | *brave*)
            #while spotify or lollypop in background pause those first
            #if [[ ( $(check_running "spotify") || $(check_running "python3 /sbin/lollypop") || $(check_running "ncmpcpp") ) && $(music_playing_state) == "Playing" ]]; then

            case $(music_playing_state) in
                "Playing")
                    playerctl -ps spotify play-pause || playerctl -sp Lollypop play-pause || mpc toggle
                    dunstify "Music paused"
                    ;;
                *)
                    playerctl -ps firefox play-pause
                    # dunstify "Nothing is playing right now"
                    ;;
            esac
            ;;
        *)
            if  check_running "spotify" || check_running "python3 /sbin/lollypop";then
                playerctl -ps spotify play-pause || playerctl -sp Lollypop play-pause
            else
                playerctl -ps "$(active_player)" play-pause
            fi
            ;;
    esac
    }

pause_player 

