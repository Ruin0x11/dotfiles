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
export XMODIFIERS='@im=uim' exec xterm -geometry 80x66+0+0 -name login

compton -GCc -e .60 --vsync drm --dbe --vsync-aggressive --unredir-if-possible &
xset +fp /usr/share/fonts/artwiz-fonts-wl/ &
xinput set-prop 12 "Trackpad Smooth Scroll" 0
xflux -z 61801
xmodmap ~/.Xmodmap &
unclutter -idle 3 &
dropbox &
uim-toolbar-gtk3-systray &
mpdscribble &
source ~/.aliases
xcalib ~/Color\ LCD-42449F80-6AB9-C591-A826-01585D808BDC.icc
exec awesome
# exec emacs
