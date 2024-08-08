#!/usr/bin/env bash

dunst_after () {
    local msgTag="pacman"
    dunstify -t 3000 \
        -a "pacman_update" \
        -u critical \
        -i "/home/malu/Downloads/ICONS/icons8-pacman-cloud/icons8-pacman-100.png" \
        -h string:x-dunst-stack-tag:$msgTag "Pacman updated packages"
}

dunst_aur () {
    local msgTag="pacman"
    dunstify -t 3000 \
        -a "aur_update" \
        -u critical \
        -i "~/.darth/iconss/pacman.png" \
        -h string:x-dunst-stack-tag:$msgTag "AUR updated packages"
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

#less_pkgss () {
    #local updates="$(raw_updates)"
#
    ## Each line of output becomes an element in the array
    #IFS=$'\n' read -d '' -r -a updates_array <<< "$updates"
#}

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
            ${newline_tab}Snapshot${tab}->${tab}B\
            ${newline_tab}Less${atab}1\
            ${newline_tab}Minimal${atab}2\
            ${newline_tab}CLEAR${atab}x\
            ${newline_tab}HALT${atab}0\
            ${newline_tab}Quiet${dtab}->${tab}Default\
            \n\n"

        local choice
        read -p "       => " choice

        case "$choice" in
            #MINIMA
            "2")
                printf "\n=> minimalist mode\v\v"
                printf "\t\t\t** sed magic is working...\n\n"
                minimal_update_display
                ;;
            #verbose/less -lol
            "1")
                printf "\n ~> Verbose mode\n"
                less_pkgs
                ;;
            #clear
            "x"|"X")
                clear
                printf "\n\t=> Cleared Screen... Usafi muhimu\n"
                ;;
            #HALT
            0|"q")
                dunstify "QUITING"\
                    -i "/home/malu/Downloads/ICONS/icons8-cross-lineal-color/icons8-cross-64.png"
                kill_kitty
                #exit 0
                ;;
            "b"|"B")
                # create new snapshots / delete old snaps
                remove_old_snapshots
                ;;
            #Default -> quiet
            # exit loop and update
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

function create_lvm_snapshot() {
    local VG_NAME="ARCH"
    local LV_NAME="root_lv"
    local SNAPSHOT_NAME="darth_snapshot_$(date +'%Y%m%d%H%M%S')"
    local SNAPSHOT_SIZE="1G" # Adjust as needed

    # Create a snapshot & Check if snapshot creation was successful
    if sudo lvcreate --size $SNAPSHOT_SIZE --snapshot --name $SNAPSHOT_NAME /dev/$VG_NAME/$LV_NAME 2> /tmp/lvcreate_error.log; then
        echo
        dunstify "Snapshot $SNAPSHOT_NAME created successfully."\
            -i "/home/malu/Downloads/ICONS/icons8-check-mark-windows-11-color/icons8-check-mark-96.png"\
            -r 11\
            -t 4000
    else
        dunstify "Snapshot creation failed."\
            -i "/home/malu/Downloads/ICONS/icons8-cancel-blue-field/icons8-cancel-100.png"\
            -r 11\
            -t 4000
        exit 1
    fi
}

remove_old_snapshots () {
    local VG_NAME="ARCH"
    local VG_PATH="/dev/$VG_NAME"
    local SNAPSHOT_NAME_PREFIX="darth"

    # Find existing snapshots
    local SNAPSHOTS_PRESENT=$(sudo lvs --noheadings -o lv_name | tr -d "[:blank:]" | grep "^${SNAPSHOT_NAME_PREFIX}")

    # remove snapshots if exists
    if [ -n "$SNAPSHOTS_PRESENT" ]; then
        dunstify "Removing old snapshot: $SNAPSHOTS_PRESENT"\
            -i "/home/malu/Downloads/ICONS/icons8-trash-color/icons8-trash-96.png"\
            -t 3200\
            -r 11
        sleep 1

        # Remove snaps one by one
        for SNAP in ${SNAPSHOTS_PRESENT}; do
            local LV_PATH="$VG_PATH/${SNAP}"
            printf "\t%s\n\n" "Removing snapshot: $LV_PATH"
            #echo -e "Removing snapshot: $LV_PATH \n"

            if ! sudo lvremove -f $LV_PATH 2>&1 | tee -a /tmp/lvremove.log; then
                dunstify "Failed to remove old snapshot. Exiting." \
                    -i "/home/malu/Downloads/ICONS/icons8-unavailable-color-hand-drawn" \
                    -r 11 \
                    -t 3200 
                exit 1
            fi
        done

    fi

    # create a new Snapshot after delete operation
    create_lvm_snapshot
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
            dunstify "Invalid option: $1" \
                -i "/home/malu/Downloads/ICONS/icons8-cancel-3d-plastilina/icons8-cancel-69.png" \
                -t 3200 \
                -r 11
            ;;
    esac
    kill_kitty
    #kitten @ close-window --match 'all'
    #kitty @ close-window --match env:KITTY_WINDOW_ID=$KITTY_WINDOW_ID
}

launcher "$1"
