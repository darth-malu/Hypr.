#! /sbin/env bash

#input

function pick_rgb() {
    # outputs rgba(,,,1.0)
    hyprpicker -f rgb - | sed 's/^/rgba(/; s/$/,1.0)/; y/ /,/
}

hyprpicker
hyprpicker -anf rgb | tr ' ' ','
#format
