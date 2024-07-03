#!/bin/bash

function active_player() {
    playerctl metadata --format '{{ playerName }}'
}


grap_spotify_pid () {
    #extracts as pid: xxxx 
    hyprctl clients | grep -i -A3 Spotify | grep pid | tr -d '[:blank:]' 
}

function focus_current_player () {
    local displaying_player=$(active_player)
    spotify=$(grap_spotify_pid)

    case $displaying_player in
        *"spotify"*)
            hyprctl dispatch focuswindow ${spotify}
            ;;
        *"Lollypop"*)
            hyprctl dispatch focuswindow lollypop
            ;;
        *"firefox"*)
            hyprctl dispatch focuswindow firefox
            ;;
        *"mpd"*)
            #hyprctl dispatch focuswindow title:nc 2>&1 /dev/null | hyprctl dispatch focuswindow title:ncmpcpp 2> /dev/null
            #hyprctl dispatch focuswindow title:nc || hyprctl dispatch focuswindow title:ncmpcpp || hyprctl dispatch exec '[workspace 6] kitty -e ncmpcpp'
            hyprctl dispatch exec '[workspace 6] kitty -e ncmpcpp'
            ;;
    esac
}

focus_current_player

