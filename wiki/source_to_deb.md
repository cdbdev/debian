# Contents
- [1. Introduction](#1-introduction)
- [2. Prerequisites](#2-Prerequisites)
- [3. Build Process - Debianized source](#3-Build-Process---Debianized-source) 
- [4. Build Process - upstream source using helper scripts](#4-Build-Process---upstream-source-using-helper-scripts)
- [5. Links](#5-Links)

# 1. Introduction
There are 3 options to build from source:
- create DEB from Debianized source
- create DEB from upstream source using helper scripts
- create binaries from upstream source using: `make` and `make install`

The first 2 options create so called `backports`, the last one installs the software under `/usr/local/`. The last option will not be discussed here.

> **Important:** `make install` should be your absolute last resort. You should **NEVER** use it unless all other options have failed and you should **ONLY** use it IF the package you want to build is of mission critical importance. The `make install` routine is the most primitive method of building a package from source and has absolutely no concept of dependencies or package management. There's a reason why GNU/Linux distributions use package managers like `APT` or `RPM`. And that reason is to get as far away from `make install` as possible. Also if you want to uninstall a package that you installed with the `make install` routine, you better hope that its `make uninstall` routine works just as well as its installation routine or you'll be stuck manually deleting all of the files.

# 2. Prerequisites
## 2.1 Install required packages for build
```bash
# apt-get install build-essential fakeroot devscripts debmake
```

## 2.2 Configure apt
The next thing that you need to do, is make sure that you have some **source repositories** configured in your computer.  
Open your `/etc/apt/sources.list` file and check if you have one or more lines that start with `deb-src`:

```bash
deb-src http://ftp.debian.org/debian/ unstable main
deb-src http://ftp.debian.org/debian/ experimental main
```
Once you've added the line, you'll need to do `apt-get update`.

## 2.3 Add a local repository
In case you need to install a package with a lot of dependencies, which need to be installed separately, you can add a local repository. This option allows the `apt` command to also look for the dependencies in a specific directory on the local host.  

An easy tool to use is: `local-apt-repository`.
> **NOTE:** This option is only available tot the local host, not to other machines.
```bash
# apt-get install local-apt-repository
# mkdir /srv/local-apt-repository
```

# 3. Build Process - Debianized source
## 3.1 Get the dependencies for your package
The following will install a dependency package named `<packagename>-build-deps`:
```bash
# mk-build-deps <packagename> --install --remove
```

> **WARNING:** Do not use `apt-get build-dep <packagename>`, the problem is that there is no easy way to undo or revert the installation of the build dependencies. All the installed packages are marked as manually installed, so later one cannot simply expect to “autoremove” those packages. 
  
## 3.2 Get the source package
In order to get the source of your package, go to your working directory and run:
```bash
$ apt-get source <packagename>
$ cd <packagename>-<version>/
```

## 3.3 Change package version number
If you're running Debian Stable, you may want to change the package's version number to make a proper backport. 

Format of backported package version is as follows: `~bpo${debian_release}+${build_int}`.  
Some examples:
- 1.2.3-4 now becomes 1.2.3-4~bpo9+1 for stretch
- 1.2.3-4 now becomes 1.2.3-4~bpo10+1 for buster

The following command does this for you:
```bash
$ debchange --bpo
```
A text editor opens in which you can put some comment and save your changes.

## 3.4 Build the DEB file
Run the following inside the working directory:
```bash
$ debuild -us -uc -jauto
```
That last command may take a minute or an hour or three hours. It all depends on the size of the package and your own hardware. Once the command finishes, 1 or more .deb file are created.

> **INFO**: It could be that several tests fail during build. Most of the time this is not a problem. Debian packagers have to disable some or all of them for certain packages, since they fail in the standard chroot or schroot build environments that they use. If you really want to be sure, you can check if these errors occurred during the official builds: https://buildd.debian.org/. If you see the errors for the respective build there, then it must be okay because the Debian developers saw fit to release it in that state.

## 3.5 Install the DEB file
To find out the name of your generated .deb file, search for a file with extension **.build**. This will leave you with an indication of the filename.  

You can install a deb by running the following command:
```bash
# dpkg -i <packagename>_<version>_<architecture>.deb
```
This works if the package does not have other dependencies that were created during build. If there are other generated dependencies, the best method to use is `local-apt-repository`. 

Example when extra dependencies are required (e.g. php package):
```bash
Selecting previously unselected package php7.4.
(Reading database ... 207306 files and directories currently installed.)
Preparing to unpack php7.4_7.4.0~rc6-1~bpo10+1_all.deb ...
Unpacking php7.4 (7.4.0~rc6-1~bpo10+1) ...
dpkg: dependency problems prevent configuration of php7.4:
 php7.4 depends on libapache2-mod-php7.4 | php7.4-fpm | php7.4-cgi; however:
  Package libapache2-mod-php7.4 is not installed.
  Package php7.4-fpm is not installed.
  Package php7.4-cgi is not installed.
 php7.4 depends on php7.4-common; however:
  Package php7.4-common is not installed.

dpkg: error processing package php7.4 (--install):
 dependency problems - leaving unconfigured
Errors were encountered while processing:
 php7.4

```

In this case, just copy all the .deb files to **/srv/local-apt-repository**, run `apt update` and next `apt install <packagename>`. For more info see: [Prerequisite -> Local Repository](#23-Add-a-local-repository).

## 3.6 Remove build dependencies

```bash
# aptitude purge <package name>-build-deps
```
> **Note:** using `apt-get purge <packagename>-build-deps` in combination with`apt-get autoremove` instead of `aptitude purge package_name` will not remove all dependency packages.

# 4. Build Process - upstream source using helper scripts
## 4.1 Big picture
The big picture for building a single non-native Debian package from the upstream tarball debhello-0.0.tar.gz can be summarized as:
```bash
$ tar -xzmf debhello-0.0.tar.gz
$ cd debhello-0.0
$ debmake
  ... manual customization
$ debuild
```

## 4.2 Get the upstream source
```bash
wget http://www.example.org/download/debhello-0.0.tar.gz
```

## 4.3 Generate template files with debmake
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
- **debian/rules** file ( contains the package-specific recipes for compiling the source, if required, and constructing one or more binary packages)
- **debian/control** (provides the main meta data for the Debian package)
- **debian/copyright** (provides the copyright summary data of the Debian package)

## 4.4 Modify template files
In order to install files as a part of the system files, the `$(prefix)` value of `/usr/local` in the Makefile should be overridden to be `/usr`. This can be accommodated by the `debian/rules` file with the `override_dh_auto_install` target setting `“prefix=/usr”`.

Example (install to /usr):
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

Example (several overrides):
```bash
#!/usr/bin/make -f
# You must remove unused comment lines for the released package.
#export DH_VERBOSE = 1
#export DEB_BUILD_MAINT_OPTIONS = hardening=+all
#export DEB_CFLAGS_MAINT_APPEND  = -Wall -pedantic
#export DEB_LDFLAGS_MAINT_APPEND = -Wl,--as-needed

%:
	dh $@
override_dh_auto_configure:
	./configure --prefix=/usr 

override_dh_auto_build:
	make -j4
	make doc

override_dh_auto_test:
	make test-only || echo "warning: tests failed" > tests.log

override_dh_usrlocal:
	
```

## 4.5 Build the DEB file
Run the following inside the working directory:
```bash
debuild -us -uc
```

> **INFO**: It could be that several lintian errors occur during build. This is normal behaviour, lots of official Debian packages have a long list of overrides, or even extant Lintian issues: https://lintian.debian.org/tags.html. You can use a Lintian override to get rid of them if desired: https://lintian.debian.org/manual/section-2.4.html.

## 4.6 Install the DEB file
Once the previous command finishes, a .deb file is created and you can install it (as root) with:
```bash
dpkg -i <packagename>_<version>_<architecture>.deb
```

# 5. Links
https://www.debian.org/doc/manuals/debmake-doc/ch04.en.html  
http://forums.debian.net/viewtopic.php?f=16&t=38976  
https://wiki.debian.org/SimpleBackportCreation
