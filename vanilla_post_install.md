## Setup firewall
Download nftables.conf from: https://raw.githubusercontent.com/cdbdev/debian/refs/heads/master/conf/nftables.conf  
Then run the following:
```
# mv conf/nftables.conf /etc/
# systemctl enable nftables.service
```

## Setup ipv4 default instead of ipv6
```
# vi /etc
```
Append the following to the end of the file:
```
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
```

Save the file and execute:
```
# sysctl -p
```

## Install other required packages
- firmware-linux
- (only for old iMac) firmware-b43-installer
- network-manager
  
Reboot system

## Connect with wifi (after installation of network-manager)
```
# nmcli device wifi list
# nmcli device wifi connect "YOUR_SSID" --ask 
now enter password and check connectivity with:
# nmcli device status
```
Reboot system

## Mark all currently installed packages on your Debian system as "manually installed" 
```
# sudo apt-mark manual $(dpkg -l | awk '/^ii/ {print $2}') 
check result with:
# apt-mark showmanual
```

## Mark installing packages as auto installed 
```
# apt install PACKAGE_NAME -y && sudo apt-mark auto PACKAGE_NAME
```

## Remove "auto" installed packages (leaves behind configuration files )
```
# apt autoremove
```

## Remove "auto" installed packages (completely removes a package along with all of its personal configuration files) 
```
# apt purge
```

## Get rid of leftover config files for orphan packages 
```
# apt autoremove --purge
```

