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
    #returns % eg 90
}

playerctl_add_sub () {
    #playerctl -p $1 volume 0.1$2
    playerctl -p $1 volume 0.02$2
}

mpc_add_sub () 
{
    mpc volume ${1}2
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
            dunstify -t 1000 -a "changeVolume" -u low -i ~/.darth/iconss/spotify.png \
                -h string:x-dunst-stack-tag:$msgTag "Spotify                  $volume   " -h int:value:"$volume"
            ;;
        "Lollypop")
            playerctl_add_sub $current_player $add_minus 
            local volume=$(current_volume $current_player)
            dunstify -t 1000 -a "changeVolume" -u low -i ~/.darth/iconss/lolly.png \
                -h string:x-dunst-stack-tag:$msgTag "Lollypop                  $volume" -h int:value:"$volume"
            ;;
        "mpd")
            mpc_add_sub $add_minus && ~/.darth/scripts/songinfo.sh "ncmpcpp_volume"
            #local volume=$(mpc volume | tr -dc '[:digit:]')
            #dunstify -t 1000 -a "changeVolume" -u low -i ~/.darth/iconss/lolly.png \
                #-h string:x-dunst-stack-tag:$msgTag "MPC                  $volume   " -h int:value:"$volume"
            
            ;;
    esac
}


player_volume "$1"
