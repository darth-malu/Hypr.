#!/usr/bin/env bash

#$(kitty @ close-window --match env:KITTY_WINDOW_ID=$KITTY_WINDOW_ID)
btw_loop () {
    for i in {1..5}
    do
        echo 'Using Arch btw'
        sleep 0.2
    done

}

create_windows () {
    #for i in 1 2
        ##for i in {1..3}
    #do
    #done
    kitten @ launch --type=window --title="molly" --keep-focus cat
}

create_cat () {
    #fastfetch_file=$(mktemp fast.XXX.txt)
    btw_loop | kitten @ send-text --match 'title:molly' --stdin
}

create_quit () {
    create_windows
    create_cat
    sleep 1
    kitty @ close-window --match env:KITTY_WINDOW_ID=$KITTY_WINDOW_ID
}

create_quit

#fastfetch
