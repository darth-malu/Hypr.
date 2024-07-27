#!/bin/bash

generate_preview () {
    local music_dir="/home/malu/Music"
    local previewdir="$XDG_CONFIG_HOME/ncmpcpp/previews"
    local filename="$(mpc --format "$music_dir"/%file% current)"
    local previewname="$previewdir/$(mpc --format %album% current | base64).png"
    [ -e "$previewname" ] || ffmpeg -y -i "$filename" -an -vf scale=90:90 "$previewname" > /dev/null 2>&1
    #dunstify -r 27072 "$(mpc --format '\t%title%\t\n\n \t%artist%\t\n \t%album%\t' current)" -i "$previewname"
    #dunstify -r 27072 "$(mpc --format '\t%title%\t\n \t%artist%\t\n \t%album%\t' current)" -i "$previewname"
    dunstify -r 27072 "$(mpc --format '\t%title%\t\n\n \t%artist%\t\n \t%album%\t' current)" -i "$previewname"
}


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

generate_preview
