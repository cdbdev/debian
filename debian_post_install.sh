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
echo "deb http://deb.debian.org/debian buster main contrib non-free" > /etc/apt/sources.list
echo -e "deb-src http://deb.debian.org/debian buster main contrib non-free\n\n" >> /etc/apt/sources.list
echo "deb http://security.debian.org/debian-security buster/updates main contrib non-free" >> /etc/apt/sources.list
echo "deb-src http://security.debian.org/debian-security buster/updates main contrib non-free" >> /etc/apt/sources.list

apt-get update && apt-get upgrade

# ----------------------------------------------- 
# Fix dark screen & hibernate
# ----------------------------------------------- 
echo ":: Adjusting GRUB for optimal display..."
sed -i '/GRUB_CMDLINE_LINUX_DEFAULT=/c\GRUB_CMDLINE_LINUX_DEFAULT=\"quiet acpi_backlight=none amdgpu.dc=0\"' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

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
