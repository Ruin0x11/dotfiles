#!/bin/sh

export GTK_IM_MODULE='uim'
export QT_IM_MODULE='uim'
# uim-xim &
export XMODIFIERS='@im=uim'
xsetroot
# compton -GCc -e .60 --vsync drm --dbe --vsync-aggressive --unredir-if-possible &
xset +fp /usr/share/fonts/local/ &
xset fp+ /usr/X11R6/lib/X11/fonts/local/ &
#xinput set-prop 12 "Trackpad Smooth Scroll" 0
xflux -z 61801
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

xinput set-prop 8 "libinput Accel Speed" -1

if [ `xrandr | grep -c ' connected '` -eq 2 ]; then
    if [ `xrandr | grep HDMI1 | grep -c ' connected '` -eq 1 ]; then
        xrandr --output HDMI1 --auto --primary --output eDP1 --off
    fi
fi
exec fvwm -f $HOME/.fvwmrc
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
