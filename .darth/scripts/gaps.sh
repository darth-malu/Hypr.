#!/bin/bash

function dwindle_or_master () {
    hyprctl getoption general:layout | grep str | cut -d ' ' -f2
}

layout=$(dwindle_or_master)
msgTag="hypr_gaps"
gaps_1="$(hyprctl keyword $layout:no_gaps_when_only 1)"
gaps_0="$(hyprctl keyword $layout:no_gaps_when_only 0)"

gaps_status=$(hyprctl getoption $layout:no_gaps_when_only | grep int | cut -d ' ' -f2)

function gap_adder () {
        case $gaps_status in
gap_incrementer
        "1")
            dunstify -t 1000 -a "changegaps" -u low -i volume-xmark-solid \
                -h string:x-dunst-stack-tag:$msgTag "Gaps:True" 
            $gaps_0 > /dev/null
            ;;
        "0")
            dunstify -t 1000 -a "changegaps" -u low -i icons/volume-off-solid -h string:x-dunst-stack-tag:$msgTag "Gaps:Zero " 
            $gaps_1 > /dev/null
            ;;
        *)
            dunstify -t 1000 -a "changegaps" -u low -i icons/volume-off-solid -h string:x-dunst-stack-tag:$msgTag "Error in gaps.sh " 
            ;;
        esac
}

function current_gap_size () { 
    #outputs clean number eg. 10
    hyprctl getoption general:gaps_out | grep custom | cut -d ' ' -f3
}

function gap_incrementer () {
    current_gap=$(current_gap_size)
    add_gap="+"
    decr_gap="-"
    toggle_gap="switch"

    case $1 in
        $add_gap)
            incrementer=1
            new_gap=$(( $current_gap + $incrementer ))
            hyprctl keyword general:gaps_out $new_gap
            dunstify -t 1000 -a "changegaps" -u low -i icons/volume-off-solid -h string:x-dunst-stack-tag:$msgTag "Gaps out: $new_gap" 
            ;;
        $decr_gap)
            decrementer=1
            until [[ $current_gap -eq 0 ]];do
                new_gap=$(( $current_gap - $decrementer ))
                hyprctl keyword general:gaps_out $new_gap
                dunstify -t 1000 -a "changegaps" -u low -i icons/volume-off-solid -h string:x-dunst-stack-tag:$msgTag "Gaps out: $new_gap" 
            done
            ;;
        $toggle_gap)
            add_gaps
            ;;
        *)
            dunstify "Something is wrong with gap_incrementer"
            ;;
    esac
}

