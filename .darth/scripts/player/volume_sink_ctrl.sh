#!/bin/dash

msgTag="myvolume"
msg="audio_device"

get_volume () {
    #outputs clean number #eg 0.52 --> 52
    #wpctl get-volume @DEFAULT_SINK@ | cut -d ' ' -f2 | tr -d '.'

    # need bc/awk since its float arithmetic
    #wpctl get-volume @DEFAULT_SINK@ | cut -d ' ' -f2 | xargs -I {} sh -c 'printf "%.0f" $(echo "{} * 100" | bc )'
    #wpctl get-volume @DEFAULT_SINK@ | cut -d ' ' -f2 | awk '{print int($1 * 100)}'
    wpctl get-volume @DEFAULT_SINK@ | awk '{printf "%.0f\n", $2 * 100}'
}

get_mute_status () {
    #outputes MUTED if true
    wpctl get-volume @DEFAULT_SINK@ | cut -d ' ' -f3 | tr -d '[]'
}

get_current_sink () {
    #wpctl status |sed -n '/Sinks:/,/^[[:space:]]*$/p'| sed -n '1,/^[[:space:]]*$/p' | grep -i "*"
    #outputs a number eg. 55 54 44
    #wpctl status | grep "*" | cut -d ' ' -f7 | tr -d '.'
    wpctl status |grep -A3 Sinks|sed "/--/q"| grep -Eo "\*\s+[0-9]+" | tr -cd '[:digit:]'
}

sink_getter() {
    #outputs a number :  42 earphones , 44 easy , 55 speaker
    #wpctl status|grep -A3 Sinks| grep -oP '[│*]\s*(\d+)\.\s*([^\s]+)'|grep -oP "(\d+)" | sed -n "$1p"
    #sink_number="$(wpctl status|grep -A3 Sinks|sed "/--/q"|grep -oP '[│*]\s*(\d+)\.\s*([^\s]+)'|grep -i "$1" |grep -oP '(\d+)')"
    #sink_number=$(wpctl status | grep -A3 Sinks | sed '/--/q' | awk '/$1/ {print $0}' | grep -Eo '\* +[0-9]+' | tr -cd '[:digit:]')
    #wpctl status | grep -A3 Sinks | sed '/--/q' | awk -v name="$1" '$0 ~ name {print $0}' | grep -Eo '\*\s+[0-9]+' | tr -cd '[:digit:]'
    #wpctl status | grep -A3 Sinks | sed '/--/q' | awk -v name="$1" '$0 ~ name {print $0}' | grep -Eo '[0-9]+\.' | tr -cd '[:digit:]'
    #wpctl status | grep -A3 Sinks | sed '/--/q' | awk -v name="$1" '$0 ~ name {print $0}' | grep -Eo '[0-9]+\.\s+[a-zA-Z]+' | tr -cd '[:digit:]'
    wpctl status | grep -A3 Sinks | sed '/--/q' | grep "$1" | grep -Eo '[0-9]+\.\s+[a-zA-Z]+' | tr -cd '[:digit:]'
}

speaker_ID=$(sink_getter 'Family 17h')
earphones_ID=$(sink_getter 'Ellesmere HDMI')
easy_sink_ID=$(sink_getter 'Easy Effects')

sink_switcher (){
    #sinks=$(get_current_sink)
    local ear_pic
    local speaker_pic
    local easy_pic

    ear_pic="$HOME/Downloads/ICONS/icons8-airpods-pro-max-windows-11-color/airpods-pro-max-100.png"
    speaker_pic="$HOME/.darth/iconss/speaker_94.png"
    easy_pic="$HOME/.darth/iconss/ez.png"

    case $1 in
        "speaker")
            wpctl set-default "$speaker_ID"
            dunstify -t 1000 -a "changeVolume" -u low -i  "$speaker_pic"\
                -h string:x-dunst-stack-tag:$msg "         Speakers " 
            ;;
        "earphones")
            wpctl set-default "$earphones_ID"
            dunstify -t 1000 -a "changeVolume" -u low -i  "$ear_pic"\
                -h string:x-dunst-stack-tag:$msg "        Earphones  " 
            ;;
        "easy")
            wpctl set-default "$easy_sink_ID"
            dunstify -t 1000 -a "changeVolume" -u low -i  "$easy_pic"\
                -h string:x-dunst-stack-tag:$msg "        Easy  " 
            ;;
    esac
}

dunst_func() {
    local int_volume
    local output_medium
    local mute_status
    local speaker

    output_medium=$(get_current_sink)
    int_volume=$(get_volume)
    mute_status=$(get_mute_status)
    speaker='/home/malu/Downloads/ICONS/speaker/icons8-speaker-64.png'

    case $1 in
        "add_sub")
            if [ "$int_volume" -eq 0 ];then
                dunstify -t 1000 -a "changeVolume" -u low -i ~/.darth/iconss/no_s.png \
                    -h string:x-dunst-stack-tag:$msgTag "Volume Zero" 
            elif [ "$int_volume" -eq 100 ];then
                dunstify -t 1000 -a "changeVolume" -u low -i ~/.darth/iconss/audio1.png \
                    -h string:x-dunst-stack-tag:$msgTag "Volume Maxxed out" 
            else
                case $output_medium in
                    "$speaker_ID")
                        dunstify -t 1000 -a "changeVolume" -u low -i $speaker \
                            -h string:x-dunst-stack-tag:$msgTag -h int:value:"$int_volume" "${int_volume}"
                        ;;
                    "$earphones_ID")
                        dunstify \
                            -t 1000 -a "changeVolume" -u low -i ~/.darth/iconss/ear_blue_40.png \
                            -h string:x-dunst-stack-tag:$msgTag -h int:value:"$int_volume" "${int_volume}"
                        ;;
                    "$easy_sink_ID")
                        dunstify -t 1000 -a "changeVolume" -u low -i ~/.darth/iconss/ez.png \
                            -h string:x-dunst-stack-tag:$msgTag -h int:value:"$int_volume" "${int_volume}"
                        ;;
                esac
            fi
            ;;
        "mute")
            if [ "$mute_status" = "MUTED" ];then
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

set_volume () {
    local amount=2
    set -x

    case "$1" in
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

set_volume "$1"

#canberra-gtk-play -i audio-volume-change -d "changeVolume" --volume=0.2

#d - description
#-i -  predefined event

#----------------------------LEGEND--------------------------------------------_#
# -h --> replacing notification.string:value .x-canonical-private-synchronous or x-dunst-stack-tag , the value is the name of the group of notifications for ez replacement/swap
#       - int:value for numbers/aka what is actually moving the progress bar
# -u --> urgency
#int_volume=$(awk "BEGIN {print int($float_volume * 100)}" ) #eg 0.52 to 52.
