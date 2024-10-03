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
        -i "/home/malu/Downloads/ICONS/icons8-pacman-cloud/icons8-pacman-100.png" \
        -h string:x-dunst-stack-tag:$msgTag "AUR updated packages"
}

kill_kitty () {
    pkill -RTMIN+8 waybar
    kitty @ close-window --match env:KITTY_WINDOW_ID="$KITTY_WINDOW_ID"
}

raw_updates () {
    checkupdates --nocolor --nosync | cut -f 1 -d ' '
    #outputs list of updates each in \n 
}

less_pkgs () 
{
    #pacman -Qi "$update" | less -F -X -R -S -K 
    # Iterate available updates, fetch its details(p -Qi) and redirect thefinal aggregaated output to less
    while read -r update; do
        pacman -Qi "$update"
    done < <(raw_updates ) | less
}

minimal_update_display () {
    while read -r update;do
        printf "%s\n" "-- $update"
        pacman -Qi "$update" | awk '/^Description/ || /^URL/ || /^Provides / || /^Depends On / || /^Optional Deps/ || /^Required by/ || /^Optional For/ { print "\t" $0 }'   
        printf "\n"
    done < <(raw_updates)
}

create_lvm_snapshot() {
    local VG_NAME="ARCH"
    local LV_NAME="root_lv"
    local SNAPSHOT_SIZE="1G" # Adjust as needed
    local SNAPSHOT_NAME

    SNAPSHOT_NAME="darth_snapshot_$(date +'%Y%m%d%H%M%S')"

    # Create a snapshot & Check if snapshot creation was successful then dunstify
    if sudo lvcreate --size "$SNAPSHOT_SIZE" --snapshot --name "$SNAPSHOT_NAME" /dev/$VG_NAME/$LV_NAME 2> /tmp/lvcreate_error.log; then
        echo
        dunstify "Snapshot $SNAPSHOT_NAME created successfully. "\
            -i "/home/malu/Downloads/ICONS/icons8-check-mark-windows-11-color/icons8-check-mark-96.png"\
            -r 11\
            -t 4000
    else
        dunstify "Snapshot creation failed. "\
            -i "/home/malu/Downloads/ICONS/icons8-cancel-blue-field/icons8-cancel-100.png"\
            -r 11\
            -t 4000
        exit 1
    fi
}

remove_old_snapshots () {
    local VG_NAME='ARCH'
    local VG_PATH="/dev/$VG_NAME"
    local SNAPSHOT_NAME='darth.*'

    # Assign snapshots prefixed "darth" to $SNAPSHOTS_PRESENT
    local SNAPSHOTS_PRESENT
    SNAPSHOTS_PRESENT="$(sudo lvs --noheadings -o lv_name | tr -d '[:blank:]' | grep "$SNAPSHOT_NAME")"

        # Find existing snapshots and store them in an array
    IFS=$'\n' read -r -d '' -a SNAPSHOTS_PRESENT < <(sudo lvs --noheadings -o lv_name | grep -o "$SNAPSHOT_NAME" | tr -d '[:blank:]' && printf '\0')

    # remove snapshots if exists
    if [ -n "$SNAPSHOTS_PRESENT" ]; then
        dunstify "Removing old snapshot: $SNAPSHOTS_PRESENT "\
            -i "/home/malu/Downloads/ICONS/icons8-trash-color/icons8-trash-96.png"\
            -t 3200\
            -r 11
        sleep 1

        # Remove snaps one by one
        for SNAP in ${SNAPSHOTS_PRESENT}; do
            local LV_PATH="$VG_PATH/${SNAP}"
            printf "\t%s\n\n" "Removing snapshot: $LV_PATH"
            #echo -e "Removing snapshot: $LV_PATH \n"

            if ! sudo lvremove -f "$LV_PATH" 2>&1 | tee -a /tmp/lvremove.log; then
                dunstify "Failed to remove old snapshot. Exiting.   " \
                    -i "/home/malu/Downloads/ICONS/icons8-unavailable-color-hand-drawn" \
                    -r 11 \
                    -t 3200 
                exit 1
            fi
        done
    else
        printf '\t\t%s\n\t%s\n\n' "No Snapshots found in your system :)... NO need Delete." "Hail vaxry"
    fi
}

main () {
    local tabs="\t\t"
    printf "$tabs%s \n"         "Packages to be updated are:"
    printf "$tabs%s\n"          "..........................."

    #Format updates
    while read -r update;do
                #printf "\n\t\t\t     minimalist mode     \v"
        printf "\t%s\n" "${update}"
        #echo "$update"
    done < <(raw_updates)
    printf "\n\n"

    local newline_tab="\n\t"

    while true;do
        #echo -e "
            #${newline_tab}Snapshot${tab}->${tab}B\
            #${newline_tab}Del. Snapshot${tab}->${tab}D\
            #${newline_tab}Less${atab}1\
            #${newline_tab}Minimal${atab}2\
            #${newline_tab}CLEAR${atab}x\
            #${newline_tab}HALT${atab}0\
            #${newline_tab}Quiet${dtab}->${tab}Default\n\n" 

            # Refactored for easier maintenance
        printf "$tabs %s\n"                             "View pkg info."
        printf "$tabs %s"                             ".............."
        printf "$newline_tab%-33s %-35s " "Less" "1"
        printf "$newline_tab%-33s %-35s\n " "Minimal" "2"

        printf "\n$tabs%s\n"                                "BackUp and Delete LVM:"
        printf "$tabs%s"                              "......................"

        printf "$newline_tab%-34s%-25s "    "Del. Snapshot" "D"
        printf "$newline_tab%-34s%-20s\n\n "           "Snapshot" "B"

        printf "$tabs%s\n"                                " Choose update style:"
        printf "$tabs%s"                                " ...................."

        printf "$newline_tab%-34s%-39s "     "CLEAR" "x"
        printf "$newline_tab%-34s%-39s "     "HALT" "0"
        printf "$newline_tab%-20s%s%10s\n\n "     "Quiet, <Enter>" "   ->      " "Default"

        # Prompt user input -> And store choice in var
        local choice
        read -rp "       => " choice

        case $choice in
            #MINIMA
            2)
                #printf "\n\t\t\t     minimalist mode     \v"
                #printf "\n\t\t\t     minimalist mode     \v"
                printf "\n\t\t\t     minimalist mode     \n"
                printf "\t\t\t%s\n\n" "-> Awk magic is working...**"
                minimal_update_display
                ;;
            #verbose/less -lol
            1)
                printf "\n$tabs%s\n" "     -> Verbose mode     "
                less_pkgs
                ;;
            #clear
            [xX])
                clear
                printf "\n\t     Cleared Screen... Usafi muhimu     \n"
                ;;
            #HALT
            [0q])
                dunstify "     QUITING     "\
                    -i "/home/malu/Downloads/ICONS/icons8-cross-lineal-color/icons8-cross-64.png"
                kill_kitty
                #exit 0
                ;;
            #"b"|"B"
            [bB])
                # create new snapshots after removing old ones with a recency of 1
                remove_old_snapshots
                create_lvm_snapshot
                ;;
            [dD])
                # Delete snapshots (incase of breaking updates)
                remove_old_snapshots
                ;;
            "")
                break
                ;;

            *)
                printf '\n\t\t%s\n\n' "++++ Invalid Choice 1,2,3,blank ++++";continue
                ;;
        esac

    done
}


launcher () {
    case "$1" in
        "main")
            if main;then sudo pacman -Syu --noconfirm && dunst_after;fi
            ;;
        "aur")
            printf "\t\t\t%s\n" "AUR Packages to be updated are:"
            printf "\t\t\t%s\n" "..............................."

            #Format updates
            while read -r update;do
                printf "\t\t%s\n" "$update"
            done < <(paru -Qqu)
            echo

            paru --skipreview -Sua && dunst_aur
            ;;
        *)
            dunstify \
                "Invalid option: $1" \
                -i "/home/malu/Downloads/ICONS/icons8-cancel-3d-plastilina/icons8-cancel-69.png" \
                -t 3200 \
                -r 11
            ;;
    esac
    kill_kitty
    exit 0
}
launcher "$1"
