#!/bin/sh

export XCURSOR_SIZE=24

autorandr --change

xset s 3600 3600
xset dpms 3600 3600 3600

exec i3
