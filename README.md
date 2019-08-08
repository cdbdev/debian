# Installation guide
This guide documents the specific steps needed after the initial installation of Debian on my Lenovo ideapad 320.

Download this repo with:  
wget --no-check-certificate https://github.com/cdbdev/debian-install/archive/master.tar.gz

## Installation media
Go to https://cdimage.debian.org/images/unofficial/non-free/images-including-firmware/ and choose your version of Debian.  
Next, choose `amd64/iso-dvd/firmware-xxx-amd64-DVD-1.iso`.

Now create the installation media:

In **GNU/Linux**:
Run the following commands, replacing /dev/sdx with your drive, e.g. /dev/sdb. (Do not append a partition number, so do not use something like /dev/sdb1):

```
#  mkfs.vfat -I /dev/sdx
#  dd bs=4M if=/path/to/archlinux.iso of=/dev/sdx status=progress oflag=sync
```

In **Windows**:

Using Rufus from https://rufus.akeo.ie/.  
Simply select the Arch Linux ISO, the USB drive you want to create the bootable Arch Linux onto and click start. 

**_Note_**: _Be sure to select DD image mode from the dropdown menu or when the program asks which mode to use (ISO or DD), otherwise the image will be transferred incorrectly._

## Fix issue with backlight
```
# sed -i '/GRUB_CMDLINE_LINUX_DEFAULT=/c\GRUB_CMDLINE_LINUX_DEFAULT=\"quiet acpi_backlight=none amdgpu.dc=0\"' /etc/default/grub
# grub-mkconfig -o /boot/grub/grub.cfg
```

## Install nftables
Download the package and copy the file `conf/nftables.conf` to `/etc/`.

```
# apt install nftables
# mv conf/nftables.conf /etc/
# systemctl enable nftables.service
```

## Clear error on systemd network initialization
```
# rm /etc/network/interfaces.d/*

```

# Add necessary firmware files for atheros card

The latest atheros firmware can be found here: http://ftp.us.debian.org/debian/pool/non-free/f/firmware-nonfree/.

```
# dpkg -i conf/firmware-atheros_20190717-1_all.deb
```

