#!/bin/bash
# changeVolume

# Arbitrary but unique message tag
msgTag="myvolume"

function get_volume {
    vol=$(wpctl get-volume @DEFAULT_SINK@ |cut -f2 -d ' ')
    clean_volume=$(printf "%.0f" $(echo "$vol * 100" |bc))
    echo "$clean_volume"
}

function send_dunst {
    vol=$(get_volume)
    dunstify -t 1000 -a "changeVolume" -u low -i sun -h string:x-dunst-stack-tag:$msgTag \
        -h int:value:"$vol" "Volume: ${vol}%"
}

function volume_display {
    vol=$(get_volume)
    dunstify -t 1000 -a "changeVolume" -u low -i sun -h string:x-dunst-stack-tag:$msgTag "Volume ${vol}%"
}

case $@ in 
    "toggle")
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle > /dev/null
        dunstify -t 1000 -a "changeVolume" -u low -i volume-xmark-solid \
            -h string:x-dunst-stack-tag:$msgTag "Volume muted" 
        ;;
    "GetVolume")
        volume_display
        ;;
    *)
        wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ "$@" > /dev/null #1.0 is 100%
        case $(get_volume) in 
            "0")
                dunstify -t 1000 -a "changeVolume" -u low -i volume-off-solid -h string:x-dunst-stack-tag:$msgTag "Volume Zero " 
                ;;
            "100")
                dunstify -t 1000 -a "changeVolume" -u low -i volume-off-solid -h string:x-dunst-stack-tag:$msgTag "Volume Maxxed out " 
                ;;
            *)
            send_dunst
        esac
        ;;
esac

# Play the volume changed sound
#canberra-gtk-play -i audio-volume-change -d "changeVolume"

#------------------------------------------------------------------------------------LEGEND--------------------------------------------------------------------_#
# -h --> replacing notification.string:value .x-canonical-private-synchronous or x-dunst-stack-tag , the value is the name of the group of notifications for ez replacement/swap
#       - int:value for numbers/aka what is actually moving the progress bar
# -u --> urgency


