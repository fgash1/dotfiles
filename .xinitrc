#!/bin/sh

# D-Bus/systemd-activated GUI helpers (e.g. the keyring's SSH passphrase prompter) need the display
dbus-update-activation-environment --systemd DISPLAY XAUTHORITY

[ -f "$HOME/.Xresources" ] && xrdb -merge "$HOME/.Xresources"
autorandr --change
xsetroot -cursor_name left_ptr

xset s 3600 3600
xset dpms 3600 3600 3600

exec i3
