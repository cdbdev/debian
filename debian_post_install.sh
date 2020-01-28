#!/bin/bash

# ----------------------------------------------------------------------- #
# Debian post-installation script				          #
# ----------------------------------------------------------------------- #
# Author    : Chris							  #
# Project   : https://github.com/cdbdev/debian-install			  #
# ----------------------------------------------------------------------- #

# -----------------------------------------------------------------------
# Check if running as root
# -----------------------------------------------------------------------
if [ "$EUID" -ne 0 ]
then 
    echo "Please run as root"
    exit
fi

# -----------------------------------------------------------------------
# Set root password
# -----------------------------------------------------------------------
echo ":: Setting password for root..."
passwd root

# -----------------------------------------------------------------------
# Disable <beep>
# -----------------------------------------------------------------------
echo ":: Disabling <beep>"
echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf

# -----------------------------------------------------------------------
# Update system
# -----------------------------------------------------------------------
cat /etc/os-release
echo -n ">> Please enter debian version [buster,...]: "
read debian_version

echo ":: Updating system..."
echo "deb http://deb.debian.org/debian $debian_version main contrib non-free" > /etc/apt/sources.list
echo -e "deb-src http://deb.debian.org/debian $debian_version main contrib non-free\n\n" >> /etc/apt/sources.list
echo "deb http://deb.debian.org/debian-security/ $debian_version/updates main contrib non-free" >> /etc/apt/sources.list
echo -e "deb-src http://deb.debian.org/debian-security/ $debian_version/updates main contrib non-free\n\n" >> /etc/apt/sources.list
echo "deb http://deb.debian.org/debian $debian_version-updates main contrib non-free" >> /etc/apt/sources.list
echo "deb-src http://deb.debian.org/debian $debian_version-updates main contrib non-free" >> /etc/apt/sources.list
echo "deb http://deb.debian.org/debian $debian_version-backports main contrib non-free" >> /etc/apt/sources.list

apt-get update && apt-get -y upgrade

# -----------------------------------------------------------------------
# Install extra software
# -----------------------------------------------------------------------
echo ":: Installing extra software..."
apt-get -y install aptitude blueman gedit catfish lightdm-gtk-greeter-settings

# -----------------------------------------------------------------------
# Add screenfetch
# -----------------------------------------------------------------------
echo ":: Adding screenfetch..."
apt-get -y install screenfetch
echo screenfetch >> .bashrc

# -----------------------------------------------------------------------
# Enable bluetooth
# -----------------------------------------------------------------------
systemctl enable bluetooth

# -----------------------------------------------------------------------
# Fix dark screen & hibernate
# -----------------------------------------------------------------------
echo ":: Adjusting GRUB for optimal display..."
sed -i '/GRUB_CMDLINE_LINUX_DEFAULT=/c\GRUB_CMDLINE_LINUX_DEFAULT=\"quiet acpi_backlight=none amdgpu.dc=0\"' /etc/default/grub
update-grub

# -----------------------------------------------------------------------
# Install and configure nftables
# -----------------------------------------------------------------------
echo ":: Installing nftables..."
apt-get -y install nftables
cp conf/nftables.conf /etc/
systemctl enable nftables.service

# -----------------------------------------------------------------------
# Clear error on systemd network initialization
# -----------------------------------------------------------------------
echo ":: Clearing old network settings"
if [  -n "$(ls -A /etc/network/interfaces.d/ 2>/dev/null)" ]
then
    echo ":: Clearing setup network configuration..."
    rm /etc/network/interfaces.d/*
fi

# -----------------------------------------------------------------------
# Install necessary firmware files for atheros card
# -----------------------------------------------------------------------
echo ":: Installing atheros firmware..."
apt-get -y -t $debian_version-backports install firmware-atheros

# -----------------------------------------------------------------------
# Install AMD firmware
# -----------------------------------------------------------------------
echo ":: Installing AMD firmware"
apt-get -y install firmware-linux

# -----------------------------------------------------------------------
# Installation extras
# -----------------------------------------------------------------------
echo ":: Installing extras"
apt-get -y install arc-theme
apt-get -y install papirus-icon-theme

# -----------------------------------------------------------------------
# Configure unbound
# -----------------------------------------------------------------------
echo ":: Configuring unbound..."
apt-get -y install openresolv unbound
sudo unbound-anchor -4
rm /etc/unbound/unbound.conf.d/*
cp conf/unbound.conf /etc/unbound/
cp conf/resolvconf.conf /etc/
resolvconf -u
systemctl enable unbound.service

echo ":: Process complete. Please reboot now."
