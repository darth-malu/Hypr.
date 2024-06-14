#!/bin/bash

function query_playerctl () {
    playerctl -l
}

function focus_current_player () {
    local players=$(query_playerctl)

    for player in $players;do

        local playing_status=$(playerctl -p $player status 2>/dev/null)

        case $player in
            *"spotify"*)
                case $playing_status in
                    "Playing")
                        hyprctl dispatch focuswindow Spotify
                        ;;
                esac
                ;;
            *"Lollypop"*)
                case $playing_status in
                    "Playing")
                        hyprctl dispatch focuswindow lollypop
                        ;;
                esac
                ;;
        esac
    done

}
focus_current_player

