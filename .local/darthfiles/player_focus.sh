#!/bin/bash

function active_player() {
    playerctl metadata --format '{{ playerName }}'
}

function focus_current_player () {
    local displaying_player=$(active_player)

    case $displaying_player in
        *"spotify"*)
            hyprctl dispatch focuswindow Spotify
            ;;
        *"Lollypop"*)
            hyprctl dispatch focuswindow lollypop
            ;;
        *"firefox"*)
            hyprctl dispatch focuswindow firefox
            ;;
    esac
}

focus_current_player

