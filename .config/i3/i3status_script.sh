#!/bin/bash

# shell scipt to prepend i3status with more stuff
i3status --config ~/.config/i3status/config | while :
do
    read line
    LG=$(setxkbmap -query | awk '/layout/{print $2}')
    if [ $LG == "us" ]
    then
        dat="[{ \"full_text\": \" $LG\", \"color\":\"#009E00\" },"
    else
        dat="[{ \"full_text\": \" $LG\", \"color\":\"#C60101\" },"
    fi
    echo "${line/[/$dat}" || exit 1
done

# for non colored mode
#i3status --config ~/.config/i3status/config | while :
#do
#        read line
#        LG=$(setxkbmap -query | awk '/layout/{print $2}') 
#        echo " $LG | $line" || exit 1
#done
