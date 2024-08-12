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
```

### macOS

```
$ sudo port install cmake pkgconfig autoconf automake apr-util +universal boost +universal collada-dom +universal hunspell +universal freetype +universal jsoncpp +universal openjpeg +universal openssl11 +universal uriparser +universal libvorbis +universal xxhashlib
$ mkdir -p build/universal-apple-darwin`uname -r`/packages
$ cd ~/Downloads
$ curl -OL https://github.com/secondlife/3p-curl/releases/download/v7.54.1-513145c/curl-7.54.1-513145c-darwin64-513145c.tar.zst -OL https://automated-builds-secondlife-com.s3.amazonaws.com/ct2/115452/994130/nanosvg-2022.09.27-darwin64-580364.tar.bz2 -OL https://github.com/secondlife/3p-libndofdev/releases/download/v0.1.8e9edc7/libndofdev-0.1.8e9edc7-darwin64-8e9edc7.tar.zst -OL https://github.com/secondlife/3p-openssl/releases/download/v1.1.1q.de53f55/openssl-1.1.1q.de53f55-darwin64-de53f55.tar.zst -OL https://sourceforge.net/projects/xmlrpc-epi/files/xmlrpc-epi-base/0.54.2/xmlrpc-epi-0.54.2.tar.bz2
$ cd -
$ cd ..
$ tar xf ~/Downloads/xmlrpc-epi-0.54.2.tar.bz2
$ git clone https://github.com/secondlife/3p-openssl
$ git clone https://github.com/secondlife/3p-curl
$ git clone https://github.com/secondlife/3p-libndofdev
$ cd xmlrpc-epi-0.54.2
$ export CPPFLAGS="$CPPFLAGS -I$PWD/src"
$ rm -f config.sub missing
$ autoreconf -is
$ mkdir -p build/x86_64-apple-darwin`uname -r`
$ cd build/x86_64-apple-darwin`uname -r`
$ export CFLAGS="-arch x86_64 -mmacosx-version-min=10.5"
$ ../../configure --host=x86_64-apple-darwin`uname -r`
$ make -j`sysctl -n hw.ncpu`
$ sudo make install
$ cd -
$ sed -i '' -e 's/XMLRPC_VALUE find_named_value/__attribute__((always_inline)) XMLRPC_VALUE find_named_value/g' src/xmlrpc_introspection.c
$ sed -i '' -e 's/void describe_method/__attribute__((always_inline)) void describe_method/g' src/xmlrpc_introspection.c
$ mkdir -p build/aarch64-apple-darwin`uname -r`
$ cd build/aarch64-apple-darwin`uname -r`
$ export CFLAGS="-arch arm64 -mmacosx-version-min=11.0"
$ ../../configure --host=aarch64-apple-darwin`uname -r`
$ make -j`sysctl -n hw.ncpu`
$ sudo lipo src/.libs/libxmlrpc-epi.a /usr/local/lib/libxmlrpc-epi.a -create -output /usr/local/lib/libxmlrpc-epi.a
$ sudo lipo src/.libs/libxmlrpc-epi.0.dylib /usr/local/lib/libxmlrpc-epi.0.dylib -create -output /usr/local/lib/libxmlrpc-epi.0.dylib
$ unset CPPFLAGS CFLAGS
$ cd ../../../3p-openssl/openssl
$ mkdir -p build/aarch64-apple-darwin`uname -r`
$ cd build/aarch64-apple-darwin`uname -r`
$ ../../Configure no-shared darwin64-arm64-cc
$ make -j`sysctl -n hw.ncpu`
$ cd ../../../../3p-curl/curl
$ mkdir -p build/aarch64-apple-darwin`uname -r`
$ cd build/aarch64-apple-darwin`uname -r`
$ export CFLAGS="-arch arm64 -mmacosx-version-min=11.0 -std=c90"
$ sudo port deactivate openssl3
$ ../../configure --host=aarch64-apple-darwin`uname -r` --disable-alt-svc --disable-dict --disable-doh --disable-file --disable-gopher --disable-headers-api --disable-hsts --disable-imap --disable-ldap --disable-ldaps --disable-libcurl-option --disable-manual --disable-mqtt --disable-ntlm --disable-ntlm-wb --disable-pop3 --disable-rtsp --disable-shared --disable-smb --disable-smtp --disable-sspi --disable-telnet --disable-tftp --disable-tls-srp --disable-unix-sockets --disable-verbose --disable-versioned-symbols --enable-threaded-resolver --with-ssl=/opt/local/libexec/openssl11 --without-libidn2 --without-libpsl
$ make -j`sysctl -n hw.ncpu`
$ sudo port activate openssl3
$ unset CFLAGS
$ cd ../../../../3p-libndofdev/libndofdev
$ mkdir -p build/aarch64-apple-darwin`uname -r`
$ cd build/aarch64-apple-darwin`uname -r`
$ cmake -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_OSX_ARCHITECTURES:STRING=arm64 -DCMAKE_C_FLAGS:STRING="-DTARGET_OS_MAC -Wno-int-conversion" ../..
$ make -j`sysctl -n hw.ncpu`
$ cd ../../../../viewer/build/universal-apple-darwin`uname -r`/packages
$ tar xf ~/Downloads/curl-7.54.1-513145c-darwin64-513145c.tar.zst
$ tar xf ~/Downloads/nanosvg-2022.09.27-darwin64-580364.tar.bz2
$ tar xf ~/Downloads/libndofdev-0.1.8e9edc7-darwin64-8e9edc7.tar.zst
$ tar xf ~/Downloads/openssl-1.1.1q.de53f55-darwin64-de53f55.tar.zst
$ cd lib/release
$ lipo ../../../../../../3p-openssl/openssl/build/aarch64-apple-darwin`uname -r`/libcrypto.a libcrypto.a -create -output libcrypto.a
$ lipo ../../../../../../3p-openssl/openssl/build/aarch64-apple-darwin`uname -r`/libssl.a libssl.a -create -output libssl.a
$ lipo ../../../../../../3p-curl/curl/build/aarch64-apple-darwin`uname -r`/lib/.libs/libcurl.a libcurl.a -create -output libcurl.a
$ lipo ../../../../../../3p-libndofdev/libndofdev/build/aarch64-apple-darwin`uname -r`/src/libndofdev.dylib libndofdev.dylib -create -output libndofdev.dylib
$ cd ../../..
$ export LL_BUILD="-O3 -gdwarf-2 -stdlib=libc++ -mmacosx-version-min=10.15 -iwithsysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk -std=c++17 -fPIC -DLL_RELEASE=1 -DLL_RELEASE_FOR_DOWNLOAD=1 -DNDEBUG -DPIC -DLL_DARWIN=1"
$ cmake -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=newview/Megapahit.app/Contents/Resources -DCMAKE_OSX_ARCHITECTURES:STRING="arm64;x86_64" -DADDRESS_SIZE:INTERNAL=64 -DUSESYSTEMLIBS:BOOL=ON -DUSE_OPENAL:BOOL=OFF -DUSE_FMODSTUDIO:BOOL=ON -DLL_TESTS:BOOL=OFF -DNDOF:BOOL=ON -DVIEWER_CHANNEL:STRING=Megapahit -DVIEWER_BINARY_NAME:STRING=megapahit -DBUILD_SHARED_LIBS:BOOL=OFF -DINSTALL:BOOL=ON -DPACKAGE:BOOL=OFF ../../indra
$ make -j`sysctl -n hw.ncpu`
$ make install
$ open newview/Megapahit.app
```

### GNU/Linux

```
$ mkdir -p build/`uname -m`-linux-gnu/packages
$ cd ~/Downloads
$ curl -OL https://github.com/secondlife/3p-curl/releases/download/v7.54.1-513145c/curl-7.54.1-513145c-linux64-513145c.tar.zst -OL https://github.com/secondlife/3p-open-libndofdev/releases/download/v1.14-r2/open_libndofdev-0.14.8730039102-linux64-8730039102.tar.zst -OL https://github.com/secondlife/3p-openssl/releases/download/v1.1.1q.de53f55/openssl-1.1.1q.de53f55-linux64-de53f55.tar.zst
$ cd -
$ cd build/`uname -m`-linux-gnu/packages
$ tar xf ~/Downloads/curl-7.54.1-513145c-linux64-513145c.tar.zst
$ tar xf ~/Downloads/open_libndofdev-0.14.8730039102-linux64-8730039102.tar.zst
$ tar xf ~/Downloads/openssl-1.1.1q.de53f55-linux64-de53f55.tar.zst
$ cd ..
$ export LL_BUILD="-O3 -std=c++17 -fPIC -DLL_LINUX=1"
$ rm CMakeCache.txt
```

#### Debian 12.5

```
$ cd ~/Downloads
$ curl -OL https://automated-builds-secondlife-com.s3.amazonaws.com/ct2/115397/993664/nanosvg-2022.09.27-linux-580337.tar.bz2
$ cd -
$ cd packages
$ tar xf ~/Downloads/nanosvg-2022.09.27-linux-580337.tar.bz2
$ cd ..
$ sudo apt install pkg-config libaprutil1-dev libboost-fiber-dev libboost-program-options-dev libboost-regex-dev libcollada-dom-dev libexpat1-dev libfltk1.3-dev libfontconfig-dev libfreetype-dev libglu1-mesa-dev libhunspell-dev libjpeg-dev libjsoncpp-dev libmeshoptimizer-dev libnghttp2-dev libpng-dev libpipewire-0.3-dev libsdl2-dev liburiparser-dev libvlc-dev libvlccore-dev libvorbis-dev libxft-dev libxmlrpc-epi-dev libxxhash-dev
$ cmake -DCMAKE_BUILD_TYPE:STRING=Release -DADDRESS_SIZE:INTERNAL=64 -DUSESYSTEMLIBS:BOOL=ON -DUSE_OPENAL:BOOL=OFF -DUSE_FMODSTUDIO:BOOL=ON -DLL_TESTS:BOOL=OFF -DNDOF:BOOL=ON -DVIEWER_CHANNEL:STRING=Megapahit -DVIEWER_BINARY_NAME:STRING=megapahit -DBUILD_SHARED_LIBS:BOOL=OFF -DINSTALL:BOOL=ON -DPACKAGE:BOOL=ON ../../indra
$ make -j`nproc`
$ cpack -G DEB
$ sudo apt install megapahit-`cat newview/viewer_version.txt`-Linux.deb
$ megapahit
```

#### Ubuntu 24.04

```
$ sudo apt install pkg-config libaprutil1-dev libboost-fiber-dev libboost-program-options-dev libboost-regex-dev libcollada-dom-dev libexpat1-dev libfltk1.3-dev libglu1-mesa-dev libhunspell-dev libjsoncpp-dev libmeshoptimizer-dev libnanosvg-dev libnghttp2-dev libpipewire-0.3-dev libsdl2-dev liburiparser-dev libvlc-dev libvlccore-dev libvorbis-dev libxmlrpc-epi-dev libxxhash-dev
$ cmake -DCMAKE_BUILD_TYPE:STRING=Release -DADDRESS_SIZE:INTERNAL=64 -DUSESYSTEMLIBS:BOOL=ON -DUSE_OPENAL:BOOL=OFF -DUSE_FMODSTUDIO:BOOL=ON -DLL_TESTS:BOOL=OFF -DNDOF:BOOL=ON -DVIEWER_CHANNEL:STRING=Megapahit -DVIEWER_BINARY_NAME:STRING=megapahit -DBUILD_SHARED_LIBS:BOOL=OFF -DINSTALL:BOOL=ON -DPACKAGE:BOOL=ON ../../indra
$ make -j`nproc`
$ cpack -G DEB
$ sudo apt install megapahit-`cat newview/viewer_version.txt`-Linux.deb
$ megapahit
```

#### Fedora

```
$ sudo dnf install gcc-c++ patchelf apr-util-devel boost-devel collada-dom-devel expat-devel fltk-devel mesa-libGLU-devel hunspell-devel jsoncpp-devel libnghttp2-devel nanosvg-devel openjpeg-devel pipewire-devel pulseaudio-libs-devel SDL2-devel uriparser-devel vlc-devel libvorbis-devel xmlrpc-epi-devel xxhash-devel
$ cmake -DCMAKE_BUILD_TYPE:STRING=Release -DADDRESS_SIZE:INTERNAL=64 -DUSESYSTEMLIBS:BOOL=ON -DUSE_OPENAL:BOOL=OFF -DUSE_FMODSTUDIO:BOOL=ON -DLL_TESTS:BOOL=OFF -DNDOF:BOOL=ON -DVIEWER_CHANNEL:STRING=Megapahit -DVIEWER_BINARY_NAME:STRING=megapahit -DBUILD_SHARED_LIBS:BOOL=OFF -DINSTALL:BOOL=ON -DPACKAGE:BOOL=ON ../../indra
$ make -j`nproc`
$ cpack -G RPM
$ sudo rpm -i megapahit-`cat newview/viewer_version.txt`-Linux.rpm
$ megapahit
```

### FreeBSD

```
$ mkdir -p build/`uname -m`-unknown-freebsd14.1/packages
$ cd ~/Downloads
$ curl -OL https://github.com/secondlife/3p-openssl/releases/download/v1.1.1q.de53f55/openssl-1.1.1q.de53f55-linux64-de53f55.tar.zst
$ cd -
$ cd ..
$ git clone https://github.com/secondlife/3p-openssl
$ git clone https://github.com/secondlife/3p-curl
$ cd 3p-openssl/openssl
$ mkdir -p build/`uname -m`-unknown-freebsd14.1
$ cd -p build/`uname -m`-unknown-freebsd14.1
$ ../../config no-shared
$ make -j`nproc`
$ cd ../../../../viewer/build/`uname -m`-unknown-freebsd14.1/packages
$ tar xf ~/Downloads/openssl-1.1.1q.de53f55-linux64-de53f55.tar.zst
$ cp ../../../../3p-openssl/openssl/build/`uname -m`-unknown-freebsd14.1/lib*.a lib/release/
$ cd ..
$ setenv LL_BUILD "-O3 -std=c++17 -fPIC"
$ sudo su -
# portmaster devel/cmake devel/pkgconf audio/freealut devel/apr1 devel/collada-dom x11-toolkits/fltk textproc/hunspell misc/meshoptimizer graphics/nanosvg graphics/openjpeg devel/sdl20 net/uriparser multimedia/vlc audio/libvorbis net/xmlrpc-epi devel/xxhash
# exit
$ rm CMakeCache.txt
$ cmake -DCMAKE_BUILD_TYPE:STRING=Release -DADDRESS_SIZE:INTERNAL=64 -DUSESYSTEMLIBS:BOOL=ON -DUSE_OPENAL:BOOL=ON -DLL_TESTS:BOOL=OFF -DNDOF:BOOL=OFF -DVIEWER_CHANNEL:STRING=Megapahit -DVIEWER_BINARY_NAME:STRING=megapahit -DBUILD_SHARED_LIBS:BOOL=OFF -DINSTALL:BOOL=ON -DPACKAGE:BOOL=ON ../../indra
$ make -j`nproc`
$ sudo cpack -G FREEBSD
$ sudo pkg add megapahit-`cat newview/viewer_version.txt`-FreeBSD.pkg
$ sudo pkg set -yA 1 freealut apr1 collada-dom fltk hunspell meshoptimizer nanosvg openjpeg sdl20 uriparser vlc libvorbis xmlrpc-epi
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
