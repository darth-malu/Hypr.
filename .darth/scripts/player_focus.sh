#!/usr/bin/env bash

function active_player() {
    playerctl metadata --format '{{ playerName }}'
}


grab_spotify_pid () {
    #extracts as pid: xxxx 
    hyprctl clients | grep -i -A3 Spotify | grep pid | tr -d '[:blank:]' 
}


ncmpcpp_pid () {
    hyprctl clients | awk 'BEGIN { FS="\n" ; RS=""; OFS="\n" ; ORS = "\n\n"} /^Window.*ncmpcpp.*/ { print $14, $NF }'| sed -n 1p| tr -d '[:blank:]'
}

launch_focus_if_nc_running () {
    #check if nc process is up && a window  exists under class:kitty , title: nc*
    local nc=$(pgrep ncmpcpp)

    # if process exists look for pid else launch it
    # True if string length != 0; ie there is a value(nc pid) in the var (nc)

    if [[ -n $nc ]];then
        local nc_pid=$(ncmpcpp_pid)
        if [[ -n $nc_pid ]];then
            # focus running instance of ncmpcpp
            #hyprctl dispatch togglespecialworkspace nc
            hyprctl dispatch focuswindow "$nc_pid"
        else
            # launch ncmpcpp if not running
            #hyprctl dispatch exec "[workspace special:nc] kitty -e ncmpcpp"

            # workspace rule oncreate empty hehe
            hyprctl dispatch togglespecialworkspace nc
        fi

        #outputs count eg 1
        #hyprctl clients | grep -A3 "class: kitty" | grep -cE "title:\s*nc"
    # if ncmpcpp is not running
    else
        hyprctl dispatch togglespecialworkspace nc
    fi
}

function focus_current_player () {
    local displaying_player=$(active_player)
    local spotify=$(grab_spotify_pid)
    hyprctl reload

    case ${displaying_player} in
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
            #create special:nc or toggle nc with ncmpcpp   
            launch_focus_if_nc_running
            #hyprctl dispatch togglespecialworkspace nc
            ;;
    esac
}

focus_current_player "$1"

