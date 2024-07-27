#!/bin/bash

msgTag="Waybareload"

reload_hide ()
{
    tog="toggle_hide"
    r="reload"

    if [[ $1 == $tog ]];then
        dunstify -t 1000 -a "changegaps" -u low -i ~/.darth/iconss/toggle_way.png -h string:x-dunst-stack-tag:$msgTag "Waybar Toggle" 
        pkill -SIGUSR1 waybar
    elif [[ $1 == $r ]];then
        bash ~/.darth/scripts/launch_waybar.sh &
        dunstify -t 1000 -a "changegaps" -u low -i ~/.darth/iconss/rreload.png -h string:x-dunst-stack-tag:$msgTag "Waybar Reloaded" 
    fi
}

reload_hide $1
