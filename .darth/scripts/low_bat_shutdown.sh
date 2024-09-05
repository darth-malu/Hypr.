#!/bin/bash

msg="battery_shut"
# Battery threshold (percentage)
threshold=5
critical_battery=3

function bat_lvl () {
    acpi -b | grep -Po '[0-9]+(?=%)'
} #outputs number without the %

function bat_charging_state () {
    acpi -b | cut -d ',' -f1 | cut -d ' ' -f3
} #outputs Discharging or Charging

function count_down () {
    #dunstify -u critical -h string:x-dunst-stack-tag:$msg "Battery inaisha ... weka charger"
    #hyprctl notify -1 5000 "rgb(ff0000)" "fontsize:13 Battery $(bat_lvl) % ... weka charger"
    hyprctl notify -1 10000 "rgb(ff1ea3)" "Battery inaisha ... weka charger"
    canberra-gtk-play -i audio-volume-change -d "$msg"
}

function shut () {
    count_down ; sleep 1 ; shutdown now  
}


while true;do
    batt=$(bat_lvl)
    charging=$(bat_charging_state)
    dis="Discharging"
    cha="Charging"

    if [[ $dis == true ]]; then
        if [[ $batt -lt 20 ]];then
            hyprctl notify -1 4000 "rgb(ff0000)" "fontsize:14 battery less than 20 %"
            canberra-gtk-play -i audio-volume-change -d "$msg"
            until [[ $charging == $cha ]]
            do
                if [[ $batt -le $threshold ]];then
                    hyprctl notify -1 5000 "rgb(ff0000)" "fontsize:14 shutting down soon"
                    if [[ $batt -le $critical_battery ]]; then
                        hyprctl dismissnotify ; echo "$(date)" > ~/Documents/last_shut_script_date.txt
                        shut 
                    else
                        dunstify "Loop error"
                    fi
                fi
                # Wait for some time before checking again (e.g., 5 minutes)
                sleep 300 # 300 seconds = 5 minutes
            done
        fi
    elif [[ $cha == true ]];then
        canberra-gtk-play -i audio-volume-change -d "$msg"
        hyprctl notify -1 4000 "rgb(ff0000)" "charger connected"
    fi
done
