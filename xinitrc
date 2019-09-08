#!/bin/sh

export GTK_IM_MODULE='uim'
export QT_IM_MODULE='uim'
uim-xim &
export XMODIFIERS='@im=uim'
xsetroot
# compton -GCc -e .60 --vsync drm --dbe --vsync-aggressive --unredir-if-possible &
xset +fp /usr/share/fonts/local/ &
xset fp+ /usr/X11R6/lib/X11/fonts/local/ &
#xinput set-prop 12 "Trackpad Smooth Scroll" 0
#xflux -z 98051
# unclutter -idle 3 &
dropboxd &
# uim-toolbar-gtk3-systray &
# mpdscribble &
source ~/.aliases
# jack_control start &
# jack_control eps realtime false &
# xcalib ~/Color\ LCD-42449F80-6AB9-C591-A826-01585D808BDC.icc
# mpdscribble &
# jack_control start &

#xrandr --output VGA-1 --mode 1440x900

# xrandr --size 1600x1200
# exec wmaker

xrandr --dpi 96
setxkbmap -option ctrl:nocaps
xmodmap ~/.xmodmap
xrdb ~/.Xresources
xset fp+ /usr/share/fonts/local/
xset fp+ /usr/share/fonts/75dpi/
xset fp rehash

xinput set-prop 18 "libinput Accel Speed" -0.8
#xinput create-master Auxillary
#xinput reattach "pointer:HID 6901:2701" "Auxillary pointer"
#xinput reattach "16" "Auxillary keyboard"

unclutter&
DISPLAY=:0.1 exec i3&
urxvt-browser

autocutsel -fork &
autocutsel -selection PRIMARY -fork &

rescuetime&

xinput --set-prop 10 'libinput Accel Speed' -1

exec i3
#exec fvwm -f $HOME/.fvwmrc
#exec $HOME/build/stumpwm/stumpwm

#if [ $WM == "bspwm" ] ; then
#    while true
#    do
#        # mail-sync
#        sleep 120
#    done &
#
#    #exec awesome
#    # exec i3
#     exec emacs
#else
##    mpdcron &
##    nitrogen --restore &
#    sxhkd &
#    panel &
#    exec bspwm
#fi
