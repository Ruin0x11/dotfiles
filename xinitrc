#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then







    xrdb -merge $sysresources

fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then







    xrdb -merge "$userresources"

fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# twm &
# xclock -geometry 50x50-1+1 &
# xterm -geometry 80x50+494+51 &
# xterm -geometry 80x20+494-0 &

export GTK_IM_MODULE='uim'
export QT_IM_MODULE='uim'
uim-xim &
export XMODIFIERS='@im=uim'
xsetroot
compton -GCc -e .60 --vsync drm --dbe --vsync-aggressive --unredir-if-possible &
xset +fp /usr/share/fonts/artwiz-fonts-wl/ &
#xinput set-prop 12 "Trackpad Smooth Scroll" 0
xflux -z 61801
# unclutter -idle 3 &
dropbox &
uim-toolbar-gtk3-systray &
# mpdscribble &
source ~/.aliases
xcalib ~/Color\ LCD-42449F80-6AB9-C591-A826-01585D808BDC.icc
mpdscribble &
# jack_control start &
# jack_control eps realtime false &

if [ `xrandr | grep -c ' connected '` -eq 2 ]; then
    if [ `xrandr | grep HDMI1 | grep -c ' connected '` -eq 1 ]; then
        xrandr --output HDMI1 --auto --primary --output eDP1 --auto --right-of HDMI1
    fi
fi

if [ $WM == "awesome" ] ; then
    while true
    do
        mail-sync
        sleep 120
    done &

    #exec awesome
    # exec i3
     exec emacs
else
    mpdcron &
    nitrogen --restore &
    sxhkd &
    panel &
    exec bspwm
fi
