#!/bin/bash

query_playerctl () {
    playerctl -l
}

general_playing_status () {
    playerctl status 2>/dev/null
}

music_playing_state () {
    #ingest ... eg mpd, then check if playing and return Playing/Paused
    while read -r player;do
        #local status=$(playerctl -ps ${player} status)
        case ${player} in
            "mpd" | "spotify" | "lollypop")
            playerctl -ps ${player} status
                ;;
        esac
    done <<< $(playerctl -l)
}

check_running () {
    preg -x "$@" > /dev/null || pgrep -fc "$@" > /dev/null
}

player_active() {
    playerctl metadata --format '{{ playerName }}' | sed '/^$/d'
}

pause_player () {
    local active_player=$(player_active)
    local current_player=$(playerctl metadata --format '{{ playerName }}')
    local players=$(query_playerctl)
    local any_playing=$(general_playing_status)

    case $active_player in
        "spotify")
            playerctl -p $active_player play-pause
            ;;
        "Lollypop")
            playerctl -p Lollypop play-pause
            ;;
        "mpd")
            mpc toggle
            ;;
        "firefox" | *brave*)
            #while spotify or lollypop in background pause those first
            #if [[ ( $(check_running "spotify") || $(check_running "python3 /sbin/lollypop") || $(check_running "ncmpcpp") ) && $(music_playing_state) == "Playing" ]]; then
            if [[ $(music_playing_state) == "Playing" ]]; then
                playerctl -ps spotify play-pause || playerctl -sp Lollypop play-pause || mpc toggle
                dunstify "Music paused"
            else
                playerctl -ps ${active_player} play-pause
            fi
            ;;
        *)
            #true if spotify, lollypop running
            #if  check_running "spotify" || check_running "python3 /sbin/lollypop";then
                #playerctl -ps spotify play-pause || playerctl -sp Lollypop play-pause
            #else
                #playerctl -ps $active_player play-pause
            #fi

            # Check the current state of mpc
            #status=$(mpc status | grep -oP '(?<=\[\s)[a-z]+(?=\s\])')
            #mpc status | awk -F'[][]' '{print $2}'
            #status=$(mpc status | grep -o "playing")

            status=$(mpc status | grep -oP '(?<=\[)[a-z]+(?=\])')

            if [[ "$status" == "playing" ]]; then
                # If mpc is playing, pause it
                mpc pause
            elif [[ "$status" == "paused" ]]; then
                # If mpc is paused, play it
                mpc play
            else
                # If mpc is stopped or in an unknown state, start playback
                mpc play
            fi
            ;;
    esac
    }

pause_player 

