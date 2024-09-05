#!/bin/bash

msgTag="Waybareload"

reload_hide ()
{
    local tog="toggle_hide"
    local r="reload"

    case "$1" in
        "$tog")
            dunstify -t 1000 -a "changegaps" -u low -i ~/.darth/iconss/toggle_way.png -h string:x-dunst-stack-tag:$msgTag "Waybar Toggle" 
            pkill -SIGUSR1 waybar
            ;;
        "$r")
            ~/.darth/scripts/launch_waybar.sh &
            dunstify -t 1000 -a "changegaps" -u low -i ~/.darth/iconss/rreload.png -h string:x-dunst-stack-tag:$msgTag "Waybar Reloaded   " 
            ;;
    esac
}

reload_hide "$1"
