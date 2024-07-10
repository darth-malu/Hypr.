#!/bin/bash

dunst_after () {
    local msgTag="pacman"
    dunstify -t 3000 -a "pacman_update" -u critical -i "~/.local/darthfiles/iconss/pacman.png" -h string:x-dunst-stack-tag:$msgTag "Pacman updated packages"
}

dunst_aur () {
    local msgTag="pacman"
    dunstify -t 3000 -a "aur_update" -u critical -i "~/.local/darthfiles/iconss/pacman.png" -h string:x-dunst-stack-tag:$msgTag "AUR updated packages"
    pkill -RTMIN+8 waybar
}

kill_kitty () {
    kitty @ close-window --match env:KITTY_WINDOW_ID=$KITTY_WINDOW_ID
}

display_updates_only () 
{
    #nocolor very important
    #prints out ansi color codes -yuck
    updates="$(checkupdates --nocolor | cut -d ' ' -f1)"
    for update in ${updates};do
        printf "\t%s\n" "${update}"
    done
}

display_updates_only 2> /dev/null
updates="$(display_updates_only)"

less_pkgs () 
{
    local temp_file="$(mktemp /media/linux_hdd/update_history_script/temp_pac_qi_array/pac_updates.XXXXXX.txt)"

    # Check if the temporary file was created successfully
    if [ ! -e "$temp_file" ]; then
        echo "Failed to create temporary file"
        exit 1
    fi

    # Iterate over each update, fetch its details and redirect output to $tempfile
    while read -r update; do
        pacman -Qi "$update" >> "$temp_file"
    done <<< "$updates"
    #less
    less -F "$temp_file" && rm "$temp_file"

    #alt way
    #display_updates_only | while read -r update; do
        #pacman -Qi "$update" >> "$temp_file"
    #done
}


display_or_not () {
    #set -x
    #is single line delimeted by spaces eg. pkg1 pkg2 pkg3
    #local all_updates=$(display_updates_only)

    printf "\t\t\tPackages to be updated are:\n"
    printf "\t\t\t...........................\n"
    echo "${updates}"
    echo

    printf "\t\tChoose update style\n"
    printf "\t\t...................\n"
    printf "\tQuiet\t\t~>\t*Default\n\tverbose\t\t  \t 1\n\tHALT\t\t  \t 0\n\n"
    #quiet = 1(default), minimal =2, halt =3, verbose = 1
    read -p "       \`~> " choice

    while true;do
        case ${choice} in

            #verbose
            1)
                printf "\npacman -Qi of packages (verbose)\n"
                printf "\nLess is launching to display pacman -Qi pkgs\n"
                sleep 1;less_pkgs ; break
                ;;

            #HALT
            0)
                dunstify "QUITING";break
                #exit 0
                ;;

            #Default -> quiet
            "")
                break
                ;;

            *)
                echo "Invalid Choice 1,2,3,blank";continue
                ;;
        esac
    done
    sudo pacman -Syu \
        && pkill -RTMIN+8 waybar \
        && dunst_after
}

aur_or_main () {
    case $1 in
        "aur")
            paru -Sua && dunst_aur
            ;;
        "main")
            display_or_not
            ;;
        *)
            dunstify "Invalid option: $1"
            #exit 1
            ;;
    esac
    kill_kitty
    #kitten @ close-window --match 'all'
    #kitty @ close-window --match env:KITTY_WINDOW_ID=$KITTY_WINDOW_ID
}

aur_or_main "$1"
