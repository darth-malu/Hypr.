#!/bin/bash

msgTag='mpris_volume'

generate_preview () {
    local music_dir="/home/malu/Music"
    local previewdir="$XDG_CONFIG_HOME/ncmpcpp/previews"
    local filename="$(mpc --format "$music_dir"/%file% current)"
    local previewname="$previewdir/$(mpc --format %album% current | base64).png"

    #[ -e "$previewname" ] || ffmpeg -y -i "$filename" -an -vf scale=128:128 "$previewname" > /dev/null 2>&1
    [ -e "$previewname" ] || ffmpeg -y -i "$filename" -an -vf scale=128:128 "$previewname" > /dev/null &> /dev/null
    echo "$previewname"
}

dunstify_preview () {
    local album_art="$(generate_preview)"
    local current_bitrate="$(mpc status %kbitrate%) kbps"
    notify-send -h string:x-dunst-stack-tag:$msgTag \
        -t 1600\
        "$(mpc --format '[[󰎍\t%title%\t\n][\t%audioformat%]\n \t%artist%\t\n \t%album%\t]] | [%file%]' current)" \
        -i "$album_art"
    #sampler‐ate:bits:channels -> %audioformat%
            #"$(mpc --format '󰎍\t%title%\t' current)" \
            #"$(mpc --format ' \t%artist%\t\n \t%album%\t' current)" \
            #"$(mpc --format '\t%title%\t\n\n \t%artist%\t\n \t%album%\t' current)" \
            #"$(mpc --format '󰎍 \t%title%\t\n \t%artist%\t\n \t%album%\t' current)" \
        #hyprctl clients | awk 'BEGIN { FS="\n" ; RS=""; OFS="\n" ; ORS = "\n\n"} /^Window.*nc.*/ { print $14, $NF }'| sed -n 1p| tr -d '[:blank:]'
}

mode () {
    case $1 in
        "ncmpcpp_volume")
            local tab=$(echo -e "\t")
            local album_art="$(generate_preview)"
            #local volume=$(mpc volume | tr -dc '[:digit:]')
            local volume=$(mpc volume | cut -d " " -f2 | tr -d '%')
            local title_artist=$(mpc --format "%title%\t󰎍\t$volume\t" current)
            dunstify -t 1000 \
                -a "changeVolume" -u low -i "$album_art" \
                -h string:x-dunst-stack-tag:$msgTag "$title_artist" \
                -h int:value:"$volume"
            ;;
        *)
            dunstify_preview
            ;;
    esac
}

mode "$1"


#[ -e "$previewname" ] || ffmpeg -y -i "$filename" -an -vf scale=128:128 "$previewname" > /dev/null 2>&1

#notify-send -r 27072 "Now Playing" "$(mpc --format '%title% \n%artist% - %album%' current)" -i "$previewname"
#dunstify -r 27072 "$(mpc --format '󰽰  %title% \n󰠃  %artist%  \n󰀥  %album%' current)" -i "$previewname"
#dunstify -r 27072 "$(mpc --format '󰎍  %title% \n󰠃  %artist%  \n󰀥  %album%' current)" -i "$previewname"
#dunstify -r 27072 "$(mpc --format '  %title% \n\n %artist%  \n  %album%' current)" -i "$previewname"
#dunstify -r 27072 "$(mpc --format '  %title% \n󰠃  %artist%  \n󰀥  %album%' current)" -i "$previewname"
#dunstify -r 27072 "$(mpc --format '󰎇 %title% \n  %artist%  \n󰀥  %album%' current)" -i "$previewname"           

#case "$2" in
    #"")
        #;;
    #"cover")
        #;;
#esac

#generate_preview
