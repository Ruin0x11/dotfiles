#!/bin/sh

xsetroot
xset +fp /usr/share/fonts/local/ &
xset fp+ /usr/X11R6/lib/X11/fonts/local/ &
source ~/.aliases

setxkbmap -layout jp
setxkbmap -option ctrl:nocaps
xmodmap ~/.xmodmap
xrdb ~/.Xresources
xset fp+ /usr/share/fonts/local/
xset fp+ /usr/share/fonts/75dpi/
xset fp rehash

exec i3
