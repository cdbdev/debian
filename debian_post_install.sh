#!/bin/bash

# ----------------------------------------------------------------------- #
# Debian post-installation script				          #
# ----------------------------------------------------------------------- #
# Author    : Chris							  #
# Project   : https://github.com/cdbdev/debian-install			  #
# ----------------------------------------------------------------------- #


# ----------------------------------------------- 
# Fix dark screen & hibernate
# ----------------------------------------------- 

echo ":: Adjusting GRUB for optimal display..."
sed -i '/GRUB_CMDLINE_LINUX_DEFAULT=/c\GRUB_CMDLINE_LINUX_DEFAULT=\"quiet acpi_backlight=none amdgpu.dc=0\"' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

# ----------------------------------------------- 
# Install and configure nftables
# ----------------------------------------------- 
apt install nftables
mv conf/nftables.conf /etc/
systemctl enable nftables.service
