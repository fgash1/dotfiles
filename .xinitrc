#!/bin/sh

export XCURSOR_SIZE=24

xrandr --output HDMI-0 --primary --auto --output DVI-D-0 --auto --left-of HDMI-0

xset s 3600 3600
xset dpms 3600 3600 3600

exec i3
