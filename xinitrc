xset +fp /usr/share/fonts/local
xset +fp /usr/share/fonts/artwiz-latin1-fonts
xset fp rehash
[ ! -s ~/.config/mpd/pid ] && mpd
sh ~/.fehbg &
# xcompmgr -c &
export GTK_IM_MODULE='uim'
export QT_IM_MODULE='uim'
uim-xim &
export XMODIFIERS='@im=uim'
xscreensaver -no-splash & 
syndaemon -t -k -i 2 -d &
mpdscribble &
exec xmonad
