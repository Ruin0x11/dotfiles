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
urxvtd -q -o -f &

#
# input
#
synclient MaxTapTime=0
synclient CoastingSpeed=0
synclient VertScrollDelta=-125
synclient HorizScrollDelta=-125
synclient AccelFactor=0.01
synclient MaxSpeed=0.8
#syndaemon -i 2.0 -K -R -t &
# xinput --set-prop 15 "Device Accel Constant Deceleration" 2.0
# xinput --set-prop 15 "Device Accel Adaptive Deceleration" 4.0
# xinput --set-prop 15 "Device Accel Velocity Scaling" 12.0
# xinput --set-prop 15 "Synaptics Move Speed" 1.000000, 1.000000, 0.020000, 0.080000

declare -i TOUCHPOINT_ID
TOUCHPOINT_ID=`xinput list | grep -Eio '(TrackPoint)\s*id\=[0-9]{1,2}' | grep -Eo '[0-9]{1,2}'`
#xinput disable $TOUCHPOINT_ID

# . ~/.bin/multihead.sh

if [ -x /usr/bin/autocutsel ]; then
    #this will keep the clipboard in sync
    #   with the primary buffer
    autocutsel -selection CLIPBOARD -fork

    #this will keep the primary in sync
    #   with the clipboard buffer
    autocutsel -selection PRIMARY -fork
fi

exec i3
