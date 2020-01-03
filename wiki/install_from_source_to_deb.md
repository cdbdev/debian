# Intro
There are 2 options to build from source:
- create DEB from Debianized source
- create DEB from upstream source using: `make install`, `configure`, ...**

`make install` should be your absolute last resort. You should NEVER use it unless all other options have failed and you should ONLY use it IF the package you want to build is of mission critical importance.

# Required packages for build
```
# apt-get install build-essential fakeroot devscripts
```
