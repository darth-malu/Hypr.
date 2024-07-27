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

updates_getter () 
{
    #nocolor very important
    #prints out ansi color codes -yuck
    #raw_updates="$(checkupdates --nocolor --nosync)"
    #echo "$raw_updates" | cut -d ' ' -f1
    checkupdates --nocolor --nosync | cut -d ' ' -f1
}

display_updates ()
{
    local updates=$(updates_getter)

    while read -r update;do
        printf "\t%s\n" "${update}"
        #echo "$update"
    done <<< "$updates"
}

less_pkgs () 
{
    local updates=$(updates_getter)

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
    local updates=$(updates_getter)

    while read -r update; do
        printf "%s\n" "-- $update" 
        #pacman -Qi "$update" | sed -n -e "3p" -e "8p" -e "11p" -e "12p" | nl  
        #pacman -Qi "$update" | sed -n -e "3p" -e "8p" -e "11p" -e "12p"| sed 's/^/\t/'   
        pacman -Qi "$update" | awk '/^Description/ || /^URL/ || /^Provides / || /^Depends On / || /^Optional Deps/ || /^Required by/ || /^Optional For/ { print "\t" $0 }'   
        printf "\n"
    done <<< "$updates"
}


display_or_not () {
    #set -x
    #is single line delimeted by spaces eg. pkg1 pkg2 pkg3
    #local all_updates=$(display_updates_only)
    local updates=$(display_updates)

    printf "\t\t\tPackages to be updated are:\n"
    printf "\t\t\t...........................\n"
    display_updates
    echo

    while true;do
        printf "\t\t\tChoose update style\n"
        printf "\t\t\t...................\n"

        #quiet = 1(default), verbose = 1,  minimal =2, halt =3, verbose = 1
        printf "\n\tquiet\t\t~>\t*Default \n\tverbose\t\t  \t 1\n\tminimal \t\t 2\n\tCLEAR\t\t  \t x\n\tHALT\t\t  \t 0 / q\n\n"

        local choice
        read -p "       \`=> " choice

        case ${choice} in

            #verbose
            1)
                printf "\n ~> Verbose mode\v"
                printf "**Less is launching to display pacman -Qi pkgs \n\n"
                less_pkgs 
                ;;

            #Minimal
            2)
                printf "\n=> minimalist mode\v\v"
                printf "\t\t\t** sed magic is working...\n\n"
                sed_pkgs 
                ;;
            "x")
                clear
                printf "\n\t=> Cleared Screen... Usafi muhimu\n"
                ;;

            #HALT
            0|"q")
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
