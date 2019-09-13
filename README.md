# Installation guide
This guide documents the specific steps needed to install Debian on my Lenovo ideapad 320.

Download this repo with:  
wget --no-check-certificate https://github.com/cdbdev/debian-install/archive/master.tar.gz

## Installation media
Go to https://cdimage.debian.org/images/unofficial/non-free/images-including-firmware/ and choose your version of Debian (non-live installer). The iso file should be located under: `amd64/iso-dvd/firmware-xxx-amd64-DVD-1.iso`.

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

**_Note_**: _Although the touchpad will not work yet, you can make use of the keyboard to navigate through the installation process._

### Extra firmware
The Atheros card (wifi) requires non-free firmware, so you will be asked if you want to insert an extra medium with the necessary firmware. As this iso already contains the non-free firmware, choose 'no' in this step.

### User accounts
Do not specify a password for the “root” user, this account will be disabled but the sudo package will be installed later to enable administrative tasks to be carried out on the new system. By default, the first user created on the system will be allowed to use the sudo command to become root. 

### Partition disks
During this step, make sure to select the 'Manual' option. In the next step, delete the existing partitions labeled with `ext4 <tab> /` and `swap <tab> swap`. Do not touch the windows partitions! Now choose **'Guided partitioning'** and afterwards **'Guided - use the largest continuous free space'**. Finally select **'All files in one partition (recommended for new users)'** and finish the partitioning step.

## Desktop Environment
### XFCE
Choose **XFCE** option during `Select and install software`

### Openbox
Do not choose a DE during installation and leave the defaults selected at `Select and install software`.  
When the new system is installed and rebooted, perform the following:
```
# apt install xorg openbox obconf lxappearance-obconf obmenu feh lightdm light-locker pcmanfm lxterminal leafpad tint2 conky network-manager network-manager-applet firefox screenfetch xreader libreoffice galculator gvfs dosfstools
```

Enable taskbar(tint2) on boot:
```
# echo "tint2 &" >> ~/.config/openbox/autostart
```

#### Install arc theme
Open `Obconf` and under 'Theme' click on `Install a new theme...` and point it to the .obt files.

## Post-installation
Do not boot into the Graphical environment just yet (if it is at all possible)! First switch to a non-graphical tty and follow the next steps and reboot afterwards.

Before continuing, make sure the `/etc/apt/sources.list` is complete like this:
```
deb http://deb.debian.org/debian buster main contrib non-free
deb-src http://deb.debian.org/debian buster main contrib non-free

deb http://security.debian.org/debian-security buster/updates main contrib
deb-src http://security.debian.org/debian-security buster/updates main contrib
```

Next update the system before installing extra packages:
```
# apt update && apt upgrade
```

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
During installation, a 'setup' file is created under `/etc/network/interfaces.d`. This file contains the wrong interface so we can safely remove this file.

```
# rm /etc/network/interfaces.d/*

```
**_Note_**: _We delete everything in this directory, because the network configuration is not managed by `ifupdown`, but by `NetworkManager`._

### Add necessary firmware files for Atheros card
The non-free firmware installation image (currently Debian Buster) does not include the latest binaries for the Atheros card. Make sure to download and install these next to the ones already installed.

The latest Atheros firmware can be found here: http://ftp.us.debian.org/debian/pool/non-free/f/firmware-nonfree/.  
Install the package:

```
# dpkg -i conf/firmware-atheros_20190717-1_all.deb
```

### Add necessary firmware for AMD
The non-live installer does not automatically install the necessary firmware for the AMD graphical card. So we have to install it manually.

```
apt install firmware-linux
```
