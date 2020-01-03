# Intro
There are 3 options to build from source:
- create DEB from Debianized source
- create DEB from upstream source using helper scripts
- create DEB from upstream source using: `make` and `make install`

> **Important:** `make install` should be your absolute last resort. You should **NEVER** use it unless all other options have failed and you should **ONLY** use it IF the package you want to build is of mission critical importance. The `make install` routine is the most primitive method of building a package from source and has absolutely no concept of dependencies or package management. There's a reason why GNU/Linux distributions use package managers like APT or RPM. And that reason is to get as far away from make install as possible. Also if you want to uninstall a package that you installed with the make install routine, then you had better make sure you don't accidentally delete that package that you compiled (even if it grows to 20 GB) and you had better hope that its make uninstall routine works just as well as its installation routine or you'll be stuck manually deleting all of the files.


# Required packages for build
```
# apt-get install build-essential fakeroot devscripts
```
