#!/bin/bash

msg="battery_shut"

function bat_lvl () {
    #acpi -b | grep -Po '[0-9]+(?=%)'
    cat /sys/class/power_supply/BAT0/capacity
    #outputs flat number without the % eg 79
} 

function bat_charging_state () {
    acpi -b | cut -d ',' -f1 | cut -d ' ' -f3
} #outputs Discharging or Charging

function count_down () {
    #canberra-gtk-play -i audio-volume-change -d "$msg"
    #canberra-gtk-play -i alarm-clock-elapsed -d "BatteryDie" -V 1

    hyprctl notify -1 10000 "rgb(ff1ea3)" "Battery inaisha ... weka charger"
    canberra-gtk-play -i alarm-clock-elapsed -d "BatteryDie"
}

# Function to notify user and play sound
function notify_charger_connected() {
    hyprctl notify -1 4000 "rgb(ff0000)" "Charger connected"
    #canberra-gtk-play -i bell -d "$msg" -V 5
}

# Function to notify when battery reaches 100%
function notify_battery_full() {
    hyprctl notify -1 4000 "rgb(00ff00)" "Battery is fully charged- Disconnect charger"
    canberra-gtk-play -i phone-incoming-call -d "$msg" -V 5
}


function bat_check () {
    local last_charge_state="unknown"
    local notification_sent=false
    local threshold=20
    local critical_battery=10
    local danger_battery=5

    local batt=$(bat_lvl)
    local charge_state=$(bat_charging_state)

    # Check battery discharging state
    if [[ $charge_state == "Discharging" ]]; then

        # Check if below threshold -20
        if [[ $batt -le $threshold ]]; then
            # Send notification if not already sent
            if ! $notification_sent; then
                hyprctl notify -1 4000 "rgb(ff0000)" "fontsize:15 battery less than $threshold %"
                canberra-gtk-play -i bell -d "$msg" -V 5
                notification_sent=true
            fi

            #battery less than 10
            if [[ $batt -le $critical_battery ]]; then
                #dismiss any current notif
                hyprctl dismissnotify 
                hyprctl notify -1 4000 "rgb(ff0000)" "fontsize:15 battery critical $critical_battery % shutting down soon . Save Your work"
                #hyprctl dismissnotify 
                count_down
                #return  # Exit the script before shutdown???? makes sense????
            fi

            # less than 5
            if [[ $batt -le $danger_battery ]]; then
                #dismiss any current notif
                hyprctl dismissnotify 
                #hyprctl notify -1 4000 "rgb(ff0000)" "fontsize:15 battery less than $danger_battery % shutting down..."
                echo "$(date)" >> ~/Documents/last_shut_script_date.txt
                shutdown now
                #return  # Exit the script before shutdown???? makes sense????
            fi
        fi
    elif [[ $charge_state == "Charging" ]]; then
        # check if was previously charging , if true check if notif was sent during chargins state
        if [[ $last_charge_state != "Charging" && $notification_sent == false ]]; then
            # canbrera + hyprnotif - charger connected
            notify_charger_connected
            notification_sent=true
        fi

        # Notify when battery is full
        if [[ $batt -eq 100 ]]; then
            notify_battery_full
            notification_sent=false
            canberra-gtk-play -i bell -d "$msg" -V 5
        fi

    else
        # unknown charge state -> see if necessary
        notification_sent=false
    fi

    # Update last charge state
    last_charge_state=$charge_state
}

bat_check
