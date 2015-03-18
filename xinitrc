#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# Load Xresources if exists
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

# Background 
feh --bg-scale ~/images/arch.jpg

# Mouse
xsetroot -cursor_name left_ptr

# Keyboard
setxkbmap be

# VirtualBox guest
VboxClient-all &

# Compositing effects
xcompmgr -f &

# Start xmonad
xmonad
