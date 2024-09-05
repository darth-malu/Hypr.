#!/bin/bash

msgTag="myvolume"
msg="audio_device"

function get_volume () {
    #outputs clean number #eg 0.52 --> 52
    #wpctl get-volume @DEFAULT_SINK@ | cut -d ' ' -f2 | tr -d '.'

    # need bc/awk since its float arithmetic
    #wpctl get-volume @DEFAULT_SINK@ | cut -d ' ' -f2 | xargs -I {} sh -c 'printf "%.0f" $(echo "{} * 100" | bc )'

    wpctl get-volume @DEFAULT_SINK@ | cut -d ' ' -f2 | awk '{print int($1 * 100)}'
}

function get_mute_status () {
    #outputes MUTED if true

    wpctl get-volume @DEFAULT_SINK@ | cut -d ' ' -f3 | tr -d "[]"
}

function get_current_sink () {
    #wpctl status |sed -n '/Sinks:/,/^[[:space:]]*$/p'| sed -n '1,/^[[:space:]]*$/p' | grep -i "*"
    #outputs a number eg. 55 54 44
    #wpctl status | grep "*" | cut -d ' ' -f7 | tr -d '.'

    wpctl status |grep -A3 Sinks|sed "/--/q"| grep -o "*\s\+[0-9]\+\." | tr -cd [:digit:]
}

function sink_getter () {
    #outputs a number :  42 earphones , 44 easy , 55 speaker
    #wpctl status|grep -A3 Sinks| grep -oP '[│*]\s*(\d+)\.\s*([^\s]+)'|grep -oP "(\d+)" | sed -n "$1p"

    wpctl status|grep -A3 Sinks|sed "/--/q"|grep -oP '[│*]\s*(\d+)\.\s*([^\s]+)'|grep -i $1 |grep -oP "(\d+)"
}

dunst_laptop_speaker () {
    local int_volume=$(get_volume)
    case $1 in
        "add_sub")
            if [[ $int_volume -le 100 ]];then
                if [[ $int_volume -eq 0 ]];then
                    dunstify -t 1000 -a "changeVolume" -u low -i ~/.darth/iconss/no_s.png \
                        -h string:x-dunst-stack-tag:$msgTag "Volume Zero" 
                elif [[ $int_volume -eq 100 ]];then
                    dunstify -t 1000 -a "changeVolume" -u low -i ~/.darth/iconss/audio1.png \
                        -h string:x-dunst-stack-tag:$msgTag "Volume Maxxed out" 
                else
                    dunstify -t 1000 -a "changeVolume" -u low -i ~/.darth/iconss/speaker_40blue.png \
                        -h string:x-dunst-stack-tag:$msgTag -h int:value:"$int_volume" "                 ${int_volume}    "
                fi
            fi
            ;;
        "mute")
            if [[ $mute_status == MUTED ]];then
                wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 > /dev/null
                dunstify -t 1000 -a "changeVolume" -u low -i ~/.darth/iconss/lol.png \
                    -h string:x-dunst-stack-tag:$msgTag "Unmuted" 
            else
                wpctl set-mute @DEFAULT_AUDIO_SINK@ 1 > /dev/null
                dunstify -t 1000 -a "changeVolume" -u low -i ~/.darth/iconss/mute2.png \
                    -h string:x-dunst-stack-tag:$msgTag "MUTED" 
            fi
            ;;
    esac
}

laptop_volume() {
    local amount=5
    local mute_status=$(get_mute_status)

    case $1 in
        "toggle_mute")
            dunst_laptop_speaker mute
            ;;
        *)
            wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ "$amount%$1" > /dev/null #1.0 is 100%
            dunst_laptop_speaker add_sub
            ;;
    esac
}

laptop_volume $1
