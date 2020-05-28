#!/usr/bin/sh
while true;
do
sleep 60 # every 60 seconds blow will check the battery status

#                 _       _     _
#__   ____ _ _ __(_) __ _| |__ | | ___  ___
#\ \ / / _` | '__| |/ _` | '_ \| |/ _ \/ __|
# \ V / (_| | |  | | (_| | |_) | |  __/\__ \
#  \_/ \__,_|_|  |_|\__,_|_.__/|_|\___||___/


CURRENT_STATUS_OF_BATTERY=$(acpi --battery | awk '{print $3}' | sed s/,//g)              # Usually "Charging" of "Discharging"
CURRENT_BATTERY_VALUE=$(acpi --battery | awk '{print $4}' | sed s/%,//g)             # Persentage of your remaining battery value
AVARAGE=15                                                                              # Warning message begin to appeare every $DELAY
CRITICAL=7                                                                              # Computer will be suspended
DELAY=60                                                                                # Delay between warning messages

    if [ "$CURRENT_STATUS_OF_BATTERY" = "Charging" ];
    then
       continue

    elif [ "$CURRENT_BATTERY_VALUE" -lt "$CRITICAL" ];
    then
        sleep 120 # Possibility to kill this script after return from suspending
        systemctl suspend

    elif [ "$CURRENT_BATTERY_VALUE" -lt "$AVARAGE" ];
    then

       while true;
       do
           CURRENT_STATUS_OF_BATTERY=$(acpi --battery | awk '{print $3}' | sed s/,//g)
           sleep 1

           if [ "$CURRENT_STATUS_OF_BATTERY" = "Charging" ];
           then
               break
           else
               notify-send -u critical -t 60000 "LOW BATTERY" "$CURRENT_BATTERY_VALUE %"
               sleep $DELAY
           fi
       done
    fi
done
