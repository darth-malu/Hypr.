#!/bin/bash

query_playerctl () {
    playerctl -l
}

player_status () {
    playerctl -p $1 status 2>/dev/null
}

general_playing_status () {
    playerctl status 2>/dev/null
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
        "firefox")
            #while spotify or lollypop in background pause those first
            if  check_running "spotify" || check_running "python3 /sbin/lollypop";then
                playerctl -ps spotify play-pause || playerctl -sp Lollypop play-pause
            else
                playerctl -ps firefox play-pause
            fi
            ;;
        *)
            if  check_running "spotify" || check_running "python3 /sbin/lollypop";then
                playerctl -ps spotify play-pause || playerctl -sp Lollypop play-pause
            else
                playerctl -ps $active_player play-pause
            fi
            ;;
    esac
    }

pause_player 

