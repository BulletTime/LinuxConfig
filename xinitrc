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
feh --bg-scale ~/images/arch.png &

# Set keyboard
setxkbmap be

# Compositing effects
xcompmgr -f &

# Solve problem with Java GUI applications in xmonad
#wmname LG3D
export _JAVA_AWT_WM_NONREPARENTING=1

# Start xscreensaver
xscreensaver -no-splash &

# Lock screen on suspend/hibernate/sleep
killall xss-lock
xss-lock -- xscreensaver-command -lock &

# Start applications
sleep 1
dropbox &
#notepadqq &
google-chrome-stable &

# Run Xmonad
xsetroot -cursor_name left_ptr
xmonad
