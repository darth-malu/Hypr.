#!/bin/bash

msgTag="Waybareload"

reload_hide ()
{
    case "$1" in
        "toggle_hide")
            dunstify -t 1000 -a "changegaps" -u low -i ~/.darth/iconss/toggle_way.png -h string:x-dunst-stack-tag:$msgTag "Waybar Toggle" 
            pkill -SIGUSR1 waybar
            ;;
        "reload")
            ~/.darth/scripts/waybar/launch_waybar.sh &
            dunstify -t 1000 -a "changegaps" -u low -i ~/.darth/iconss/rreload.png -h string:x-dunst-stack-tag:$msgTag "Waybar Reloaded   " 
            ;;
    esac
}

#launch_reload() {
    #if [[ pgrep waybar ]];then
        #reload_hide "$1"
    #else
        #sh -c 'launch_waybar.sh'
    #fi
#
#}

reload_hide "$1"

