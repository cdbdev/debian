# Introduction
Todo....

## Fix issue with backlight
```
# sed -i '/GRUB_CMDLINE_LINUX_DEFAULT=/c\GRUB_CMDLINE_LINUX_DEFAULT=\"quiet acpi_backlight=none amdgpu.dc=0\"' /etc/default/grub
```

## Install nft and implement rules
```
# apt install nftables
```

## Clear error on systemd network initialization
```
# rm /etc/network/interfaces.d/*

```

Search for atheros firmware here: `http://ftp.us.debian.org/debian/pool/non-free/f/firmware-nonfree/`. 
Download and run: `dpkg -i firmware-atheros_xxx_all.deb` 

