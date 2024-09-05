#!/bin/bash

# Check if the flash drive is mounted
if mountpoint -q /media/FlashMountPoint; then
    # Create the mount point if it doesn't exist
    mkdir -p ~/Music

    # Bind mount the Music folder to ~/music
    mountpoint -q ~/Music || mount --bind /media/flash/Music ~/Music
fi

