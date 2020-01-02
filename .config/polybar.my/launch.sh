#!/usr/bin/env sh

## Add this to your wm startup file.

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch Polybar
# polybar -c ~/.config/polybar/config.ini top &
# polybar -c ~/.config/polybar/config.ini bottom &
# MONITOR=eDP1 polybar -c ~/.config/polybar/config.ini top &
MONITOR=eDP1 polybar -r -c ~/.config/polybar.my/config.ini bottom &
# MONITOR=DP2-2 polybar -c ~/.config/polybar/config.ini top &
MONITOR=DP2-2 polybar -r -c ~/.config/polybar.my/config.ini bottom &
# MONITOR=HDMI1 polybar -c ~/.config/polybar/config.ini top &
MONITOR=HDMI1 polybar -r -c ~/.config/polybar.my/config.ini bottom &
