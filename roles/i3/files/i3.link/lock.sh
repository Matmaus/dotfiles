#!/bin/bash
# suspend message display
pkill -u "$USER" -USR1 dunst

# lock the screen
i3lock -n -i ~/.wallpapers/lock.png --tiling --ignore-empty-password

# resume message display
pkill -u "$USER" -USR2 dunst
