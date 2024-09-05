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

function shut () {
    count_down ; sleep 1 ; shutdown now  
}

# Function to notify user and play sound
function notify_charger_connected() {
    hyprctl notify -1 4000 "rgb(ff0000)" "Charger connected"
    canberra-gtk-play -i bell -d "$msg"
}

# Function to notify when battery reaches 100%
function notify_battery_full() {
    hyprctl notify -1 4000 "rgb(00ff00)" "Battery is fully charged"
    canberra-gtk-play -i phone-incoming-call -d "$msg"
}

function bat_check () {
    local last_charge_state=""
    local notification_sent=false
    local threshold=20
    local critical_battery=8

    local batt=$(bat_lvl)
    local charge_state=$(bat_charging_state)

    if [[ $charge_state == "Discharging" ]]; then
        if [[ $batt -lt $threshold ]];then
            hyprctl notify -1 4000 "rgb(ff0000)" "fontsize:14 battery less than 20 %"
            canberra-gtk-play -i bell -d "$msg"

            while [[ $charge_state == "Discharging" && $batt -le $threshold ]]; do    
                if [[ $batt -le $threshold ]];then
                    hyprctl notify -1 5000 "rgb(ff0000)" "fontsize:14 shutting down soon"
                    canberra-gtk-play -i bell -d "$msg"

                    if [[ $batt -le $critical_battery ]]; then
                        hyprctl dismissnotify 
                        echo "$(date)" > ~/Documents/last_shut_script_date.txt
                        shut 
                    else
                        dunstify "battery script Loop error"
                    fi
                fi
                # will use systemd timer for this
                # Wait for some time before checking again (e.g., 5 minutes)
                #sleep 300 # 300 seconds = 5 minutes

                # Update battery level and charging state
                local batt=$(bat_lvl)
                local charge_state=$(bat_charging_state)
            done
        fi
    elif [[ $charge_state == "Charging" ]]; then
        # when laststate changes from discharge to charging - mean charger connected and wont check if already charging
        # since laststate would be charging
        if [[ $last_charge_state != "Charging" && $notification_sent == false ]]; then
            # Charger connected
            notify_charger_connected
            # charger connected notif flag
            notification_sent=true
        fi

        if [[ $batt -eq 100 ]]; then
            # Battery full
            notify_battery_full
            # Reset the notification flag
            notification_sent=false
        fi
    else
        # If not charging, reset the notification flag
        notification_sent=false
    fi

    # Update last charge state
    last_charge_state=$charge_state

    # Wait before checking again
    #sleep 300  # Check every 5 minutes
}

bat_check
