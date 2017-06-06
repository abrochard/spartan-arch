#!/bin/bash

if [ -z "$1" ]
then
    user=$1
else
    echo "Enter your username: "
    read user
fi

if [ -z "$2" ]
then
    password=$2
else
    echo "Enter your master password: "
    read -s password
fi

if [ -z "$3" ]
then
    fast=0
else
    fast=1
fi

# set time
timedatectl set-ntp true

#partiton disk
parted --script /dev/sda mklabel msdos mkpart primary ext4 0% 87% mkpart primary linux-swap 87% 100%
mkfs.ext4 /dev/sda1
mkswap /dev/sda2
swapon /dev/sda2
mount /dev/sda1 /mnt

# pacstrap
pacstrap /mnt base

# fstab
genfstab -U /mnt >> /mnt/etc/fstab
echo "org /home/$user/org vboxsf uid=$user,gid=wheel,rw,dmode=700,fmode=600,nofail 0 0" >> /mnt/etc/fstab
echo "workspace /home/$user/workspace vboxsf uid=$user,gid=wheel,rw,dmode=700,fmode=600,nofail 0 0" >> /mnt/etc/fstab

# chroot
wget https://raw.githubusercontent.com/abrochard/spartan-arch/master/chroot-install.sh -O /mnt/chroot-install.sh
arch-chroot /mnt /bin/bash ./chroot-install.sh $user $password $fast

# reboot
umount /mnt
reboot
