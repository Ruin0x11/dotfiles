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
xset fp+ /usr/share/fonts/local/
xset fp+ /usr/share/fonts/75dpi/
xset fp+ /usr/X11R6/lib/X11/fonts/local/
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

#
# input
#
synclient MaxTapTime=0
synclient CoastingSpeed=0

exec i3
