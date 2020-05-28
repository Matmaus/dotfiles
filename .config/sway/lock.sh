#!/bin/bash
# suspend message display
pkill -u "$USER" -USR1 dunst

# lock the screen
swaylock -n -k -l -i ~/.wallpapers/lock.png --tiling --ignore-empty-password

# resume message display
pkill -u "$USER" -USR2 dunst
