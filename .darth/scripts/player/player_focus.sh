#!/bin/dash

 active_player() {
    playerctl metadata --format '{{ playerName }}'
}

#legacy - unused ... Spotify focus working now
#grab_spotify_pid () {
    ##extracts as pid: xxxx 
    #hyprctl clients | grep -i -A3 Spotify | grep pid | tr -d '[:blank:]' 
#}

 focus_current_player () {
    local displaying_player

    displaying_player=$(active_player)
    #local spotify=$(grab_spotify_pid)
    hyprctl reload

    case ${displaying_player} in
        *"spotify"*)
            #hyprctl dispatch focuswindow ${spotify} > /dev/null
            # dispatch no stderr always ok stdout
            # hyprctl dispatch focuswindow Spotify > /dev/null
            hyprctl dispatch togglespecialworkspace nc
            ;;
        *"Lollypop"*)
            hyprctl dispatch focuswindow lollypop > /dev/null
            ;;
        *"firefox"*)
            hyprctl dispatch focuswindow firefox > /dev/null
            ;;
        *"mpd"*)
            #create special:nc or toggle nc with ncmpcpp   
            # launch_focus_if_nc_running
            hyprctl dispatch togglespecialworkspace nc
            ;;
    esac
}

focus_current_player "$1"

