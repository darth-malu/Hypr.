#!/bin/bash

msg="battery_shut"

# Paths for storing state
STATE_FILE=~/.battery_state
NOTIFICATION_SENT_FILE=~/.notification_sent

function bat_lvl () {
    cat /sys/class/power_supply/BAT0/capacity
}

function bat_charging_state () {
    acpi -b | cut -d ',' -f1 | cut -d ' ' -f3
}

function count_down () {
    hyprctl notify -1 10000 "rgb(ff1ea3)" "Battery inaisha ... weka charger"
    canberra-gtk-play -i alarm-clock-elapsed -d "BatteryDie"
}

function notify_charger_connected() {
    hyprctl notify -1 4000 "rgb(ff0000)" "Charger connected"
    canberra-gtk-play -i bell -d "$msg" -V 5
}

function notify_battery_full() {
    hyprctl notify -1 4000 "rgb(00ff00)" "Battery is fully charged- Disconnect charger"
    canberra-gtk-play -i phone-incoming-call -d "$msg" -V 5
}

function get_last_charge_state() {
    # check if STATE_FILE exitst then display contents
    if [[ -f $STATE_FILE ]]; then
        cat $STATE_FILE
    else
        echo "Unknown"
    fi
}

function update_last_charge_state() {
    echo "$1" > $STATE_FILE
}

function get_notification_sent_status() {
    if [[ -f $NOTIFICATION_SENT_FILE ]]; then
        cat $NOTIFICATION_SENT_FILE
    else
        echo "false"
    fi
}

function set_notification_sent_status() {
    echo "$1" > $NOTIFICATION_SENT_FILE
}

function bat_check () {
    local low_bat_threshold=20
    local healthy_threshold=30
    local critical_battery=10
    local danger_battery=5

    local batt=$(bat_lvl)
    local charge_state=$(bat_charging_state)
    local last_charge_state=$(get_last_charge_state)
    local notification_sent=$(get_notification_sent_status)

    if [[ $charge_state == "Discharging" ]]; then
        if [[ $batt -le $healthy_threshold ]]; then
            hyprctl dismissnotify
            hyprctl notify -1 4000 "rgb(ff0000)" "fontsize:15 Battery at 30%"
            #count_down
        fi

        if [[ $batt -le $threshold ]]; then
            if [[ $notification_sent == "false" ]]; then
                hyprctl notify -1 4000 "rgb(ff0000)" "fontsize:15 Battery less than $threshold %"
                canberra-gtk-play -i bell -d "$msg" -V 5
                set_notification_sent_status "true"
            fi

            if [[ $batt -le $critical_battery ]]; then
                hyprctl dismissnotify
                hyprctl notify -1 4000 "rgb(ff0000)" "fontsize:15 Battery critical $critical_battery % shutting down soon. Save your work."
                count_down
            fi


            if [[ $batt -le $danger_battery ]]; then
                hyprctl dismissnotify
                echo "$(date)" >> ~/Documents/last_shut_script_date.txt
                shutdown now
            fi
        fi

    elif [[ $charge_state == "Charging" ]]; then
        if [[ $last_charge_state != "Charging" && $notification_sent == "false" ]]; then
            notify_charger_connected
            set_notification_sent_status "true"
        fi

        if [[ $batt -eq 100 ]]; then
            notify_battery_full
            set_notification_sent_status "false"
            canberra-gtk-play -i bell -d "$msg" -V 5
        fi

    else
        set_notification_sent_status "false"
    fi

    update_last_charge_state "$charge_state"
}

bat_check
