#!/bin/sh

prefix="/usr"

exec_prefix="${prefix}"
xrandr --output "Virtual-1" --mode 1920x1080
feh --bg-scale ~/pictures/wallpaper2.jpg &
#dwmblocks &
picom&
exec dwm
