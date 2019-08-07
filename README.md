# Introduction
This guide documents the specific steps needed after the initial installation of Debian on my Lenovo ideapad 320.

## Fix issue with backlight
```
# sed -i '/GRUB_CMDLINE_LINUX_DEFAULT=/c\GRUB_CMDLINE_LINUX_DEFAULT=\"quiet acpi_backlight=none amdgpu.dc=0\"' /etc/default/grub
```

## Install nft and implement rules
```
# apt install nftables
```
Next copy the file `conf/nftables.conf` to `/etc/`.

## Clear error on systemd network initialization
```
# rm /etc/network/interfaces.d/*

```

# Add necessary firmware files for atheros card

Download latest atheros firmware here: http://ftp.us.debian.org/debian/pool/non-free/f/firmware-nonfree/.

After download, run the following: 
```
dpkg -i firmware-atheros_<datex>xxx_all.deb
```

