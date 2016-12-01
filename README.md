# spartan-arch

This is a set of scripts designed to automate the creation of a minimal VM running Arch Linux and Emacs as a Windows manager. This VM can be used as a file editor for the  host via folder sharing and as a development environment. Currently, the VM costs about 90MB of RAM to run.

## Requierements for Virtual Box VM
- 8GB of space on disk
- 2GB of RAM
- Clipboard sharing in both directions enabled
- Two shared folders `org` and `workspace` auto-mount and permanent

## Installation
Boot the VM on archlinux iso and then run the command
```shell
wget https://goo.gl/ZPAMtT -O install.sh
bash install.sh [password]
```
Where `[password]` is what you want the root and user password to be.
The install.sh script will run and then reboot the computer once done.

You want to boot on disk this time and eject the cd from the VM.

Login as user 'adrien' then run the command
```shell
bash post-install.sh
```
The script will ask for the root password a couple of times.

## Usage
Once the VM is booted, log in as 'adrien' and call `startx` to start Xorg.

## TODO
- non interactive visudo
- automatic oh-my-zsh config
- dhcpcd on boot
- ssh-keys generation
