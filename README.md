# Installation guide
This guide documents the specific steps needed to install Debian on my Lenovo ideapad 320.

Download this repo with:  
wget --no-check-certificate https://github.com/cdbdev/debian-install/archive/master.tar.gz

## Installation media
Go to https://cdimage.debian.org/images/unofficial/non-free/images-including-firmware/ and choose your version of Debian.  
The iso file should be located under: `amd64/iso-dvd/firmware-xxx-amd64-DVD-1.iso`.

Now create the installation media:

In **GNU/Linux**:
Run the following commands, replacing /dev/sdx with your drive, e.g. /dev/sdb. (Do not append a partition number, so do not use something like /dev/sdb1):

```
#  mkfs.vfat -I /dev/sdx
#  dd bs=4M if=/path/to/debian.iso of=/dev/sdx status=progress oflag=sync
```

In **Windows**:

Using Rufus from https://rufus.akeo.ie/.  
Simply select the Debian ISO, the USB drive you want to create the bootable Debian Linux onto and click start. 

**_Note_**: _Be sure to select DD image mode from the dropdown menu or when the program asks which mode to use (ISO or DD), otherwise the image will be transferred incorrectly._

## Main installation
Choose 'Graphical install' from the installer menu.  
**Note: Although the touchpad will not work yet, you can make use of the keyboard to navigate through the installation process.**

### Partition disks
During this step, make sure to select the 'Manual' option. In the next step, delete the existing partitions labeled with `(ext4) /` and `swap swap`. Now choose **Guided partitioning** and afterwards **Guided - use the largest continuous free space**. Finally select **All files in one partition (recommended for new users)** and finish the partitioning step.

## Post-installation

### Fix issue with backlight
```
# sed -i '/GRUB_CMDLINE_LINUX_DEFAULT=/c\GRUB_CMDLINE_LINUX_DEFAULT=\"quiet acpi_backlight=none amdgpu.dc=0\"' /etc/default/grub
# grub-mkconfig -o /boot/grub/grub.cfg
```

### Install nftables
Download the package and copy the file `conf/nftables.conf` to `/etc/`.

```
# apt install nftables
# mv conf/nftables.conf /etc/
# systemctl enable nftables.service
```

### Clear error on systemd network initialization
```
# rm /etc/network/interfaces.d/*

```

### Add necessary firmware files for atheros card

The latest atheros firmware can be found here: http://ftp.us.debian.org/debian/pool/non-free/f/firmware-nonfree/.

```
# dpkg -i conf/firmware-atheros_20190717-1_all.deb
```

