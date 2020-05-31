#!/usr/bin/env bash

REPO=$(cd $(dirname "${BASH_SOURCE[0]}") > /dev/null 2>&1 && pwd)

if [[ $EUID -ne 0 ]]; then
	echo 'please run as root'
	exit 0
fi

# install packages
emerge \
	media-libs/mesa         \
	x11-apps/setxkbmap      \
	x11-apps/xinit          \
	x11-apps/xmodmap        \
	x11-apps/xrandr         \
	x11-base/xorg-server    \
	x11-libs/libX11         \
	x11-libs/libXft         \
	x11-libs/libXinerama    \
	x11-libs/libXrandr      \
	x11-misc/dmenu          \
	x11-misc/xclip          \
	x11-terms/st            \
	x11-wm/dwm

# add config files
mkdir -p /usr/share/cursors/xorg-x11
cp -r $REPO/usr/share/cursors/xorg-x11/* /usr/share/cursors/xorg-x11

mkdir -p /etc/X11/xorg.conf.d
cp $REPO/etc/X11/xorg.conf.d/* /etc/X11/xorg.conf.d

mkdir -p /etc/fonts
cp $REPO/etc/fonts/fonts.conf /etc/fonts

# create xorg.conf through `Xorg -configure`
Xorg -configure
mv $HOME/xorg.conf.new /etc/X11/xorg.conf

echo 'success!'
