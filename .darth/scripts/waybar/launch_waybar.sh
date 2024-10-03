#!/bin/dash

#killall waybar

#load the configuration based on the username

if pidof waybar; then killall waybar ;fi 

if  [ "$USER" = "malu" ]
then
    waybar -c "$HOME/.config/waybar/config.jsonc" -s "$HOME/.config/waybar/style.css"
else
    waybar &
fi
