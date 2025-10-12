#!/bin/bash
# Save current mode
xrandr | grep '*' | awk '{print $1}' > /tmp/original_mode

# Get new mode
WIDTH=$1
HEIGHT=$2
MODELINE=$(cvt $WIDTH $HEIGHT 60 | grep Modeline | sed 's/Modeline //')
MODENAME=$(echo $MODELINE | awk '{print $1}')
xrandr --newmode $MODELINE
xrandr --addmode DP-0 $MODENAME
xrandr --output DP-0 --mode $MODENAME
