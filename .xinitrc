#!/bin/sh

export XCURSOR_SIZE=24

# D-Bus/systemd-activated GUI helpers (e.g. the keyring's SSH passphrase prompter) need the display
dbus-update-activation-environment --systemd DISPLAY XAUTHORITY

autorandr --change

xset s 3600 3600
xset dpms 3600 3600 3600

exec i3
