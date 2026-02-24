#!/bin/sh

prefix="/usr"

exec_prefix="${prefix}"
xrandr --output "Virtual-1" --mode 1920x1080
feh --bg-scale ~/pictures/arch_nz.png &
picom&
exec dwm
