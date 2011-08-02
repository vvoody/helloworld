#!/usr/bin/bash

# cron this script hourly to release your neck ;-)
# by @vvoody, to my friend @ghosTM55

# xrandr -o {left, right, inverted}
orientations=([0]=left [1]=right [2]=inverted)

choice=$((RANDOM%${#orientations[@]}))
rotation=${orientations[$choice]}

if [ -x /usr/bin/xrandr ]; then
    xrandr -o $rotation
else
    echo "We need xrandr to run this script, but not found."
    exit 1
fi
# twist your neck a little & open your terminal and
# type 'xrandr -o normal' to make your screen normal ;-)
