#!/bin/bash

msgTag="hypr_gaps"

function set_gaps() {
    case $1 in
        "0")
            hyprctl keyword dwindle:no_gaps_when_only $1
            hyprctl keyword general:gaps_out 4
            ;;
        "1")
            hyprctl keyword dwindle:no_gaps_when_only $1
            hyprctl keyword general:gaps_out 0
            ;;
        "2")
            hyprctl keyword dwindle:no_gaps_when_only $1
            hyprctl keyword general:gaps_out 4
            ;;
    esac
}

function get_gaps_status() {
    # returns bool 0/1(off/on)
    hyprctl getoption dwindle:no_gaps_when_only | grep int | cut -d ' ' -f2
}

function current_gaps_out_size () { 
    #outputs clean number eg. 10
    hyprctl getoption general:gaps_out | grep custom | cut -d ' ' -f3
}

function gap_out_toggle () {
        local gap_status=$(get_gaps_status)
        case $gap_status in
        "1")
            dunstify -t 1000 -a "changegaps" -u low -i ~/.darth/iconss/gap_on.png \
                -h string:x-dunst-stack-tag:$msgTag "Gaps:True" 
            set_gaps 0 
            ;;
        "0")
            dunstify -t 1000 -a "changegaps" -u low -i ~/.darth/iconss/gap_off.png -h string:x-dunst-stack-tag:$msgTag "Gaps:Zero" 
            set_gaps 1 
            ;;
        *)
            dunstify -t 1000 -a "changegaps" -u low -i icons/volume-off-solid -h string:x-dunst-stack-tag:$msgTag "Error in gaps_out_toggle " 
            ;;
        esac
}

function gaps_in_size () { 
    #outputs clean number eg. 2
    hyprctl getoption general:gaps_in | grep custom | cut -d ' ' -f3
}

function gap_incrementer () {
    #toggle gaps on/off or increase/decrease by 1
    #gaps_out
    local current_gap_out=$(current_gaps_out_size)
    local max_gap_out_size=50
    local min_gaps_out_size=0
    local counter_gaps_out=2
    local custom_gap_out=3
    #Gaps in
    local current_gap_in=$(gaps_in_size)
    local max_gap_in_size=50
    local min_gap_in_size=2
    local default_gaps_in=4
    local counter_gaps_in=2
    #toggle
    local tog="toggle_gaps_out"
    #no_gaps="-"
    #add_gaps="+"

    case $1 in
        "gaps_in_add")
            if [[ $current_gap_in -lt $max_gap_in_size ]]
            then
                local new_gap=$(( $current_gap_in + $counter_gaps_in ))
                hyprctl keyword general:gaps_in ${new_gap}
                dunstify -t 1000 -a "changegaps" -u low -i ~/.darth/iconss/up.png -h string:x-dunst-stack-tag:$msgTag "Gaps in: $new_gap" 
            fi
            ;;
        "gaps_in_sub")
            if [[ $current_gap_in -ge $min_gap_in_size ]]
            then
                local new_gap=$(( $current_gap_in - $counter_gaps_in ))
                hyprctl keyword general:gaps_in ${new_gap}
                dunstify -t 1000 -a "changegaps" -u low -i ~/.darth/iconss/down3.png -h string:x-dunst-stack-tag:$msgTag "Gaps in: $new_gap" 
            fi
            ;;
        "gaps_in_reset")
            hyprctl keyword general:gaps_in $default_gaps_in
            dunstify -t 1000 -a "changegaps" -u low -i ~/.darth/iconss/down3.png -h string:x-dunst-stack-tag:$msgTag "Gaps reset to default $default_gaps_in" 
            ;;
        "increment_gap")
            if [[ $current_gap_out -le $max_gap_out_size ]]
            then
                local new_gap=$(( $current_gap_out + $counter_gaps_out ))
                hyprctl keyword general:gaps_out $new_gap
                dunstify -t 1000 -a "changegaps" -u low -i ~/.darth/iconss/up.png -h string:x-dunst-stack-tag:$msgTag "Gaps out: $new_gap" 
            fi
            ;;
        "decrease_gap")
            if [[ $current_gap_out -gt $min_gaps_out_size ]];then
                local new_gap=$(( $current_gap_out - $counter_gaps_out ))
                hyprctl keyword general:gaps_out $new_gap
                dunstify -t 1000 -a "changegaps" -u low -i ~/.darth/iconss/down3.png -h string:x-dunst-stack-tag:$msgTag "Gaps out: $new_gap" 
            fi
            ;;
        "toggle_gaps_out")
            gap_out_toggle
            ;;
        "reset")
            hyprctl keyword general:gaps_out $min_gaps_out_size
            dunstify -t 1000 -a "changegaps" -u low -i icons/volume-off-solid -h string:x-dunst-stack-tag:$msgTag "Gaps reset to: $min_gaps_out_size" 
            ;;
        "custom")
            #hyprctl keyword general:gaps_out $custom_gap_out
            hyprctl keyword general:gaps_out $custom_gap_out
            dunstify -t 1000 -a "changegaps" -u low -i icons/volume-off-solid -h string:x-dunst-stack-tag:$msgTag "Gaps set to custom size : $custom_gap_out" 
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

