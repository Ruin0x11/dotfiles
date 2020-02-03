#!/bin/sh

xsetroot
source ~/.aliases

# setxkbmap -layout jp
setxkbmap -option ctrl:nocaps
xmodmap ~/.xmodmap

#
# fonts
#
xrdb ~/.Xresources
xset fp+ /usr/share/fonts/misc/
xset fp+ /usr/share/fonts/local/
xset fp+ /usr/share/fonts/75dpi/
xset fp+ /usr/share/fonts/artwiz-fonts/
xset fp+ /usr/X11R6/lib/X11/fonts/local/
xset fp+ ~/.fonts
xset fp rehash

#
# uim
#
export GTK_IM_MODULE=uim
export QT_IM_MODULE=uim
uim-xim &
export XMODIFIERS=@im=uim

#
# programs
#
conky &
autocutsel &
dunst &
xbanish &

#
# input
#
synclient MaxTapTime=0
synclient CoastingSpeed=0
synclient VertScrollDelta=-125
synclient HorizScrollDelta=-125
#syndaemon -i 2.0 -K -R -t &

declare -i TOUCHPOINT_ID
TOUCHPOINT_ID=`xinput list | grep -Eio '(TrackPoint)\s*id\=[0-9]{1,2}' | grep -Eo '[0-9]{1,2}'`
#xinput disable $TOUCHPOINT_ID

exec i3
