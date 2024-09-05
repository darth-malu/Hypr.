#!/usr/bin/env bash


function get_charger_status(){
    # path to charger file / charger status / connected-disconnected
    # 0 - off, 1, on

    
    STATUS="$(cat /sys/class/power_supply/ADP1/online)"
    echo $STATUS
}

function dunstify_charger_status() {
    local charger_status="$(get_charger_status)"

    case "$charger_status" in
        1)
            notify-send "Charger Status" "Charger connected"
            ;;
        0)
            notify-send "Charger Status" "Charger unplugged"
            ;;
        *)
            notify-send "Charger Status" "Unknown charger status"
            ;;
    esac
}

dunstify_charger_status

#
