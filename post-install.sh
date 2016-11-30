#!/bin/bash

# Run install.sh first or this will fail due to missing dependencies

# network on boot?
read -t 1 -n 1000000 discard      # discard previous input
sudo dhcpcd

# xinitrc
cd
head -n -5 /etc/X11/xinit/xinitrc > ~/.xinitrc
echo 'exec VBoxClient --clipboard -d \&' >> ~/.xinitrc
echo 'exec VBoxClient --display -d \&' >> ~/.xinitrc
echo 'exec emacs' >> ~/.xinitrc

# emacs config
git clone https://github.com/abrochard/emacs-config.git
echo '(load-file "~/emacs-config/bootstrap.el")' > ~/.emacs
echo '(server-start)' >> ~/.emacs

# vboxsf mount
mkdir workspace
mkdir org
read -t 1 -n 1000000 discard      # discard previous input
sudo su
echo 'org /home/adrien/org vboxsf uid=adrien,gid=wheel,rw,dmode=700,fmode=600,nofail 0 0' >> /etc/fstab
echo 'workspace /home/adrien/workspace vboxsf uid=adrien,gid=wheel,rw,dmode=700,fmode=600,nofail 0 0' >> /etc/fstab
exit

# cower & pacaur
mkdir Downloads
cd ~/Downloads
wget https://aur.archlinux.org/cgit/aur.git/snapshot/cower.tar.gz
tar -xvf cower.tar.gz
cd cower
sudo pacman -S curl openssl yajl perl --noconfirm
gpg --recv-keys --keyserver hkp://pgp.mit.edu 1EB2638FF56C0C53
makepkg PKGBUILD
read -t 1 -n 1000000 discard      # discard previous input
sudo pacman -U cower-*.pkg.tar.xz --noconfirm

cd ~/Downloads
wget https://aur.archlinux.org/cgit/aur.git/snapshot/pacaur.tar.gz
tar -xvf pacaur.tar.gz
cd pacaur
sudo pacman -S expac --noconfirm
makepkg PKGBUILD
read -t 1 -n 1000000 discard      # discard previous input
sudo pacman -U pacaur-*.pkg.tar.xz --noconfirm

#oh-my-zsh
cd
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="bira"/' ~/.zshrc
sed -i 's/plugins=(git)/plugins=(git compleat sudo archlinux emacs autojump common-aliases)/' ~/.zshrc
source ~/.zshrc

# environment variable
# echo 'EDITOR=emacsclient' >> /etc/environment

# ssh keys ?

echo 'Done'
