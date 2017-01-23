#!/bin/bash

# Run install.sh first or this will fail due to missing dependencies

# network on boot?
read -t 1 -n 1000000 discard      # discard previous input
sudo dhcpcd
echo 'Waiting for internet connection'
sleep 25

# xinitrc
cd
head -n -5 /etc/X11/xinit/xinitrc > ~/.xinitrc
echo 'exec VBoxClient --clipboard -d &' >> ~/.xinitrc
echo 'exec VBoxClient --display -d &' >> ~/.xinitrc
echo 'exec i3 &' >> ~/.xinitrc
echo 'exec emacs' >> ~/.xinitrc

# emacs config
git clone https://github.com/abrochard/emacs-config.git
echo '(load-file "~/emacs-config/bootstrap.el")' > ~/.emacs
echo '(server-start)' >> ~/.emacs

# cower & pacaur
mkdir Downloads
cd ~/Downloads
wget https://aur.archlinux.org/cgit/aur.git/snapshot/cower.tar.gz
tar -xvf cower.tar.gz
cd cower
gpg --recv-keys --keyserver hkp://pgp.mit.edu 1EB2638FF56C0C53
makepkg PKGBUILD
read -t 1 -n 1000000 discard      # discard previous input
sudo pacman -U cower-*.pkg.tar.xz --noconfirm

cd ~/Downloads
wget https://aur.archlinux.org/cgit/aur.git/snapshot/pacaur.tar.gz
tar -xvf pacaur.tar.gz
cd pacaur
makepkg PKGBUILD
read -t 1 -n 1000000 discard      # discard previous input
sudo pacman -U pacaur-*.pkg.tar.xz --noconfirm

# xterm setup
echo 'XTerm*background:black' > ~/.Xdefaults
echo 'XTerm*foreground:white' >> ~/.Xdefaults
echo 'UXTerm*background:black' >> ~/.Xdefaults
echo 'UXTerm*foreground:white' >> ~/.Xdefaults

# tmux setup like emacs
cd
echo 'unbind C-b' > ~/.tmux.conf
echo 'set -g prefix C-x' >> ~/.tmux.conf
echo 'bind C-x send-prefix' >> ~/.tmux.conf
echo 'bind 2 split-window' >> ~/.tmux.conf
echo 'bind 3 split-window -h' >> ~/.tmux.conf

# oh-my-zsh
cd
rm ~/.zshrc -f
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="bira"/' ~/.zshrc
sed -i 's/plugins=(git)/plugins=(git compleat sudo archlinux emacs autojump common-aliases)/' ~/.zshrc

# environment variable
echo 'export EDITOR=emacsclient' >> ~/.zshrc
echo 'export TERMINAL=xterm' >> ~/.zshrc

# i3status
if [ ! -d ~/.config ]; then
    mkdir ~/.config
fi
mkdir ~/.config/i3status
cp /etc/i3status.conf ~/.config/i3status/config
sed -i 's/^order += "ipv6"/#order += "ipv6"/' ~/.config/i3status/config
sed -i 's/^order += "run_watch VPN"/#order += "run_watch VPN"/' ~/.config/i3status/config
sed -i 's/^order += "wireless _first_"/#order += "wireless _first_"/' ~/.config/i3status/config
sed -i 's/^order += "battery 0"/#order += "battery 0"/' ~/.config/i3status/config

# git first time setup
git config --global user.name $(whoami)
git config --global user.email $(whoami)@$(hostname)
git config --global code.editor emacsclient
echo '    AddKeysToAgent yes' >> ~/.ssh/config

# if there are ssh key
if [ -d ~/workspace/ssh ]; then
    if [ -d ~/.ssh ]; then
        rm -rf ~/.ssh
    fi
    ln -s ~/workspace/ssh ~/.ssh
fi

# temporary workaround
cd
wget https://raw.githubusercontent.com/abrochard/spartan-arch/master/startx.sh -O startx.sh
chmod +x startx.sh
echo 'alias startx=~/startx.sh' >> ~/.zshrc

echo 'Done'
~/startx
