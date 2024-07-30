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

function sink_switcher (){
    #local sinks=$(get_current_sink)
    local speaker="Family 17h"
    local earphones="Ellesmere HDMI"
    local easy="Easy"
    local ear_pic="$HOME/Downloads/ICONS/icons8-airpods-pro-max-windows-11-color/airpods-pro-max-100.png"
    local speaker_pic="$HOME/.darth/iconss/speaker_94.png"
    local easy_pic="$HOME/.darth/iconss/ez.png"

    local speaker_ID=$(sink_getter $speaker)
    local earphones_ID=$(sink_getter $earphones)
    local easy_sink_ID=$(sink_getter $easy)

    if [[ $1 == "speaker" ]];then
        wpctl set-default $speaker_ID
        dunstify -t 1000 -a "changeVolume" -u low -i  "$speaker_pic"\
            -h string:x-dunst-stack-tag:$msg "         Speakers " 
    elif [[ $1 == "earphones" ]];then
        wpctl set-default $earphones_ID
        dunstify -t 1000 -a "changeVolume" -u low -i  "$ear_pic"\
            -h string:x-dunst-stack-tag:$msg "        Earphones  " 
    elif [[ $1 == "easy" ]];then
        wpctl set-default $easy_sink_ID
        dunstify -t 1000 -a "changeVolume" -u low -i  "$easy_pic"\
            -h string:x-dunst-stack-tag:$msg "        Easy  " 
    fi
}


function dunst_func() {
    local int_volume=$(get_volume)
    local zero=0
    local max=100
    local output_medium=$(get_current_sink)
    local speaker="Family 17h"
    local earphones="Ellesmere HDMI"
    local easy="Easy Effects"
    local speaker_ID=$(sink_getter $speaker)
    local earphones_ID=$(sink_getter $earphones)
    local easy_sink_ID=$(sink_getter $easy)

    case $1 in
        "add_sub")
            if [[ $int_volume -eq $zero ]];then
                dunstify -t 1000 -a "changeVolume" -u low -i ~/.darth/iconss/no_s.png \
                    -h string:x-dunst-stack-tag:$msgTag "Volume Zero" 
            elif [[ $int_volume -eq $max ]];then
                dunstify -t 1000 -a "changeVolume" -u low -i ~/.darth/iconss/audio1.png \
                    -h string:x-dunst-stack-tag:$msgTag "Volume Maxxed out" 
            else
                case $output_medium in
                    $speaker_ID)
                        dunstify -t 1000 -a "changeVolume" -u low -i ~/.darth/iconss/speaker_40blue.png \
                            -h string:x-dunst-stack-tag:$msgTag -h int:value:"$int_volume" "                 ${int_volume}    "
                        ;;
                    $earphones_ID)
                        dunstify -t 1000 -a "changeVolume" -u low -i ~/.darth/iconss/ear_blue_40.png \
                            -h string:x-dunst-stack-tag:$msgTag -h int:value:"$int_volume" "                 ${int_volume}"
                        ;;
                    $easy_sink_ID)
                        dunstify -t 1000 -a "changeVolume" -u low -i ~/.darth/iconss/ez.png \
                            -h string:x-dunst-stack-tag:$msgTag -h int:value:"$int_volume" "                 ${int_volume}"
                        ;;
                esac
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

function set_volume () {
    local amount=5
    local mute_status=$(get_mute_status)

    case $1 in
        "toggle_mute")
            dunst_func mute
            ;;
        "speaker")
            sink_switcher speaker
            ;;
        "earphones")
            sink_switcher earphones
            ;;
        "easy")
            sink_switcher easy
            ;;
        *)
            wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ "$amount%$1" > /dev/null #1.0 is 100%
            dunst_func add_sub
    esac
}

set_volume $1

#canberra-gtk-play -i audio-volume-change -d "changeVolume" --volume=0.2

#d - description
#-i -  predefined event

#----------------------------LEGEND--------------------------------------------_#
# -h --> replacing notification.string:value .x-canonical-private-synchronous or x-dunst-stack-tag , the value is the name of the group of notifications for ez replacement/swap
#       - int:value for numbers/aka what is actually moving the progress bar
# -u --> urgency
#int_volume=$(awk "BEGIN {print int($float_volume * 100)}" ) #eg 0.52 to 52.
