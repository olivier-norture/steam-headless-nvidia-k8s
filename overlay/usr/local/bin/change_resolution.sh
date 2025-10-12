#!/bin/bash
xrandr | grep '*' | awk '{print $1}' > /tmp/original_mode

MODELINE=$(cvt $SUNSHINE_CLIENT_WIDTH $SUNSHINE_CLIENT_HEIGHT 60 | grep Modeline | sed 's/Modeline //')
MODENAME=$(echo $MODELINE | awk '{print $1}')
xrandr --newmode $MODELINE
xrandr --addmode DP-0 $MODENAME
xrandr --output DP-0 --mode $MODENAME
