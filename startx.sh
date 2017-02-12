#!/bin/sh

eval $(keychain --eval id_rsa)
sudo dhcpcd
startx
