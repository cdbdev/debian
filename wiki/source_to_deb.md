# Contents
- [Introduction](#Introduction)
- [Prerequisites](#Prerequisites)
- [Build Process - Debianized source](#Build-Process---Debianized-source) 
- [Build Process - upstream source using helper scripts](#Build-Process---upstream-source-using-helper-scripts)
- [Links](#Links)

# Introduction
There are 3 options to build from source:
- create DEB from Debianized source
- create DEB from upstream source using helper scripts
- create DEB from upstream source using: `make` and `make install`

The first 2 options create so called `backports`, the last one installs the software under `/usr/local/`.

> **Important:** `make install` should be your absolute last resort. You should **NEVER** use it unless all other options have failed and you should **ONLY** use it IF the package you want to build is of mission critical importance. The `make install` routine is the most primitive method of building a package from source and has absolutely no concept of dependencies or package management. There's a reason why GNU/Linux distributions use package managers like `APT` or `RPM`. And that reason is to get as far away from `make install` as possible. Also if you want to uninstall a package that you installed with the `make install` routine, you better hope that its `make uninstall` routine works just as well as its installation routine or you'll be stuck manually deleting all of the files.

# Prerequisites
## Install required packages for build
```bash
# apt-get install build-essential fakeroot devscripts
```

## Configure apt
The next thing that you need to do, is make sure that you have some **source repositories** configured in your computer.  
Open your `/etc/apt/sources.list` file and check if you have one or more lines that start with `deb-src`:

```bash
deb-src http://ftp.debian.org/debian/ unstable main
deb-src http://ftp.debian.org/debian/ experimental main
```
Once you've added the line, you'll need to do `apt-get update`.

## Add a local repository
```bash
# apt-get install local-apt-repository
# mkdir /srv/local-apt-repository
```

# Build Process - Debianized source
## Get the dependencies for your package
The following will install a dependency package named `<packagename>-build-deps`:
```bash
# mk-build-deps <packagename> --install --remove
```

> **WARNING:** Do not use `apt-get build-dep <packagename>`, the problem is that there is no easy way to undo or revert the installation of the build dependencies. All the installed packages are marked as manually installed, so later one cannot simply expect to “autoremove” those packages. 
  
## Get the source package
In order to get the source of your package, go to your working directory and run:
```bash
$ apt-get source <packagename>
$ cd <packagename>-<version>/
```

## Change package version number
If you're running Debian Stable, you may want to change the package's version number to make a proper backport. 

Format of backported package version: `~bpo${debian_release}+${build_int}`.  
Examples:
- 1.2.3-4 now becomes 1.2.3-4~bpo9+1 for stretch
- 1.2.3-4 now becomes 1.2.3-4~bpo10+1 for buster

The following command does this for you:
```bash
$ debchange --bpo
```
A text editor opens in which you can put some comment and save your changes.

## Build the DEB file
Run the following inside the working directory:
```bash
$ debuild -us -uc
```
That last command may take a minute or an hour or three hours. It all depends on the size of the package and your own hardware. Once the command finishes, 1 or more .deb file are created.

## Install the DEB file
You can install a deb by running the following command:
```bash
dpkg -i <packagename>_<version>_<architecture>.deb
```
This works if the package does not have other dependencies that were created during build. If there are other generated dependencies, the best method to use is `local-apt-repository`. Just copy all the .deb files to **/srv/local-apt-repository**, run `apt update` and next `apt install <packagename>`.

## Remove build dependencies

```bash
# aptitude purge <packagename>-build-deps
```

> **Note:** using `apt-get purge <packagename>-build-deps` in combination with
`apt-get autoremove` instead of `aptitude purge package_name` will not remove all dependency packages.

# Build Process - upstream source using helper scripts
## Big picture
The big picture for building a single non-native Debian package from the upstream tarball debhello-0.0.tar.gz can be summarized as:
```bash
$ tar -xzmf debhello-0.0.tar.gz
$ cd debhello-0.0
$ debmake
  ... manual customization
$ debuild
```

## Get the upstream source
```bash
wget http://www.example.org/download/debhello-0.0.tar.gz
```

## Generate template files with debmake
The debmake command is the helper script for the Debian packaging.
- It always sets most of the obvious option states and values to reasonable defaults.
- It generates the upstream tarball and its required symlink if they are missing.
- It doesn’t overwrite the existing configuration files in the debian/ directory.
- It supports the multiarch package.
- It creates good template files such as the debian/copyright file compliant with DEP-5.

These features make Debian packaging with debmake simple and modern.  
Let's debianize the upstream source:
```bash
cd debhello-0.0
debmake
```

This command will generate several important template files:
- **debian/rules file** ( contains the package-specific recipes for compiling the source, if required, and constructing one or more binary packages)
- **debian/control** (provides the main meta data for the Debian package)
- **debian/copyright** (provides the copyright summary data of the Debian package)

## Modify template files
In order to install files as a part of the system files, the `$(prefix)` value of `/usr/local` in the Makefile should be overridden to be `/usr`. This can be accommodated by the `debian/rules` file with the `override_dh_auto_install` target setting `“prefix=/usr”`.

An example:
```bash
#!/usr/bin/make -f
export DH_VERBOSE = 1
export DEB_BUILD_MAINT_OPTIONS = hardening=+all
export DEB_CFLAGS_MAINT_APPEND  = -Wall -pedantic
export DEB_LDFLAGS_MAINT_APPEND = -Wl,--as-needed

%:
        dh $@

override_dh_auto_install:
        dh_auto_install -- prefix=/usr
```

## Build the DEB file
Run the following inside the working directory:
```bash
debuild -us -uc
```

## Install the DEB file
Once the previous command finishes, a .deb file is created and you can install it (as root) with:
```bash
dpkg -i <packagename>_<version>_<architecture>.deb
```

# Links
https://www.debian.org/doc/manuals/debmake-doc/ch04.en.html  
http://forums.debian.net/viewtopic.php?f=16&t=38976  
https://wiki.debian.org/SimpleBackportCreation
