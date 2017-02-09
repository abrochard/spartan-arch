#!/bin/sh

eval $(keychain --eval id_rsa)
sudo dhcpcd
sudo ntpdate -s pool.ntp.org
startx
