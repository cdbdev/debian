#!/bin/bash

# ----------------------------------------------------------------------- #
# Debian post-installation script				          #
# ----------------------------------------------------------------------- #
# Author    : Chris							  #
# Project   : https://github.com/cdbdev/debian-install			  #
# ----------------------------------------------------------------------- #

# ----------------------------------------------- 
# Set root password
# ----------------------------------------------- 
echo ":: Setting password for root..."
passwd root

# ----------------------------------------------- 
# Update system
# ----------------------------------------------- 
cat /etc/os-release
echo -n ">> Please enter debian version [buster,...]: "
read debian_version

echo "deb http://deb.debian.org/debian $debian_version main contrib non-free" > /etc/apt/sources.list
echo -e "deb-src http://deb.debian.org/debian $debian_version main contrib non-free\n\n" >> /etc/apt/sources.list
echo "deb http://deb.debian.org/debian-security/ $debian_version/updates main contrib non-free" >> /etc/apt/sources.list
echo -e "deb-src http://deb.debian.org/debian-security/ $debian_version/updates main contrib non-free\n\n" >> /etc/apt/sources.list
echo "deb http://deb.debian.org/debian $debian_version-updates main contrib non-free" >> /etc/apt/sources.list
echo "deb-src http://deb.debian.org/debian $debian_version-updates main contrib non-free" >> /etc/apt/sources.list

apt-get update && apt-get upgrade

# ----------------------------------------------- 
# Add screenfetch
# ----------------------------------------------- 
echo ":: Adding screenfetch..."
apt-get install screenfetch
echo screenfetch >> .bashrc

# ----------------------------------------------- 
# Fix dark screen & hibernate
# ----------------------------------------------- 
echo ":: Adjusting GRUB for optimal display..."
sed -i '/GRUB_CMDLINE_LINUX_DEFAULT=/c\GRUB_CMDLINE_LINUX_DEFAULT=\"quiet acpi_backlight=none amdgpu.dc=0\"' /etc/default/grub
update-grub

# ----------------------------------------------- 
# Install and configure nftables
# ----------------------------------------------- 
echo ":: Installing nftables..."
apt-get install nftables
cp conf/nftables.conf /etc/
systemctl enable nftables.service

# ----------------------------------------------- 
# Clear error on systemd network initialization
# ----------------------------------------------- 
echo ":: Clearing setup network configuration..."
rm /etc/network/interfaces.d/*

# ----------------------------------------------- 
# Install necessary firmware files for atheros card
# ----------------------------------------------- 
echo ":: Installing atheros firmware..."
dpkg -i conf/firmware-atheros_20190717-1_all.deb

# ----------------------------------------------- 
# Install AMD firmware
# ----------------------------------------------- 
apt-get install firmware-linux

# ----------------------------------------------- 
# Installation extras
# ----------------------------------------------- 
apt-get install arc-theme
apt-get install papirus-icon-theme

echo ":: Installation finished"
