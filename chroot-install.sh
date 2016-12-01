#!/bin/bash

# This will be ran from the chrooted env.

password=$1

# setup mirrors
echo 'Setting up mirrors'
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist.backup
rankmirrors -n 6 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist

# setup timezone
echo 'Setting up timezone'
ln -s /usr/share/zoneinfo/America/New_York /etc/localtime
hwclock --systohc

# setup locale
echo 'Setting up locale'
sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/local.gen
locale-gen
echo 'LANG=en_US.UTF-8' > /etc/locale.conf

# setup hostname
echo 'Setting up hostname'
echo 'arch-virtualbox' > /etc/hostname

# build
echo 'Building'
mkinitcpio -p linux

# install bootloader
echo 'Installing bootloader'
pacman -S grub --noconfirm
grub-install --target=i386-pc /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

# install Xorg
echo 'Installing Xorg'
pacman -S --noconfirm xorg xorg-xinit xterm

# install virtualbox guest additions
echo 'Installing VB-guest-utils'
pacman -S --noconfirm virtualbox-guest-utils

# install dev envt.
echo 'Installing dev environment'
pacman -S --noconfirm git emacs zsh nodejs npm vim wget perl make gcc grep tmux
pacman -S --noconfirm chromium curl autojump openssh sudo mlocate the_silver_searcher
npm install -g jscs jshint bower

# install req for pacaur & cower
echo 'Installing dependencies'
pacman -S --noconfirm expac fakeroot yajl openssl

# user mgmt
echo 'Setting up user'
read -t 1 -n 1000000 discard      # discard previous input
echo 'root:'$password | chpasswd
useradd -m -G wheel -s /bin/zsh adrien
touch /home/adrien/.zshrc
chown adrien:adrien /home/adrien/zshrc
mkdir /home/adrien/org
chown adrien:adrien /home/adrien/org
mkdir /home/adrien/workspace
chown adrien:adrien /home/adrien/workspace
echo 'adrien:'$password | chpasswd
echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers

# preparing post install
wget https://raw.githubusercontent.com/abrochard/spartan-arch/master/post-install.sh -O /home/adrien/post-install.sh
chown adrien:adrien /home/adrien/post-install.sh

echo 'Done'
