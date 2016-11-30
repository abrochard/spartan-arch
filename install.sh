#!/bin/bash

# set time
timedatectl set-ntp true

#partiton disk
parted --script /dev/sda mklabel msdos mkpart primary ext4 0% 87% mkpart primary linux-swap 87% 100%
mkfs.ext4 /dev/sda1
mkswap /dev/sda2
swapon /dev/sda2
mount /dev/sda1 /mnt

# chroot
pacstrap /mnt base
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt

# setup mirrors
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist.backup
rankmirrors -n 6 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist

# setup timezone
ln -s /usr/share/zoneinfo/America/New_York /etc/localtime
hwclock --systohc

# setup locale
sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/local.gen
locale-gen
echo 'LANG=en_US.UTF-8' > /etc/locale.conf

# setup hostname
echo 'arch-virtualbox' > /etc/hostname

# build
mkinitcpio -p linux

# install bootloader
pacman -S grub --noconfirm
grub-install --target=i386-pc /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

# install Xorg
pacman -S --noconfirm xorg xorg-xinit xterm

# install virtualbox guest additions
pacman -S --noconfirm virtualbox-guest-utils

# install dev envt.
pacman -S --noconfirm git emacs zsh nodejs npm vim wget perl make gcc grep
pacman -S --noconfirm chromium curl autojump openssh sudo mlocate the_silver_searcher
npm install -g jscs jshint bower

# install req for pacaur & cower
pacman -S --noconfirm expac fakeroot yajl openssl

# user mgmt
echo 'Root password:'
passwd
useradd -m -G wheel -s /bin/zsh adrien
echo 'User password:'
passwd adrien
visudo

# reboot
exit
umount /mnt
reboot
