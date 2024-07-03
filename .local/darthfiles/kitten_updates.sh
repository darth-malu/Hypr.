#!/bin/bash

fetch_updates () {
    #checkupdates --nocolor | cut -d ' ' -f1 2>&1
    checkupdates --nocolor|cut -d ' ' -f1
}

kitten_inject () {
    local pkgs=$(fetch_updates)

    local temp_file="$(mktemp /media/linux_hdd/update_history_script/temp_pac_qi_array/pac_updates.XXXXXX.txt)"

    # Check if the temporary file was created successfully
    if [ ! -e "$temp_file" ]; then
        echo "Failed to create temporary file"
        exit 1
    fi

    for pkg in ${pkgs}; do
        pacman -Qi "${pkg}" >> "$temp_file"
    done
    less -F "$temp_file" && rm $temp_file
}

dunsst_after () {
    local msgTag="pacman"
    dunstify -t 3000 -a "pacman_update" -u critical -i "~/.local/darthfiles/iconss/pacman.png" \
        -h string:x-dunst-stack-tag:$msgTag "Pacman updated packages"
}

dunsst_aur () {
    local msgTag="pacman"
    dunstify -t 3000 -a "aur_update" -u critical -i "~/.local/darthfiles/iconss/pacman.png" \
        -h string:x-dunst-stack-tag:$msgTag "AUR updated packages"
    pkill -RTMIN+8 waybar
}

kill_kitty () {
    kitty @ close-window --match env:KITTY_WINDOW_ID=$KITTY_WINDOW_ID
}

display_or_not () {
    local pkg=$(fetch_updates)
    echo -e "The packages to be updated are listed below :\n"
    echo -e "${pkg} \n" 
    echo -e "would you like to see more verbose info on the packages? : \n \n* Yes\t\t - 1, \n* No\\t\t - None\n* HALT\t\t - 3\n* Pick Choice: "
    read choice
    echo "You picked: ${choice}"

    case ${choice} in
        "1")
            kitten_inject \
                && sudo pacman -Syu \
                && pkill -RTMIN+8 waybar \
                && dunsst_after
            ;;
        "3")
            dunstify "QUITING"
            kill_kitty
            #exit 0
            ;;
        *)
            sudo pacman -Syu \
                && pkill -RTMIN+8 waybar \
                && dunsst_after
            ;;
    esac
}

aur_or_main () {
    case $1 in
        "aur")
            paru -Sua && dunsst_aur
            ;;
        "main")
            display_or_not
            ;;
    esac
    kill_kitty
    #kitten @ close-window --match 'all'
    #kitty @ close-window --match env:KITTY_WINDOW_ID=$KITTY_WINDOW_ID
}

aur_or_main "$1"
