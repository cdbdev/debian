# Debian Upgrade

## Update current version:
```
# sudo apt update && sudo apt upgrade
```

## Upgrade to latest point release
```
# sudo apt full-upgrade
```

## Removing obsolete configuration files
```
# sudo find /etc -type f \( -iname "*.dpkg-old" -o -iname "*.dpkg-new" \) -exec rm -i {} \;
```

## Remove obsolete packages
```
# apt list '?obsolete'
# sudo apt purge '?obsolete'
```

## Purging removed packages
```
# apt list '?config-files'
# apt purge '?config-files'
```

## Remove non-Debian packages
```
# apt list '?narrow(?installed, ?not(?origin(Debian)))'
# apt-forktracer | sort
```

## Clean up leftover configuration files
```
# find /etc -name '*.dpkg-*' -o -name '*.ucf-*' -o -name '*.merge-error'
```

## Check package status
```
# dpkg --audit
# apt-mark showhold
The "hold" package state for apt can be changed using: 
# apt-mark unhold package_name
```

## Start from "pure" Debian (deb822-style)
Rename "/etc/apt/sources.list" to "/etc/apt/debian.sources"

Change APT-sources to new Debian version
Check that the APT sources entries (in files under /etc/apt/sources.list.d/) refer either to "trixie" or to "stable". 

## Updating the package list
```
# apt update
```

## Minimal system upgrade
In some cases, doing the full upgrade (as described below) directly might remove large numbers of packages that you will want to keep. We therefore recommend a two-part upgrade process: first a minimal upgrade to overcome these conflicts, then a full upgrade 
```
# apt upgrade --without-new-pkgs
```

## Upgrading the system
```
# apt full-upgrade
```

## Installing a kernel metapackage
When you full-upgrade from bookworm to trixie, it is strongly recommended that you install a 'linux-image-*' metapackage, if you have not done so before.  
```
# dpkg -l 'linux-image*' | grep ^ii | grep -i meta
Lookup image name (ex: linux-image-amd64): 
# uname -r 
Search for the package and afterwards install it
# apt-cache search linux-image- | grep -i meta | grep -v transition
```

## Cleanup after the upgrade
```
# apt autoremove 
# apt list '?obsolete'
# apt purge '?obsolete'
# apt list '?config-files'
# apt purge '?config-files'
```

# Resources
[Release Notes](https://www.debian.org/releases/stable/release-notes)
