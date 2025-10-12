#!/bin/bash
ORIGINAL_MODE=$(cat /tmp/original_mode)
xrandr --output DP-0 --mode $ORIGINAL_MODE
