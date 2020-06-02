#!/bin/sh

REPO=$(cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null 2>&1 && pwd)

# setting the date and time
ntpd -q -g

cd /mnt/gentoo

# unpack stage3
tar xpvf stage3-*.tar.xz --xattrs-include='*.*' --numeric-owner

# add basic config files
cp $REPO/etc/portage/make.conf /mnt/gentoo/etc/portage/make.conf
cp -r $REPO/etc/portage/env /mnt/gentoo/etc/portage/env

mirrorselect -i -o >> /mnt/gentoo/etc/portage/make.conf

mkdir --parents /mnt/gentoo/etc/portage/repos.conf
cp $REPO/etc/portage/repos.conf/overlay.conf /mnt/gentoo/etc/portage/repos.conf/

cp $REPO/etc/resolve.conf* /mnt/gentoo/etc/

# mount necessary filesystems
mount --types proc /proc /mnt/gentoo/proc
mount --rbind /sys /mnt/gentoo/sys
mount --rbind /dev /mnt/gentoo/dev
chmod 1777 /dev/shm

echo 'success!'
