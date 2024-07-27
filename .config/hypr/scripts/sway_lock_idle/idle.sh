#!/bin/bash

swayidle -w \
	timeout 400 '/home/malu/Documents/dotfiles/hypr/scripts/sway_lock_idle/lock.sh' \
	timeout 410 '
		hyprctl monitors | grep HDMI
		ret=$?
        
        if [ $ret -eq 0 ]	
		then
			hyprctl dispatch dpms off DP-1
		else
			hyprctl dispatch dpms off eDP-1
		fi

        systemctl suspend' \
	resume '
		hyprctl monitors | grep HDMI
		ret=$?

		if [ $ret -eq 0 ]	
		then
			hyprctl dispatch dpms on DP-1
		else
			hyprctl dispatch dpms on eDP-1
		fi
		' \
	before-sleep '/home/malu/Documents/dotfiles/hypr/scripts/sway_lock_idle/lock.sh' \
	lock '/home/malu/Documents/dotfiles/hypr/scripts/sway_lock_idle/lock.sh'
