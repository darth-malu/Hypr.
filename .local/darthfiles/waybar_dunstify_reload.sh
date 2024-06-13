#!/bin/bash

msgTag="Waybareload"



function reload_hide () {
    tog="toggle_hide"
    r="reload"
    if [[ $1 == $tog ]];then
        dunstify -t 1000 -a "changegaps" -u low -i ~/.local/darthfiles/iconss/wayset.png -h string:x-dunst-stack-tag:$msgTag "Waybar Toggle" 
        pkill -SIGUSR1 waybar
    elif [[ $1 == $r ]];then
        bash ~/.config/waybar/launch_waybar.sh &
        dunstify -t 1000 -a "changegaps" -u low -i ~/.local/darthfiles/iconss/rreload.png -h string:x-dunst-stack-tag:$msgTag "Waybar Reloaded" 
    fi
}

reload_hide $1
