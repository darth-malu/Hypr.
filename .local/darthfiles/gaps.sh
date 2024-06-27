#!/bin/bash

msgTag="hypr_gaps"

function set_gaps() {
    hyprctl keyword dwindle:no_gaps_when_only $1
}

function get_gaps_status() {
    # returns bool 0/1(off/on)
    hyprctl getoption dwindle:no_gaps_when_only | grep int | cut -d ' ' -f2
}

function current_gap_size () { 
    #outputs clean number eg. 10
    hyprctl getoption general:gaps_out | grep custom | cut -d ' ' -f3
}

function gap_out_toggle () {
        local gap_status=$(get_gaps_status)
        case $gap_status in
        "1")
            dunstify -t 1000 -a "changegaps" -u low -i ~/.local/darthfiles/iconss/gap_on.png \
                -h string:x-dunst-stack-tag:$msgTag "Gaps:True" 
            set_gaps 0 
            ;;
        "0")
            dunstify -t 1000 -a "changegaps" -u low -i ~/.local/darthfiles/iconss/gap_off.png -h string:x-dunst-stack-tag:$msgTag "Gaps:Zero" 
            set_gaps 1 
            ;;
        *)
            dunstify -t 1000 -a "changegaps" -u low -i icons/volume-off-solid -h string:x-dunst-stack-tag:$msgTag "Error in gaps_out_toggle " 
            ;;
        esac
}

function gap_incrementer () {
    #toggle gaps on/off or increase/decrease by 1
    current_gap=$(current_gap_size)
    add_gap="increment_gap"
    decr_gap="decrease_gap"
    max_gap_size=50
    min_gap_size=0
    custom_gap=8
    counter=2
    tog="toggle_gaps_out"
    #no_gaps="-"
    #add_gaps="+"

    case $1 in
        $add_gap)
            if [[ $current_gap -lt $max_gap_size ]]
            then
                new_gap=$(( $current_gap + $counter ))
                hyprctl keyword general:gaps_out $new_gap
                dunstify -t 1000 -a "changegaps" -u low -i ~/.local/darthfiles/iconss/up.png -h string:x-dunst-stack-tag:$msgTag "Gaps out: $new_gap" 
            fi
            ;;
        $decr_gap)
            if [[ $current_gap -gt $min_gap_size ]];then
                new_gap=$(( $current_gap - $counter ))
                hyprctl keyword general:gaps_out $new_gap
                dunstify -t 1000 -a "changegaps" -u low -i ~/.local/darthfiles/iconss/down3.png -h string:x-dunst-stack-tag:$msgTag "Gaps out: $new_gap" 
            fi
            ;;
        $tog)
            gap_out_toggle
            ;;
        "reset")
            hyprctl keyword general:gaps_out $min_gap_size
            dunstify -t 1000 -a "changegaps" -u low -i icons/volume-off-solid -h string:x-dunst-stack-tag:$msgTag "Gaps reset to: $min_gap_size" 
            ;;
        "custom")
            hyprctl keyword general:gaps_out $custom_gap
            dunstify -t 1000 -a "changegaps" -u low -i icons/volume-off-solid -h string:x-dunst-stack-tag:$msgTag "Gaps set to custom size : $custom_gap" 
            ;;
        *)
            dunstify "Something is wrong with gap_incrementer"
            ;;
    esac
}
# Ensure the script is called with an argument
if [[ $# -eq 0 ]]; then
    dunstify "Usage: $0 {increment_gap|decrease_gap|toggle_gaps_out|custom}"
    exit 1
fi

gap_incrementer "$1"

