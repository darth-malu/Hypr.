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
                dunstify "QUITING"\
                    -i "/home/malu/Downloads/ICONS/icons8-cross-lineal-color/icons8-cross-64.png"
                kill_kitty
                #exit 0
                ;;
            "b"|"B")
                remove_old_snapshots
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

function create_lvm_snapshot() {
    local VG_NAME="ARCH"
    local LV_NAME="root_lv"
    local SNAPSHOT_NAME="darth_snapshot_$(date +'%Y%m%d%H%M%S')"
    local SNAPSHOT_SIZE="1G" # Adjust as needed


    # Create a snapshot in the background
    sudo lvcreate --size $SNAPSHOT_SIZE --snapshot --name $SNAPSHOT_NAME /dev/$VG_NAME/$LV_NAME &
    local SNAPSHOT_PID=$!

    # Optionally, wait for snapshot creation to complete
    wait $SNAPSHOT_PID

    # Check if snapshot creation was successful
    if [ $? -eq 0 ]; then
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

    # Find the current snapshot (if any)
    #local CURRENT_SNAPSHOT=$(sudo lvdisplay | grep "Snapshot" | awk -F': ' '/Name/ {print $2}' | grep "^${SNAPSHOT_NAME_PREFIX}")
    #local CURRENT_SNAPSHOT=$(sudo lvs | awk '/darth.*/ {print $0}' | awk '{$1=$1; print}')
    #local SNAPSHOTS_PRESENT=$(sudo lvs --noheadings -o lv_name,vg_name | grep "^${SNAPSHOT_NAME_PREFIX}")

    local SNAPSHOTS_PRESENT=$(sudo lvs --noheadings -o lv_name | tr -d "[:blank:]" | grep "^${SNAPSHOT_NAME_PREFIX}")


    if [ ! -z "$SNAPSHOTS_PRESENT" ]; then
        dunstify "Removing old snapshot: $SNAPSHOTS_PRESENT"\
            -i "/home/malu/Downloads/ICONS/icons8-trash-color/icons8-trash-96.png"\
            -t 3200\
            -r 11

        # Remove snaps one by one
        for SNAP in ${SNAPSHOTS_PRESENT}; do
            local LV_PATH="$VG_PATH/${SNAP}"
            echo "Removing snapshot: $LV_PATH"
            sudo lvremove -f $LV_PATH 2>&1 | tee -a /tmp/lvremove.log
            #LV_PATH="/dev/$(echo $SNAP | awk '{print $2"/"$1}')"
        done

        #no confirm with -f
        if [ $? -ne 0 ]; then
            dunstify -t 3200 "Failed to remove old snapshot. Exiting." \
                -i "/home/malu/Downloads/ICONS/icons8-unavailable-color-hand-drawn"\
                -r 11
            exit 1
        fi

        # On success of deletion
        create_lvm_snapshot
    fi
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
