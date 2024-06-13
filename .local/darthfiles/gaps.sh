#!/bin/bash

msgTag="hypr_gaps"
#Addition logic
#get exact current gapsize(from hyprconf)
#increment func
#add by 1 with keybind
#decrease by 1 with keybind

function dwindle_or_master () {
    hyprctl getoption general:layout | grep str | cut -d ' ' -f2
}

#master/dwindle
layout=$(dwindle_or_master)

# set no_gaps_when_only to 1/0
function set_gaps() {
    hyprctl keyword $layout:no_gaps_when_only $1
}

# returns bool 0/1(off/on)
function get_gaps_status() {
    hyprctl getoption $layout:no_gaps_when_only | grep int | cut -d ' ' -f2
}

#used in gap_incrementer
function current_gap_size () { 
    #outputs clean number eg. 10
    hyprctl getoption general:gaps_out | grep custom | cut -d ' ' -f3
}

#dunstify the state of gaps = true/zero/error in scrpt after changing
#used in gap_incrementer tog case
function gap_out_toggle () {
        gap_status=$(get_gaps_status)
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

#toggle gaps on/off or increase/decrease by 1
function gap_incrementer () {
    current_gap=$(current_gap_size)
    add_gap="increment_gap"
    decr_gap="decrease_gap"
    max_gap_size=48
    min_gap_size=8
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
        *)
            dunstify "Something is wrong with gap_incrementer"
            ;;
    esac
}
# Ensure the script is called with an argument
if [[ $# -eq 0 ]]; then
    dunstify "Usage: $0 {increment_gap|decrease_gap|toggle_gaps_out}"
    exit 1
fi

gap_incrementer "$1"

