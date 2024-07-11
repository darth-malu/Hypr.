#!/bin/bash

function active_player() {
    playerctl metadata --format '{{ playerName }}'
}


grab_spotify_pid () {
    #extracts as pid: xxxx 
    hyprctl clients | grep -i -A3 Spotify | grep pid | tr -d '[:blank:]' 
}

function focus_current_player () {
    local displaying_player=$(active_player)
    local spotify=$(grab_spotify_pid)

    case $displaying_player in
        *"spotify"*)
            hyprctl dispatch focuswindow ${spotify} > /dev/null
            ;;
        *"Lollypop"*)
            hyprctl dispatch focuswindow lollypop > /dev/null
            ;;
        *"firefox"*)
            hyprctl dispatch focuswindow firefox > /dev/null
            ;;
        *"mpd"*)
            #hyprctl dispatch focuswindow title:nc 2>&1 /dev/null | hyprctl dispatch focuswindow title:ncmpcpp 2> /dev/null
            #hyprctl dispatch focuswindow title:nc || hyprctl dispatch focuswindow title:ncmpcpp || hyprctl dispatch exec '[workspace 6] kitty -e ncmpcpp'
            #hyprctl dispatch exec '[workspace special:nc] kitty -e ncmpcpp'
            hyprctl dispatch togglespecialworkspace nc > /dev/null
            ;;
    esac
}

focus_current_player

