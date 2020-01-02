#!/bin/bash

# ----------------------------------------------------------------------- #
# Debian post-installation script				          #
# ----------------------------------------------------------------------- #
# Author    : Chris							  #
# Project   : https://github.com/cdbdev/debian-install			  #
# ----------------------------------------------------------------------- #

# ----------------------------------------------- 
# Check if running as root
# ----------------------------------------------- 
if [ "$EUID" -ne 0 ]
then 
    echo "Please run as root"
    exit
fi

# ----------------------------------------------- 
# Set root password
# ----------------------------------------------- 
echo ":: Setting password for root..."
passwd root

# ----------------------------------------------- 
# Disable <beep>
# ----------------------------------------------- 
echo ":: Disabling <beep>"
echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf

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

apt-get update && apt-get -y upgrade

# ----------------------------------------------- 
# Install extra software
# ----------------------------------------------- 
apt-get -y install gedit

# ----------------------------------------------- 
# Add screenfetch
# ----------------------------------------------- 
echo ":: Adding screenfetch..."
apt-get -y install screenfetch
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
apt-get -y install nftables
cp conf/nftables.conf /etc/
systemctl enable nftables.service

# ----------------------------------------------- 
# Clear error on systemd network initialization
# ----------------------------------------------- 
if [ ! "$(ls -A /etc/network/interfaces.d)" ]
then
    echo ":: Clearing setup network configuration..."
    rm /etc/network/interfaces.d/*
fi

# ----------------------------------------------- 
# Install necessary firmware files for atheros card
# ----------------------------------------------- 
echo ":: Installing atheros firmware..."
dpkg -i conf/firmware-atheros_20190717-1_all.deb

# ----------------------------------------------- 
# Install AMD firmware
# ----------------------------------------------- 
apt-get -y install firmware-linux

# ----------------------------------------------- 
# Installation extras
# ----------------------------------------------- 
apt-get -y install arc-theme
apt-get -y install papirus-icon-theme

echo ":: Installation finished"

# ----------------------------------------------- 
# Configure dnsmasq
# ----------------------------------------------- 
echo ":: Configuring dnsmasq..."
apt-get -y install openresolv dnsmasq
systemctl enable dnsmasq.service
cp conf/dnsmasq.conf /etc/
cp conf/resolvconf.conf /etc/
cp conf/trust-anchors.conf /usr/share/dnsmasq/
resolvconf -u
