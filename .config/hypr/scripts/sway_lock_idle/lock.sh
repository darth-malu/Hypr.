#!/bin/bash

swaylock \
	--indicator-radius 100 \
	--indicator-thickness 7 \
    --indicator-caps-lock \
    --font JetBrainsMono \
    --clock \
    --image $HOME/Pictures/wallpaper/op.jpg\
	--ring-color bb00cc \
	--key-hl-color 880033 \
	--line-color 00000000 \
	--inside-color 00000088 \
	--separator-color 00000000 \
	--daemonize \
    --grace 60 \
    --ignore-empty-password 
