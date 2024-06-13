#!/bin/bash

function query_playerctl () {
    playerctl -l
}

function get_current_player () {
    local players=$(query_playerctl)

    for player in $players;do
        local playing_status=$(playerctl -p $player status 2>/dev/null)
        if [[ $player == *"spotify"* ]] && [[ $playing_status == "Playing" ]]; then 
            hyprctl dispatch focuswindow Spotify
        elif [[ $player == *"Lollypop"* ]] && [[ $playing_status == "Playing" ]]; then
            hyprctl dispatch focuswindow lollypop
        fi
    done
}

get_current_player
