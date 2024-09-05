#!/bin/sh
killall waybar

#load the configuration based on the username

if [[ $USER == "malu" ]]
then
    waybar -c ~/.config/waybar/config.jsonc -s ~/.config/waybar/style.css
else
    waybar &
fi
