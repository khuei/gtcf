#!/usr/bin/env bash

REPO=$(cd $(dirname "${BASH_SOURCE[0]}") > /dev/null 2>&1 && pwd)

# chroot into new environment
chroot /mnt/gentoo /bin/bash
export PS1="(chroot) ${PS1}"
printf 'Enter your boot partition (ex. /dev/sda1): '
read boot
mount $boot /boot

# setup portage repository
emerge --sync
emerge --update --newuse --deep --changed-use --with-bdeps=y @world
emerge app-portage/layman
layman -o https://raw.github.com/Z5483/Z5483-overlay/master/Z5483-overlay.xml -a Z5483

# setup timezone data
echo 'pick a timezone from the following list (press q to enter your timezone)'
read -n 1 -s -r -p "Press any key to see the list"
ls /usr/share/zoneinfo/** | less && printf 'Enter your timezone: '
read timezone
echo $timezon > /etc/timezone
emerge --config sys-libs/timezone-data

# install tools
emerge \
	app-admin/syslog-ng             \
	app-arch/lz4                    \
	app-editors/neovim              \
	app-misc/tmux                   \
	app-portage/euses               \
	app-portage/portage-utils       \
	app-shells/zsh                  \
	dev-lang/python                 \
	dev-lang/ruby                   \
	dev-util/ccache                 \
	dev-vcs/git                     \
	net-dns/bind-tools              \
	net-misc/dhcpcd                 \
	net-misc/openssh                \
	net-wireless/wpa_supplicant     \
	sys-apps/pciutils               \
	sys-boot/grub:2                 \
	sys-devel/clang                 \
	sys-devel/lld                   \
	sys-devel/llvm                  \
	sys-kernel/genkernel            \

# add config files
mkdir -p /etc/syslog-ng
cp      $REPO/etc/syslog-ng/syslog-ng.conf      /etc/syslog-ng/syslog-ng.conf

mkdir -p /var/tmp/ccache
cp      $REPO/var/tmp/ccache/ccache.conf        /var/tmp/ccache

cp      $REPO/etc/fstab              /etc/fstab
cp      $REPO/etc/genkernel.conf     /etc/genkernel.conf
cp      $REPO/etc/rc.conf            /etc/rc.conf
cp      $REPO/etc/sysctl.conf        /etc/sysctl.conf

# configure linux kernel
echo 'entering: /usr/src/linux'
cd /usr/src/linux
emerge sys-kernel/gentoo-sources
cp $REPO/usr/src/linux/.config /usr/src/linux/.config
make menuconfig && make $(portageq envvar MAKEOPTS) && make modules_install && make install

# setup /boot
echo 'entering: /boot'
cd /boot
genkernl --install initramfs
grub-install --target=x86_64-efi --efi-directory=/boot
grub-mkconfig -o /boot/grub/grub.cfg

echo 'success!'
