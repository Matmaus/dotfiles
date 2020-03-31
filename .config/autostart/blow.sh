#!/bin/bash

# An experimental "Battery Low for i3" warning script written in pure bash.
# This script is actually created mostly for WM users.
# As we know that most WMs do not warn us on low battery levels and this
# causes a lot of problems sometimes. This also works on tty terminals without X
# if you use ssh or something. I hope this script will help you to solve those
# problems :)

# you can customize things at VARIABLES section. Set your personal
# wave, mp3 file to play when your battery decreases to $CURRENT_BATTERY_VALUE
# you can also use commands like i3-nagbar instead of ringing a sound or even espeak :D
# If you want to find more sounds go to https://freesound.org
# make it run at startup and enjoy! don't let your data being lost :)

# written by savolla https://github.com/savolla/blow.


while true;
do
sleep 60 # every 60 seconds blow will check the battery status

#                 _       _     _
#__   ____ _ _ __(_) __ _| |__ | | ___  ___
#\ \ / / _` | '__| |/ _` | '_ \| |/ _ \/ __|
# \ V / (_| | |  | | (_| | |_) | |  __/\__ \
#  \_/ \__,_|_|  |_|\__,_|_.__/|_|\___||___/


CURRENT_STATUS_OF_BATTERY=`acpi --battery | awk '{print $3}' | sed s/,//g`              # Usually "Charging" of "Discharging"
CURRENT_BATTERY_VALUE=`acpi --battery | awk '{print $4}' | sed s/%,//g`                 # Persentage of your remaining battery value
AVARAGE=15                                                                              # Warning message begin to appeare every $DELAY
CRITICAL=7                                                                              # Computer will be suspended
DELAY=60                                                                                # Delay between warning messages

    if [ $CURRENT_STATUS_OF_BATTERY == "Charging" ];
    then
       continue

    else if [ $CURRENT_BATTERY_VALUE -lt $CRITICAL ];
    then
        sleep 120 # Possibility to kill this script after return from suspending
        systemctl suspend

    else if [ $CURRENT_BATTERY_VALUE -lt $AVARAGE ];
    then

       while true;
       do
           CURRENT_STATUS_OF_BATTERY=`acpi --battery | awk '{print $3}' | sed s/,//g`
           sleep 1

           if [ $CURRENT_STATUS_OF_BATTERY == "Charging" ];
           then
               break
           else
               notify-send -u critical -t 60000 "LOW BATTERY" "$CURRENT_BATTERY_VALUE %"
               sleep $DELAY
           fi
       done
    fi
    fi
done
