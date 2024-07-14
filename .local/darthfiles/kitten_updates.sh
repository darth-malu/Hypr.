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
    exit 0
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
                #pacman -Qi "$update" | less -F -X -R -S -K 
                pacman -Qi "$update" >> "${temp_file}"
                #echo
                #wait $!  # Wait for less to finish
    done <<< "$updates"

    less -F "$temp_file" && rm "$temp_file"
}

sed_pkgs () 
{
    while read -r update; do
        pacman -Qi "$update" | sed -n -e "1p" -e "3p" -e "8p" -e "11p" -e "12p" | nl  
        printf "\n"
    done <<< "$updates"
}


display_or_not () {
    #set -x
    #is single line delimeted by spaces eg. pkg1 pkg2 pkg3
    #local all_updates=$(display_updates_only)

    printf "\t\t\tPackages to be updated are:\n"
    printf "\t\t\t...........................\n"
    echo "${updates}"
    echo

    while true;do
        printf "\t\t\tChoose update style\n"
        printf "\t\t\t...................\n"

        #quiet = 1(default), verbose = 1,  minimal =2, halt =3, verbose = 1
        printf "\n\tquiet\t\t~>\t*Default\n\tverbose\t\t  \t 1\n\tminimal \t\t 2\n\tCLEAR\t\t  \t x\n\tHALT\t\t  \t 0\n\n"

        local choice
        read -p "       \`=> " choice

        case ${choice} in

            #verbose
            1)
                printf "\n ~> Verbose mode\n"
                printf "\t **Less is launching to display pacman -Qi pkgs \n\n"
                sleep 1;less_pkgs 
                ;;

            #Minimal
            2)
                printf "\n ~> minimalist mode\n"
                printf "\t\t** sed magic is working...\n\n"
                sleep 1;sed_pkgs 
                ;;
            "x")
                printf "\n\t Clearing Screen... Usafi muhimu\n"
                clear
                ;;

            #HALT
            0)
                dunstify "QUITING"
                kill_kitty
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
