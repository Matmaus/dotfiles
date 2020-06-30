#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch bar1 and bar2
MONITOR=eDP1 polybar -r -c ~/.config/polybar/config PolybarTop &
MONITOR=eDP1 polybar -r -c ~/.config/polybar/config PolybarBot &
MONITOR=DP2-2 polybar -r -c ~/.config/polybar/config PolybarTop &
MONITOR=DP2-2 polybar -r -c ~/.config/polybar/config PolybarBot &
MONITOR=HDMI1 polybar -r -c ~/.config/polybar/config PolybarTop &
MONITOR=HDMI1 polybar -r -c ~/.config/polybar/config PolybarBot &
