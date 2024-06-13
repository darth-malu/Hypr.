#!/bin/bash

msgTag="mpris_volume"

# Function to convert a single value from 0.0-1.0 to percentage
convert_to_percentage() {
    local value=$1
    #echo "scale=2; $value * 100" | bc
    #echo "scale=2; $value * 100" | bc
    #awk  '{print int("$value" * 100)}'

    local percentage=$(echo "scale=2; $value * 100 / 1" | bc)
    printf "%.0f" "$percentage"
    #returns %
}

function playerctl_add_sub () {
    playerctl -p $1 volume 0.1$2
}

function query_playerctl () {
    playerctl -l
}

function player_volume () {
    local add_minus=$1
    local players=$(query_playerctl)

    for player in $players;do
        #$(playerctl -l | grep -q spotify)#outputs silent success 1 or zero fail
        local playing_status=$(playerctl -p $player status 2>/dev/null)

        if [[ $player == *"spotify"* ]] && [[ $playing_status == "Playing" ]]; then 
            playerctl_add_sub $player $add_minus 
            local volume=$(playerctl -p $player volume)
            local volume_percentage=$(convert_to_percentage $volume)
            dunstify -t 1000 -a "changeVolume" -u low -i ~/.local/darthfiles/iconss/spotify.png \
                -h string:x-dunst-stack-tag:$msgTag "Spotify    $volume_percentage%" -h int:value:"$volume_percentage"
                            #break
        elif [[ $player == *"Lollypop"* ]] && [[ $playing_status == "Playing" ]]; then
            playerctl_add_sub $player $add_minus 
            local volume=$(playerctl -p $player volume)
            local volume_percentage=$(convert_to_percentage $volume)
            dunstify -t 1000 -a "changeVolume" -u low -i ~/.local/darthfiles/iconss/lolly.png \
                -h string:x-dunst-stack-tag:$msgTag "Lollypop    $volume_percentage%" -h int:value:"$volume_percentage"
        fi
    done
}

player_volume $@

