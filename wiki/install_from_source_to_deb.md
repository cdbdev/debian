# Introduction
There are 3 options to build from source:
- create DEB from Debianized source
- create DEB from upstream source using helper scripts
- create DEB from upstream source using: `make` and `make install`

> **Important:** `make install` should be your absolute last resort. You should **NEVER** use it unless all other options have failed and you should **ONLY** use it IF the package you want to build is of mission critical importance. The `make install` routine is the most primitive method of building a package from source and has absolutely no concept of dependencies or package management. There's a reason why GNU/Linux distributions use package managers like `APT` or `RPM`. And that reason is to get as far away from `make install` as possible. Also if you want to uninstall a package that you installed with the `make install` routine, you better hope that its `make uninstall` routine works just as well as its installation routine or you'll be stuck manually deleting all of the files.

# Prerequisites
## Install required packages for build
```
# apt-get install build-essential fakeroot devscripts
```

## Configure apt
The next thing that you need to do, is make sure that you have some **source repositories** configured in your computer.  
Open your `/etc/apt/sources.list` file and check if you have one or more lines that start with `deb-src`.

```
deb-src http://ftp.us.debian.org/debian/ unstable main
```
Once you've added the line, you'll need to do `apt-get update`.

# The Build Process
## Get the dependencies for your package
```
apt-get build-dep <packagename>
```
  
## Get the source package
In order to get the source of your package, go to your working directory and run:
```
apt-get source <packagename>
cd <packagename>-<version>/
```

## Change package version number
If you're running Debian Stable, you may want to change the package's version number, so that the upgrade path to the next version of Debian Stable is preserved. To do that, you edit the debian/changelog file.

For example, I recently backported version 0.8.3a-1 of wxMaxima to Debian Lenny, so at this point, I ran:
```
debchange -b -v 0.8.3a-1~bpo50+1
```
