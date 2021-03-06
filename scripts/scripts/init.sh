#!/bin/sh

killall -wq picom
killall -wq polybar

if [ "$1" == "restart" ]; then

	xrandr --output DP-1-4 --off
	xrandr --output HDMI-1-0 --off

	i3-msg restart

	sleep 1

	xrandr --output DP-1-4 --auto --right-of eDP1
	xrandr --output HDMI-1-0 --auto --right-of DP-1-4 #--rotate right # doesnt work with i3 for some reason

	sleep 1

else

	xinput set-prop 'SynPS/2 Synaptics TouchPad' 'libinput Natural Scrolling Enabled' 1
	xinput set-prop 'SynPS/2 Synaptics TouchPad' 'libinput Tapping Enabled' 1
	xinput set-prop 'SynPS/2 Synaptics TouchPad' 'libinput Disable While Typing Enabled' 0

fi

picom -b --experimental-backends &!

feh --no-fehbg --bg-fill ~/.local/share/wallpapers/current

screens=($(xrandr | sed -nr 's|^(.*) connected.*$|\1|p'))
for screen in "${screens[@]}"; do
	polybar "$screen" >/dev/null 2>&1 &!
done

if [ "$1" != "restart" ]; then

	dunst &!

	sleep 1

	~/.config/scripts/xdg-autostart.sh

fi
