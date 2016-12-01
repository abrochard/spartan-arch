#!/bin/bash

password=$1

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
echo 'org /home/adrien/org vboxsf uid=adrien,gid=wheel,rw,dmode=700,fmode=600,nofail 0 0' >> /mnt/etc/fstab
echo 'workspace /home/adrien/workspace vboxsf uid=adrien,gid=wheel,rw,dmode=700,fmode=600,nofail 0 0' >> /mnt/etc/fstab

# chroot
wget https://raw.githubusercontent.com/abrochard/spartan-arch/master/chroot-install.sh -O /mnt/chroot-install.sh
arch-chroot /mnt /bin/bash ./chroot-install.sh

# preparing post install
wget https://raw.githubusercontent.com/abrochard/spartan-arch/master/post-install.sh -O /mnt/home/adrien/post-install.sh $password

# reboot
umount /mnt
reboot
