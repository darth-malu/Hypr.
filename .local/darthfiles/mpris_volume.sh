#!/bin/bash

msgTag="mpris_volume"

# Function to convert a single value from 0.0-1.0 to percentage
convert_to_percentage() {
    #echo "scale=2; $value * 100" | bc
    #echo "scale=2; $value * 100" | bc
    #awk  '{print int("$value" * 100)}'

    local value=$1
    local percentage=$(echo "scale=2; $value * 100 / 1" | bc)
    printf "%.0f" "$percentage"
    #returns % percentage eg 100
}

playerctl_add_sub () {
    playerctl -p $1 volume 0.1$2
}

query_playerctl () {
    playerctl -l
}

current_volume () {
    convert_to_percentage $(playerctl -p $1 volume)
}

player_volume () {
    local current_player=$(playerctl metadata --format '{{ playerName }}')
    local add_minus=$1
    case $current_player in
        "spotify")
            playerctl_add_sub $current_player $add_minus 
            local volume=$(current_volume $current_player)
            dunstify -t 1000 -a "changeVolume" -u low -i ~/.local/darthfiles/iconss/spotify.png \
                -h string:x-dunst-stack-tag:$msgTag "Spotify    $volume%" -h int:value:"$volume"
            ;;
        "Lollypop")
            local volume=$(current_volume $current_player)
            playerctl_add_sub $current_player $add_minus 
            dunstify -t 1000 -a "changeVolume" -u low -i ~/.local/darthfiles/iconss/lolly.png \
                -h string:x-dunst-stack-tag:$msgTag "Lollypop    $volume_percentage%" -h int:value:"$volume_percentage"
            ;;
    esac
}

player_volume $1