#!/bin/sh

eval $(keychain --eval id_rsa)
sudo dhclient enp0s3
sudo ntpdate -s pool.ntp.org
startx
