#!/bin/sh

eval $(ssh-agent)
if [ -f ~/.ssh/id_rsa]; then
    ssh-add ~/.ssh/id_rsa
fi
sudo dhcpcd
sleep 20
sudo ntpdate -s pool.ntp.org
startx
