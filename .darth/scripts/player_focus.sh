#!/usr/bin/env bash

function active_player() {
    playerctl metadata --format '{{ playerName }}'
}


grab_spotify_pid () {
    #extracts as pid: xxxx 
    hyprctl clients | grep -i -A3 Spotify | grep pid | tr -d '[:blank:]' 
}


ncmpcpp_pid () {
    hyprctl clients | awk 'BEGIN { FS="\n" ; RS=""; OFS="\n" ; ORS = "\n\n"} /^Window.*nc.*/ { print $14, $NF }'| sed -n 1p| tr -d '[:blank:]'
}

launch_focus_if_nc_running () {
    #check if nc process is up && a window  exists under class:kitty , title: nc*
    local nc="$(pgrep ncmpcpp)"

    # if process exists look for pid else launch it
    # True if string length != 0
    if [[ -n $nc ]]
    then
        local nc_state="$(ncmpcpp_pid)"
        if [[ -n $nc_state ]]
        then
            # focus running instance of ncmpcpp
            hyprctl dispatch togglespecialworkspace nc
            #hyprctl dispatch focuswindow "$(ncmpcpp_pid)"
        else
            # launch if not running
            hyprctl dispatch exec "[workspace special:nc] kitty -e ncmpcpp"
        fi
        #outputs count eg 1
        #hyprctl clients | grep -A3 "class: kitty" | grep -cE "title:\s*nc"
    fi
}

function focus_current_player () {
    local displaying_player=$(active_player)
    local spotify=$(grab_spotify_pid)
    hyprctl reload

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
            case "$1" in
                "kitty_nc_launch")
                    hyprctl dispatch exec "[workspace special:nc] kitty -e ncmpcpp"
                    ;;
                "")
                    #launch_focus_if_nc_running
                    hyprctl dispatch togglespecialworkspace nc
                    ;;
            esac
            ;;
    esac
}

focus_current_player "$1"

