#!/usr/bin/env bash

REPO=$(cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null 2>&1 && pwd)

mkdir -p /etc/syslog-ng
cp $REPO/etc/syslog-ng/syslog-ng.conf /etc/syslog-ng/syslog-ng.conf

mkdir -p /usr/share/cursors/xorg-x11
cp -r $REPO/usr/share/cursors/xorg-x11/* /usr/share/cursors/xorg-x11

mkdir -p /etc/X11/xorg.conf.d
cp $REPO/etc/X11/xorg.conf.d/* /etc/X11/xorg.conf.d

mkdir -p /etc/fonts
cp $REPO/etc/fonts/fonts.conf /etc/fonts

mkdir -p /etc/libvirt
cp $REPO/etc/libvirt/libvirtd.conf /etc/libvirt

mkdir -p /var/tmp/ccache
cp $REPO/var/tmp/ccache/ccache.conf /var/tmp/ccache

cp $REPO/etc/fstab /etc/fstab

cp $REPO/etc/genkernel.conf /etc/genkernel.conf

cp $REPO/etc/rc.conf /etc/rc.conf

cp $REPO/etc/sysctl.conf /etc/sysctl.conf

echo 'success!'
