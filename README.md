# spartan-arch

* Install
``` shell
timedatectl set-ntp true
fdisk -l
mkfs.ext4 /dev/sda1
mkswap /dev/sda2
swapon /dev/sda2
mount /dev/sda1 /mnt
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist.backup
rankmirrors -n 6 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist
pacstrap /mnt base
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
ln -s /usr/share/zoneinfo/America/New_York /etc/localtime
hwclock --systohc
sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/local.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
echo arch-virtualbox > /etc/hostname
mkinitcpio -p linux
passwd
pacman -S grub --noconfirm
grub-install --target=i386-pc /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
pacman -S xorg xorg-xinit git emacs zsh virtualbox-guest-utils nodejs npm sudo vim xterm chromium wget perl make expac openssh
npm install -g jscs
useradd -m -G wheel -s /bin/zsh adrien
passwd adrien
visudo
exit
umount /mnt
reboot
```

* Post-install
``` shell
# network on boot?
sudo dhcpcd

# xinitrc
head -n -5 /etc/X11/xinit/xinitrc > ~/.xinitrc
echo exec VBoxClient --clipboard -d \& >> ~/.xinitrc
echo exec VBoxClient --display -d \& >> ~/.xinitrc
echo exec emacs >> ~/.xinitrc

# emacs config
git clone https://github.com/abrochard/emacs-config.git
echo '(load-file "~/emacs-config/bootstrap.el")' > ~/.emacs
echo '(server-start)' >> ~/.emacs

# vboxsf mount
cd
mkdir workspace
mkdir org
mkdir Downloads
sudo su
echo 'org /home/adrien/org vboxsf uid=adrien,gid=wheel,rw,dmode=700,fmode=600,nofail 0 0' >> /etc/fstab
echo 'workspace /home/adrien/workspace vboxsf uid=adrien,gid=wheel,rw,dmode=700,fmode=600,nofail 0 0' >> /etc/fstab
exit


#pacaur
sudo pacman -S wget make gcc fakeroot --noconfirm
cd ~/Downloads
wget https://aur.archlinux.org/cgit/aur.git/snapshot/cower.tar.gz
tar -xvf cower.tar.gz
cd cower
sudo pacman -S curl openssl yajl perl --noconfirm
gpg --recv-keys --keyserver hkp://pgp.mit.edu 1EB2638FF56C0C53
makepkg PKGBUILD
sudo pacman -U cower-*.pkg.tar.xz --noconfirm

cd ~/Downloads
wget https://aur.archlinux.org/cgit/aur.git/snapshot/pacaur.tar.gz
tar -xvf pacaur.tar.gz
cd pacaur
sudo pacman -S expac --noconfirm
makepkg PKGBUILD
sudo pacman -U pacaur-*.pkg.tar.xz --noconfirm

#oh-my-zsh
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="bira"/' ~/.zshrc
sed -i 's/plugins=(git)/plugins=(git compleat sudo archlinux emacs autojump common-aliases)/' ~/.zshrc
sudo pacman -S autojump --noconfirm
source ~/.zshrc

# ssh keys
```
