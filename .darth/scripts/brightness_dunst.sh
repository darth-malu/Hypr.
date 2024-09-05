#!/bin/bash

msg="myBrightness"


function get_bright {
    brightnessctl g 
}

function max_bright {
    brightnessctl m
}

function dunstify_notification {
    brightness=$(get_bright)
    max_brightness=$(max_bright)
    percentage_brightness=$(( (brightness * 100)/max_brightness ))
    notify-send -t 1000 -a "changeBright" -u low -i sun -h string:x-dunst-stack-tag:$msg \
        -h int:value:"$percentage_brightness" "Brightness: ${percentage_brightness}%"
}

function bright() {
    local add="+"
    local sub="-"

    case $1 in
        "$add")
            brightness_current=$(get_bright)
            max_brightness=$(max_bright)

            if [[ $brightness_current -eq $max_brightness ]];then
                dunstify -t 1000 -a "changeBright" -u low -i volume-off-solid -h string:x-dunst-stack-tag:$msg "Brightness Maxxed out " 
            else
                brightnessctl s +5% > /dev/null
                dunstify_notification
            fi
            ;;
        "$sub")
            #can use set or s

            brightnessctl s 5%- > /dev/null
            dunstify_notification
            ;;
    esac
}

bright "$1"
