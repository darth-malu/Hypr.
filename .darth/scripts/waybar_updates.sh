#!/usr/bin/env bash

dunst_after () {
    local msgTag="pacman"
    dunstify -t 3000 -a "pacman_update" -u critical -i "~/.darth/iconss/pacman.png" -h string:x-dunst-stack-tag:$msgTag "Pacman updated packages"
}

dunst_aur () {
    local msgTag="pacman"
    dunstify -t 3000 -a "aur_update" -u critical -i "~/.darth/iconss/pacman.png" -h string:x-dunst-stack-tag:$msgTag "AUR updated packages"
}

kill_kitty () {
    pkill -RTMIN+8 waybar
    kitty @ close-window --match env:KITTY_WINDOW_ID=$KITTY_WINDOW_ID
    #exit 0
}

raw_updates () {
    checkupdates --nocolor --nosync | cut -f 1 -d ' '
    #outputs list of updats...in single line?
}

less_pkgs () 
{
    local updates=$(raw_updates)

    #pacman -Qi "$update" | less -F -X -R -S -K 
    # Iterate over each update, fetch its details and redirect output to $tempfile
    while read -r update; do
        pacman -Qi "$update"
    done <<< "$updates" | less -F

}

minimal_update_display () {
    local updates="$(raw_updates)"

    while read -r update;do
        printf "%s\n" "-- $update"
        pacman -Qi "$update" | awk '/^Description/ || /^URL/ || /^Provides / || /^Depends On / || /^Optional Deps/ || /^Required by/ || /^Optional For/ { print "\t" $0 }'   
        printf "\n"
    done <<< "$updates"
    #outputs updates one by one to STDOUT
}

less_pkgss () {
    local updates="$(raw_updates)"

    # Each line of output becomes an element in the array
    IFS=$'\n' read -d '' -r -a updates_array <<< "$updates"
}

main () {
    local tabs='\t\t\t'
    printf "${tabs}Packages to be updated are:\n"
    printf "${tabs}...........................\n"

    #Formate updates
    while read -r update;do
        printf "\t%s\n" "${update}"
        #echo "$update"
    done <<< "$(raw_updates)"
    echo

    while true;do
        local newline_tab='\n\t'
        local tab='\t'
        local dtab='\t\t'
        local atab='\t\t \t'

        printf "${tabs}Choose update style:\n"
        printf "${tabs}...................."

        printf "
        ${newline_tab}minimal${atab}1\
            ${newline_tab}less${atab}2\
            ${newline_tab}CLEAR${atab}x\
            ${newline_tab}HALT${atab}0\
            ${newline_tab}quiet${dtab}->${tab}Default\
            \n\n"

        local choice
        read -p "       => " choice

        case "$choice" in
            #MINIMA
            "1")
                printf "\n=> minimalist mode\v\v"
                printf "\t\t\t** sed magic is working...\n\n"
                minimal_update_display
                ;;
            #verbose/less -lol
            "2")
                printf "\n ~> Verbose mode\n"
                less_pkgs
                ;;
            #clear
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

    pacsyu () {
        sudo pacman -Syu \
            && dunst_after
    }
    pacsyu
}

launcher () {
    case "$1" in
        "main")
            main
            ;;
        "aur")
            paru -Sua && sleep 1 && dunst_aur
            ;;
        *)
            dunstify "Invalid option: $1"
            ;;
    esac
    kill_kitty
    #kitten @ close-window --match 'all'
    #kitty @ close-window --match env:KITTY_WINDOW_ID=$KITTY_WINDOW_ID
}

launcher "$1"
