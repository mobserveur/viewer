<picture>
  <source media="(prefers-color-scheme: dark)" srcset="doc/sl-logo-dark.png">
  <source media="(prefers-color-scheme: light)" srcset="doc/sl-logo.png">
  <img alt="Second Life Logo" src="doc/sl-logo.png">
</picture>

**[Second Life][] is a free 3D virtual world where users can create, connect and chat with others from around the
world.** This repository contains a fork of the source code for the official client.

## Open Source

Second Life provides a huge variety of tools for expression, content creation, socialization and play. Its vibrancy is
only possible because of input and contributions from its residents. The client codebase has been open source since
2007 and is available under the LGPL license. The [Open Source Portal][] contains additional information about Linden
Lab's open source history and projects.

## Download

Most people use a pre-built viewer release to access Second Life. macOS, GNU/Linux and FreeBSD builds are
[published on the official website][download]. More experimental viewers, such as release candidates and
project viewers, are detailed on the same page.

### Third Party Viewer

As a third party maintained fork, which includes Apple Silicon native builds, Megapahit viewer is indexed in the [Third Party Viewer Directory][tpv].

## Build Instructions

```
$ git clone git://megapahit.org/viewer.git
$ cd viewer
$ mkdir build-`uname -s|tr '[:upper:]' '[:lower:]'`-`uname -m`
$ cd build-`uname -s|tr '[:upper:]' '[:lower:]'`-`uname -m`
```

### macOS

```
$ sudo port install cmake pkgconfig freealut +universal apr-util +universal boost +universal boost181 +universal -no_static glm hunspell +universal freetype +universal minizip +universal openjpeg +universal pcre +universal uriparser +universal libvorbis +universal xxhashlib
$ export LL_BUILD="-O3 -gdwarf-2 -stdlib=libc++ -mmacosx-version-min=11 -iwithsysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk -std=c++17 -fPIC -DLL_RELEASE=1 -DLL_RELEASE_FOR_DOWNLOAD=1 -DNDEBUG -DPIC -DLL_DARWIN=1"
$ cmake -DCMAKE_BUILD_TYPE:STRING=Release -DADDRESS_SIZE:INTERNAL=64 -DUSESYSTEMLIBS:BOOL=ON -DUSE_OPENAL:BOOL=ON -DUSE_FMODSTUDIO:BOOL=OFF -DLL_TESTS:BOOL=OFF -DNDOF:BOOL=ON -DROOT_PROJECT_NAME:STRING=Megapahit -DVIEWER_CHANNEL:STRING=Megapahit -DVIEWER_BINARY_NAME:STRING=megapahit -DBUILD_SHARED_LIBS:BOOL=OFF -DINSTALL:BOOL=ON -DPACKAGE:BOOL=OFF -DCMAKE_INSTALL_PREFIX:PATH=newview/Megapahit.app/Contents/Resources -DCMAKE_OSX_ARCHITECTURES:STRING=`uname -m` -DCMAKE_OSX_DEPLOYMENT_TARGET:STRING=11 -DENABLE_SIGNING:BOOL=ON -DSIGNING_IDENTITY:STRING=- ../indra
$ sudo port deactivate boost
$ make -j`sysctl -n hw.ncpu`
$ sudo port activate boost
$ make install
$ open newview/Megapahit.app
```

### Debian

```
$ sudo apt install cmake pkg-config libxml2-utils libalut-dev libaprutil1-dev libboost-fiber1.81-dev libboost-json1.81-dev libboost-program-options1.81-dev libboost-regex1.81-dev libcollada-dom-dev libexpat1-dev libfltk1.3-dev libfontconfig-dev libfreetype-dev libglu1-mesa-dev libhunspell-dev libjpeg-dev libmeshoptimizer-dev libnghttp2-dev libpipewire-0.3-dev libpng-dev libsdl2-dev liburiparser-dev libvlc-dev libvlccore-dev libvorbis-dev libxft-dev libxmlrpc-epi-dev libxxhash-dev
$ export LL_BUILD="-O3 -std=c++17 -fPIC -DLL_LINUX=1"
$ cmake -DCMAKE_BUILD_TYPE:STRING=Release -DADDRESS_SIZE:INTERNAL=64 -DUSESYSTEMLIBS:BOOL=ON -DUSE_OPENAL:BOOL=ON -DUSE_FMODSTUDIO:BOOL=OFF -DLL_TESTS:BOOL=OFF -DNDOF:BOOL=ON -DROOT_PROJECT_NAME:STRING=Megapahit -DVIEWER_CHANNEL:STRING=Megapahit -DVIEWER_BINARY_NAME:STRING=megapahit -DBUILD_SHARED_LIBS:BOOL=OFF -DINSTALL:BOOL=ON -DPACKAGE:BOOL=ON ../indra
$ make -j`nproc`
$ cpack -G DEB
$ sudo apt install ./megapahit-`cat newview/viewer_version.txt`-Linux.deb
$ megapahit
```

### Ubuntu

```
$ sudo apt install cmake pkg-config libxml2-utils libaprutil1-dev libboost-fiber-dev libboost-json-dev libboost-program-options-dev libboost-regex-dev libcollada-dom-dev libexpat1-dev libfltk1.3-dev libfontconfig-dev libfreetype-dev libglu1-mesa-dev libhunspell-dev libjpeg-dev libmeshoptimizer-dev libnanosvg-dev libnghttp2-dev libpipewire-0.3-dev libpng-dev libsdl2-dev liburiparser-dev libvlc-dev libvlccore-dev libvorbis-dev libxft-dev libxmlrpc-epi-dev libxxhash-dev
$ export LL_BUILD="-O3 -std=c++17 -fPIC -DLL_LINUX=1"
$ cmake -DCMAKE_BUILD_TYPE:STRING=Release -DADDRESS_SIZE:INTERNAL=64 -DUSESYSTEMLIBS:BOOL=ON -DUSE_OPENAL:BOOL=OFF -DUSE_FMODSTUDIO:BOOL=ON -DLL_TESTS:BOOL=OFF -DNDOF:BOOL=ON -DROOT_PROJECT_NAME:STRING=Megapahit -DVIEWER_CHANNEL:STRING=Megapahit -DVIEWER_BINARY_NAME:STRING=megapahit -DBUILD_SHARED_LIBS:BOOL=OFF -DINSTALL:BOOL=ON -DPACKAGE:BOOL=ON ../indra
$ make -j`nproc`
$ cpack -G DEB
$ sudo apt install ./megapahit-`cat newview/viewer_version.txt`-Linux.deb
$ megapahit
```

### Fedora

```
$ sudo dnf install cmake gcc-c++ patchelf apr-util-devel boost-devel collada-dom-devel expat-devel fltk-devel mesa-libGLU-devel hunspell-devel minizip-ng-compat-devel libnghttp2-devel nanosvg-devel openjpeg-devel pipewire-devel pulseaudio-libs-devel SDL2-devel uriparser-devel vlc-devel libvorbis-devel xmlrpc-epi-devel xxhash-devel
$ export LL_BUILD="-O3 -std=c++17 -fPIC -DLL_LINUX=1"
$ cmake -DCMAKE_BUILD_TYPE:STRING=Release -DADDRESS_SIZE:INTERNAL=64 -DUSESYSTEMLIBS:BOOL=ON -DUSE_OPENAL:BOOL=OFF -DUSE_FMODSTUDIO:BOOL=ON -DLL_TESTS:BOOL=OFF -DNDOF:BOOL=ON -DROOT_PROJECT_NAME:STRING=Megapahit -DVIEWER_CHANNEL:STRING=Megapahit -DVIEWER_BINARY_NAME:STRING=megapahit -DBUILD_SHARED_LIBS:BOOL=OFF -DINSTALL:BOOL=ON -DPACKAGE:BOOL=ON ../indra
$ make -j`nproc`
$ cpack -G RPM
$ sudo rpm -i megapahit-`cat newview/viewer_version.txt`-Linux.rpm
$ megapahit
```

### FreeBSD

```
$ setenv LL_BUILD "-O3 -std=c++17 -fPIC"
$ sudo su -
# portmaster devel/cmake devel/pkgconf audio/freealut devel/apr1 x11-toolkits/fltk math/glm textproc/hunspell misc/meshoptimizer archivers/minizip graphics/nanosvg graphics/openjpeg devel/pcre devel/sdl20 net/uriparser multimedia/vlc audio/libvorbis net/xmlrpc-epi devel/xxhash
# exit
$ cmake -DCMAKE_BUILD_TYPE:STRING=Release -DADDRESS_SIZE:INTERNAL=64 -DUSESYSTEMLIBS:BOOL=ON -DUSE_OPENAL:BOOL=ON -DUSE_FMODSTUDIO:BOOL=OFF -DLL_TESTS:BOOL=OFF -DNDOF:BOOL=OFF -DROOT_PROJECT_NAME:STRING=Megapahit -DVIEWER_CHANNEL:STRING=Megapahit -DVIEWER_BINARY_NAME:STRING=megapahit -DBUILD_SHARED_LIBS:BOOL=OFF -DINSTALL:BOOL=ON -DPACKAGE:BOOL=ON ../indra
$ make -j`nproc`
$ sudo cpack -G FREEBSD
$ sudo pkg add megapahit-`cat newview/viewer_version.txt`-FreeBSD.pkg
$ sudo pkg set -yA 1 freealut apr1 fltk hunspell meshoptimizer minizip nanosvg openjpeg pcre sdl20 uriparser vlc libvorbis xmlrpc-epi
$ megapahit
```

## Contribute

Help make Megapahit better! You can get involved with improvements by filing bugs, suggesting enhancements, submitting
pull requests and more. See the [CONTRIBUTING][] and the [open source portal][] for details.

[Second Life]: https://secondlife.com/
[download]: https://megapahit.net
[tpv]: http://wiki.secondlife.com/wiki/Third_Party_Viewer_Directory/Megapahit
[open source portal]: http://wiki.secondlife.com/wiki/Open_Source_Portal
[contributing]: https://megapahit.org/viewer.git/tree/CONTRIBUTING.md
