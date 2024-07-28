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
$ cd viewer
$ git remote add megapahit git://megapahit.org/viewer.git
$ git fetch megapahit
$ git checkout megapahit/main
$ git switch -c megapahit
```

### macOS

```
$ sudo port install cmake pkgconfig apr-util +universal boost +universal collada-dom +universal hunspell +universal jsoncpp +universal openjpeg +universal libsdl2 +universal uriparser +universal libvorbis +universal
$ mkdir -p build/universal-apple-darwin`uname -r`/packages
$ cd ~/Downloads
$ curl -OL https://github.com/secondlife/3p-curl/releases/download/v7.54.1-513145c/curl-7.54.1-513145c-darwin64-513145c.tar.zst -OL https://megapahit.net/downloads/dullahan-1.14.0.202312131437_118.7.1_g99817d2_chromium-118.0.5993.119-darwinuniversal-233471337.tar.bz2 -OL https://github.com/secondlife/3p-emoji-shortcodes/releases/download/v6.1.0.5413f58/emoji_shortcodes-6.1.0.5413f58-darwin64-5413f58.tar.zst -OL https://github.com/secondlife/3p-glh_linear/releases/download/v1.0.1-dev4-984c397/glh_linear-1.0.1-dev4-common-984c397.tar.zst -OL https://github.com/secondlife/llca/releases/download/v202402012004.0-0f5d9c3/llca-202402012004.0-common-0f5d9c3.tar.zst -L https://github.com/zeux/meshoptimizer/archive/refs/tags/v0.21.tar.gz -o meshoptimizer-0.21.tar.gz -OL https://github.com/secondlife/3p-mikktspace/releases/download/v2-e967e1b/mikktspace-1-darwin64-8756084692.tar.zst -OL https://automated-builds-secondlife-com.s3.amazonaws.com/ct2/115452/994130/nanosvg-2022.09.27-darwin64-580364.tar.bz2 -OL https://github.com/secondlife/3p-libndofdev/releases/download/v0.1.8e9edc7/libndofdev-0.1.8e9edc7-darwin64-8e9edc7.tar.zst -L https://github.com/uclouvain/openjpeg/archive/refs/tags/v2.5.2.tar.gz -o openjpeg-2.5.2.tar.gz -OL https://github.com/secondlife/3p-openssl/releases/download/v1.1.1q.de53f55/openssl-1.1.1q.de53f55-darwin64-de53f55.tar.zst -OL https://github.com/secondlife/3p-tinyexr/releases/download/v1.0.8-ba4bc64/tinyexr-v1.0.8-common-9373975608.tar.zst -OL https://github.com/secondlife/3p-tinygltf/releases/download/v2.5.0-1ae57fd/tinygltf-v2.5.0-common-1ae57fd.tar.zst -OL https://github.com/secondlife/3p-viewer-fonts/releases/download/v1.0.0-r1/viewer_fonts-1.0.0.8512067490-common-8512067490.tar.zst -OL https://sourceforge.net/projects/xmlrpc-epi/files/xmlrpc-epi-base/0.54.2/xmlrpc-epi-0.54.2.tar.bz2
$ cd -
$ cd ..
$ open ~/Downloads/fmodstudioapi20222mac-installer.dmg
$ mkdir -p viewer/build/universal-apple-darwin`uname -r`/packages/include/fmodstudio
$ cp /Volumes/FMOD\ Programmers\ API\ Mac/FMOD\ Programmers\ API/api/core/inc/fmod*.h* viewer/build/universal-apple-darwin`uname -r`/packages/include/fmodstudio/
$ cp /Volumes/FMOD\ Programmers\ API\ Mac/FMOD\ Programmers\ API/api/core/lib/libfmod.dylib viewer/build/universal-apple-darwin`uname -r`/packages/lib/release/
$ tar xf ~/Downloads/meshoptimizer-0.21.tar.gz
$ tar xf ~/Downloads/openjpeg-2.5.2.tar.gz
$ tar xf ~/Downloads/xmlrpc-epi-0.54.2.tar.bz2
$ git clone https://github.com/secondlife/3p-openssl
$ git clone https://github.com/secondlife/3p-curl
$ git clone https://github.com/secondlife/3p-libndofdev
$ cd meshoptimizer-0.21
$ mkdir -p build/universal-apple-darwin`uname -r`
$ cd build/universal-apple-darwin`uname -r`
$ cmake -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_OSX_ARCHITECTURES:STRING="arm64;x86_64" -DCMAKE_OSX_DEPLOYMENT_TARGET:STRING=12.0 -DMESHOPT_BUILD_SHARED_LIBS:BOOL=ON ../..
$ make -j`sysctl -n hw.ncpu`
$ sudo make install
$ cd ../../../openjpeg-2.5.2
$ sudo cp src/lib/openjp2/cio.h src/lib/openjp2/event.h /opt/local/include/openjpeg-2.5/
$ mkdir -p build/`uname -m`-apple-darwin`uname -r`
$ cd build/`uname -m`-apple-darwin`uname -r`
$ cmake -DCMAKE_BUILD_TYPE:STRING=Release ../..
$ sudo cp src/lib/openjp2/opj_config_private.h /opt/local/include/openjpeg-2.5/
$ cd ../../../xmlrpc-epi-0.54.2
$ export CPPFLAGS="$CPPFLAGS -I$PWD/src"
$ rm -f config.sub missing
$ autoreconf -is
$ mkdir -p build/x86_64-apple-darwin`uname -r`
$ cd build/x86_64-apple-darwin`uname -r`
$ export CFLAGS="-arch x86_64"
$ ../../configure --host=x86_64-apple-darwin`uname -r`
$ make -j`sysctl -n hw.ncpu`
$ sudo make install
$ cd -
$ sed -i '' -e 's/XMLRPC_VALUE find_named_value/__attribute__((always_inline)) XMLRPC_VALUE find_named_value/g' src/xmlrpc_introspection.c
$ sed -i '' -e 's/void describe_method/__attribute__((always_inline)) void describe_method/g' src/xmlrpc_introspection.c
$ mkdir -p build/aarch64-apple-darwin`uname -r`
$ cd build/aarch64-apple-darwin`uname -r`
$ export CFLAGS="-arch arm64"
$ ../../configure --host=aarch64-apple-darwin`uname -r`
$ make -j`sysctl -n hw.ncpu`
$ sudo lipo src/.libs/libxmlrpc-epi.a /usr/local/lib/libxmlrpc-epi.a -create -output /usr/local/lib/libxmlrpc-epi.a
$ sudo lipo src/.libs/libxmlrpc-epi.0.dylib /usr/local/lib/libxmlrpc-epi.0.dylib -create -output /usr/local/lib/libxmlrpc-epi.0.dylib
$ unset CPPFLAGS CFLAGS
$ cd ../../../../3p-openssl/openssl
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
$ cmake -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_OSX_ARCHITECTURES:STRING=arm64 -DCMAKE_C_FLAGS:STRING=-DTARGET_OS_MAC ../..
$ make -j`sysctl -n hw.ncpu`
$ cd ../../../../viewer/indra/newview
$ tar xf ~/Downloads/viewer_fonts-1.0.0.8512067490-common-8512067490.tar.zst
$ cd ../../build/universal-apple-darwin`uname -r`/packages
$ tar xf ~/Downloads/curl-7.54.1-513145c-darwin64-513145c.tar.zst
$ tar xf ~/Downloads/dullahan-1.14.0.202312131437_118.7.1_g99817d2_chromium-118.0.5993.119-darwinuniversal-233471337.tar.bz2
$ tar xf ~/Downloads/emoji_shortcodes-6.1.0.5413f58-darwin64-5413f58.tar.zst
$ tar xf ~/Downloads/glh_linear-1.0.1-dev4-common-984c397.tar.zst
$ tar xf ~/Downloads/llca-202402012004.0-common-0f5d9c3.tar.zst
$ tar xf ~/Downloads/mikktspace-1-darwin64-8756084692.tar.zst
$ tar xf ~/Downloads/nanosvg-2022.09.27-darwin64-580364.tar.bz2
$ tar xf ~/Downloads/libndofdev-0.1.8e9edc7-darwin64-8e9edc7.tar.zst
$ tar xf ~/Downloads/openssl-1.1.1q.de53f55-darwin64-de53f55.tar.zst
$ tar xf ~/Downloads/tinyexr-v1.0.8-common-9373975608.tar.zst
$ tar xf ~/Downloads/tinygltf-v2.5.0-common-1ae57fd.tar.zst
$ cd lib/release
$ lipo ../../../../../../3p-openssl/openssl/build/aarch64-apple-darwin`uname -r`/libcrypto.a libcrypto.a -create -output libcrypto.a
$ lipo ../../../../../../3p-openssl/openssl/build/aarch64-apple-darwin`uname -r`/libssl.a libssl.a -create -output libssl.a
$ lipo ../../../../../../3p-curl/curl/build/aarch64-apple-darwin`uname -r`/lib/.libs/libcurl.a libcurl.a -create -output libcurl.a
$ lipo ../../../../../../3p-libndofdev/libndofdev/build/aarch64-apple-darwin`uname -r`/src/libndofdev.dylib libndofdev.dylib -create -output libndofdev.dylib
$ cd ../../..
$ cd /opt/local/include
$ sudo curl -OL https://raw.githubusercontent.com/DLTcollab/sse2neon/master/sse2neon.h
$ cd -
$ export LL_BUILD="-O3 -gdwarf-2 -stdlib=libc++ -iwithsysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk -std=c++17 -fPIC -DLL_RELEASE=1 -DLL_RELEASE_FOR_DOWNLOAD=1 -DNDEBUG -DPIC -DLL_DARWIN=1"
$ cmake -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=newview/Megapahit.app/Contents/Resources -DCMAKE_OSX_ARCHITECTURES:STRING="arm64;x86_64" -DADDRESS_SIZE:INTERNAL=64 -DUSESYSTEMLIBS:BOOL=ON -DUSE_OPENAL:BOOL=OFF -DUSE_FMODSTUDIO:BOOL=ON -DLL_TESTS:BOOL=OFF -DNDOF:BOOL=ON -DVIEWER_CHANNEL:STRING=Megapahit -DVIEWER_BINARY_NAME:STRING=megapahit -DBUILD_SHARED_LIBS:BOOL=OFF -DINSTALL:BOOL=ON -DPACKAGE:BOOL=OFF ../../indra
$ cmake ../../indra
$ make -j`sysctl -n hw.ncpu`
$ make install
$ open newview/Megapahit.app
```

### GNU/Linux

```
$ mkdir -p build/`uname -m`-linux-gnu/packages
$ cd ~/Downloads
$ curl -OL https://github.com/secondlife/3p-curl/releases/download/v7.54.1-513145c/curl-7.54.1-513145c-linux64-513145c.tar.zst -OL https://github.com/secondlife/dullahan/releases/download/v1.14.0-r2/dullahan-1.14.0.202404051708_118.4.1_g3dd6078_chromium-118.0.5993.54-linux64-8573290624.tar.zst -OL https://github.com/secondlife/3p-emoji-shortcodes/releases/download/v6.1.0.5413f58/emoji_shortcodes-6.1.0.5413f58-linux64-5413f58.tar.zst -OL https://github.com/secondlife/3p-glh_linear/releases/download/v1.0.1-dev4-984c397/glh_linear-1.0.1-dev4-common-984c397.tar.zst -OL https://github.com/secondlife/llca/releases/download/v202402012004.0-0f5d9c3/llca-202402012004.0-common-0f5d9c3.tar.zst -OL https://github.com/secondlife/3p-mikktspace/releases/download/v2-e967e1b/mikktspace-1-linux64-8756084692.tar.zst -OL https://github.com/secondlife/3p-open-libndofdev/releases/download/v1.14-r2/open_libndofdev-0.14.8730039102-linux64-8730039102.tar.zst -OL https://github.com/uclouvain/openjpeg/releases/download/v2.5.2/openjpeg-v2.5.2-linux-x86_64.tar.gz -L https://github.com/uclouvain/openjpeg/archive/refs/tags/v2.5.2.tar.gz -o openjpeg-2.5.2.tar.gz -OL https://github.com/secondlife/3p-openssl/releases/download/v1.1.1q.de53f55/openssl-1.1.1q.de53f55-linux64-de53f55.tar.zst -OL https://github.com/secondlife/3p-tinyexr/releases/download/v1.0.8-ba4bc64/tinyexr-v1.0.8-common-9373975608.tar.zst -OL https://github.com/secondlife/3p-tinygltf/releases/download/v2.5.0-1ae57fd/tinygltf-v2.5.0-common-1ae57fd.tar.zst -OL https://github.com/secondlife/3p-viewer-fonts/releases/download/v1.0.0-r1/viewer_fonts-1.0.0.8512067490-common-8512067490.tar.zst
$ cd -
$ cd indra/newview
$ tar xf ~/Downloads/viewer_fonts-1.0.0.8512067490-common-8512067490.tar.zst
$ cd ../../build/`uname -m`-linux-gnu/packages
$ tar xf ~/Downloads/curl-7.54.1-513145c-linux64-513145c.tar.zst
$ tar xf ~/Downloads/dullahan-1.14.0.202404051708_118.4.1_g3dd6078_chromium-118.0.5993.54-linux64-8573290624.tar.zst
$ tar xf ~/Downloads/emoji_shortcodes-6.1.0.5413f58-linux64-5413f58.tar.zst
$ tar xf ~/Downloads/glh_linear-1.0.1-dev4-common-984c397.tar.zst
$ tar xf ~/Downloads/llca-202402012004.0-common-0f5d9c3.tar.zst
$ tar xf ~/Downloads/mikktspace-1-linux64-8756084692.tar.zst
$ tar xf ~/Downloads/open_libndofdev-0.14.8730039102-linux64-8730039102.tar.zst
$ tar xf ~/Downloads/openssl-1.1.1q.de53f55-linux64-de53f55.tar.zst
$ tar xf ~/Downloads/tinyexr-v1.0.8-common-9373975608.tar.zst
$ tar xf ~/Downloads/tinygltf-v2.5.0-common-1ae57fd.tar.zst
$ cd ../../../..
$ tar xf ~/Downloads/fmodstudioapi20223linux.tar.gz
$ mkdir viewer/build/`uname -m`-linux-gnu/packages/include/fmodstudio
$ cp fmodstudioapi20223linux/api/core/inc/fmod*.h* viewer/build/`uname -m`-linux-gnu/packages/include/fmodstudio/
$ cp -P fmodstudioapi20223linux/api/core/lib/x86_64/libfmod.so* viewer/build/`uname -m`-linux-gnu/packages/lib/release/
$ tar xf ~/Downloads/openjpeg-v2.5.2-linux-x86_64.tar.gz
$ cp -R openjpeg-v2.5.2-linux-x86_64/include/openjpeg-2.5 viewer/build/`uname -m`-linux-gnu/packages/include/openjpeg
$ cp openjpeg-v2.5.2-linux-x86_64/lib/libopenjp2.a viewer/build/`uname -m`-linux-gnu/packages/lib/release/
$ tar xf ~/Downloads/openjpeg-2.5.2.tar.gz
$ cd openjpeg-2.5.2
$ cp src/lib/openjp2/cio.h src/lib/openjp2/event.h ../viewer/build/`uname -m`-linux-gnu/packages/include/openjpeg/
$ mkdir -p build/`uname -m`-linux-gnu
$ cd build/`uname -m`-linux-gnu
$ cmake -DCMAKE_BUILD_TYPE:STRING=Release ../..
$ cp src/lib/openjp2/opj_config_private.h ../../../viewer/build/`uname -m`-linux-gnu/packages/include/openjpeg/
$ cd ../../../viewer/build/`uname -m`-linux-gnu
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
$ cmake -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -DADDRESS_SIZE:INTERNAL=64 -DUSESYSTEMLIBS:BOOL=ON -DUSE_OPENAL:BOOL=OFF -DUSE_FMODSTUDIO:BOOL=ON -DLL_TESTS:BOOL=OFF -DNDOF:BOOL=ON -DVIEWER_CHANNEL:STRING=Megapahit -DVIEWER_BINARY_NAME:STRING=megapahit -DBUILD_SHARED_LIBS:BOOL=OFF -DINSTALL:BOOL=ON -DPACKAGE:BOOL=ON -DCPACK_PACKAGE_NAME:STRING=megapahit -DCPACK_BINARY_STGZ:BOOL=OFF -DCPACK_BINARY_TGZ:BOOL=OFF -DCPACK_BINARY_TZ:BOOL=OFF -DCPACK_BINARY_DEB:BOOL=ON -DCPACK_DEBIAN_PACKAGE_ARCHITECTURE:STRING=amd64 -DCPACK_DEBIAN_PACKAGE_DESCRIPTION:STRING="A fork of the Second Life viewer" -DCPACK_DEBIAN_PACKAGE_MAINTAINER:STRING=$USER@$HOST -DCPACK_DEBIAN_PACKAGE_SECTION:STRING=net -DCPACK_DEBIAN_PACKAGE_DEPENDES:STRING="libaprutil1, libboost-fiber1.74.0 | libboost-fiber1.81.0, libboost-program-options1.74.0 | libboost-program-options1.81.0, libboost-regex1.74.0 | libboost-regex1.81.0, libboost-thread1.74.0 | libboost-thread1.81.0, libcollada-dom2.5-dp0, libexpat1, libfltk1.3, libglu1-mesa, libhunspell-1.7-0, libjsoncpp25, libmeshoptimizer2d (>= 0.18), libnghttp2-14, libsdl2-2.0-0, liburiparser1, libvlc5, libvorbisenc2, libvorbisfile3, libxmlrpc-epi0, vlc-plugin-base" ../../indra
$ cmake ../../indra
$ make -j`nproc`
$ cpack -G DEB
$ sudo apt install megapahit-`cat newview/viewer_version.txt`-Linux.deb
$ megapahit
```

#### Ubuntu 24.04

```
$ sudo apt install pkg-config libaprutil1-dev libboost-fiber-dev libboost-program-options-dev libboost-regex-dev libcollada-dom-dev libexpat1-dev libfltk1.3-dev libglu1-mesa-dev libhunspell-dev libjsoncpp-dev libmeshoptimizer-dev libnanosvg-dev libnghttp2-dev libsdl2-dev liburiparser-dev libvlc-dev libvlccore-dev libvorbis-dev libxmlrpc-epi-dev libxxhash-dev
$ cmake -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -DADDRESS_SIZE:INTERNAL=64 -DUSESYSTEMLIBS:BOOL=ON -DUSE_OPENAL:BOOL=OFF -DUSE_FMODSTUDIO:BOOL=ON -DLL_TESTS:BOOL=OFF -DNDOF:BOOL=ON -DVIEWER_CHANNEL:STRING=Megapahit -DVIEWER_BINARY_NAME:STRING=megapahit -DBUILD_SHARED_LIBS:BOOL=OFF -DINSTALL:BOOL=ON -DPACKAGE:BOOL=ON -DCPACK_PACKAGE_NAME:STRING=megapahit -DCPACK_BINARY_STGZ:BOOL=OFF -DCPACK_BINARY_TGZ:BOOL=OFF -DCPACK_BINARY_TZ:BOOL=OFF -DCPACK_BINARY_DEB:BOOL=ON -DCPACK_DEBIAN_PACKAGE_ARCHITECTURE:STRING=amd64 -DCPACK_DEBIAN_PACKAGE_DESCRIPTION:STRING="A fork of the Second Life viewer" -DCPACK_DEBIAN_PACKAGE_MAINTAINER:STRING=$USER@$HOST -DCPACK_DEBIAN_PACKAGE_SECTION:STRING=net -DCPACK_DEBIAN_PACKAGE_DEPENDES:STRING="libaprutil1t64, libboost-fiber1.83.0, libboost-program-options1.83.0, libboost-regex1.83.0, libboost-thread1.83.0, libcollada-dom2.5-dp0, libexpat1, libfltk2.0-0t64, libglu1-mesa, libhunspell-1.7-0, libjsoncpp25, libmeshoptimizer2d, libnghttp2-14, libsdl2-2.0-0, liburiparser1, libvlc5, libvorbisenc2, libvorbisfile3, libxmlrpc-epi0t64, vlc-plugin-base" ../../indra
$ cmake ../../indra
$ make -j`nproc`
$ cpack -G DEB
$ sudo apt install megapahit-`cat newview/viewer_version.txt`-Linux.deb
$ megapahit
```

#### Fedora

```
$ cd ~/Downloads
$ curl -L https://github.com/zeux/meshoptimizer/archive/refs/tags/v0.21.tar.gz -o meshoptimizer-0.21.tar.gz
$ cd -
$ cd ../../..
$ tar xf ~/Downloads/meshoptimizer-0.21.tar.gz
$ cd meshoptimizer-0.21
$ mkdir -p build/`uname -m`-linux-gnu
$ cd build/`uname -m`-linux-gnu
$ cmake -DCMAKE_BUILD_TYPE:STRING=Release ../..
$ make -j`nproc`
$ sudo make install
$ cd ../../../viewer/build/`uname -m`-linux-gnu
$ sudo dnf install gcc-c++ patchelf apr-util-devel boost-devel collada-dom-devel expat-devel fltk-devel mesa-libGLU-devel hunspell-devel jsoncpp-devel libnghttp2-devel nanosvg-devel pipewire-devel pulseaudio-libs-devel SDL2-devel uriparser-devel vlc-devel libvorbis-devel xmlrpc-epi-devel xxhash-devel
$ patchelf --remove-rpath packages/bin/release/dullahan_host
$ cmake -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -DADDRESS_SIZE:INTERNAL=64 -DUSESYSTEMLIBS:BOOL=ON -DUSE_OPENAL:BOOL=OFF -DUSE_FMODSTUDIO:BOOL=ON -DLL_TESTS:BOOL=OFF -DNDOF:BOOL=ON -DVIEWER_CHANNEL:STRING=Megapahit -DVIEWER_BINARY_NAME:STRING=megapahit -DBUILD_SHARED_LIBS:BOOL=OFF -DINSTALL:BOOL=ON -DPACKAGE:BOOL=ON -DCPACK_PACKAGE_NAME:STRING=megapahit -DCPACK_BINARY_STGZ:BOOL=OFF -DCPACK_BINARY_TGZ:BOOL=OFF -DCPACK_BINARY_TZ:BOOL=OFF -DCPACK_BINARY_RPM:BOOL=ON -DCPACK_RPM_PACKAGE_SUMMARY:STRING="A fork of the Second Life viewer" -DCPACK_RPM_PACKAGE_ARCHITECTURE:STRING=`uname -m` -DCPACK_RPM_PACKAGE_LICENSE:STRING=LGPL-2.1-only -DCPACK_RPM_PACKAGE_VENDOR:STRING=Megapahit -DCPACK_RPM_PACKAGE_URL:STRING=https://megapahit.net -DCPACK_RPM_PACKAGE_DESCRIPTION:STRING="An entrance to virtual empires in only megabytes. A shelter for the metaverse refugees, especially those from less supported operating systems." -DCPACK_RPM_PACKAGE_REQUIRES:STRING="apr-util, boost-fiber, boost-program-options, boost-regex, boost-thread, collada-dom, expat, fltk, mesa-libGLU, hunspell, jsoncpp, libnghttp2, SDL2, uriparser, vlc-libs, vlc-plugins-base, libvorbis, xmlrpc-epi" ../../indra
$ cmake ../../indra
$ make -j`nproc`
$ cpack -G RPM
$ sudo rpm -i megapahit-`cat newview/viewer_version.txt`-Linux.rpm
$ megapahit
```

### FreeBSD

```
$ mkdir -p build/`uname -m`-unknown-freebsd14.1/packages
$ cd ~/Downloads
$ curl -OL https://github.com/secondlife/3p-emoji-shortcodes/releases/download/v6.1.0.5413f58/emoji_shortcodes-6.1.0.5413f58-linux64-5413f58.tar.zst -OL https://github.com/secondlife/3p-glh_linear/releases/download/v1.0.1-dev4-984c397/glh_linear-1.0.1-dev4-common-984c397.tar.zst -OL https://github.com/secondlife/llca/releases/download/v202402012004.0-0f5d9c3/llca-202402012004.0-common-0f5d9c3.tar.zst -OL https://github.com/secondlife/3p-mikktspace/releases/download/v2-e967e1b/mikktspace-1-linux64-8756084692.tar.zst -OL https://github.com/secondlife/3p-openssl/releases/download/v1.1.1q.de53f55/openssl-1.1.1q.de53f55-linux64-de53f55.tar.zst -OL https://github.com/secondlife/3p-tinyexr/releases/download/v1.0.8-ba4bc64/tinyexr-v1.0.8-common-9373975608.tar.zst -OL https://github.com/secondlife/3p-tinygltf/releases/download/v2.5.0-1ae57fd/tinygltf-v2.5.0-common-1ae57fd.tar.zst -OL https://github.com/secondlife/3p-viewer-fonts/releases/download/v1.0.0-r1/viewer_fonts-1.0.0.8512067490-common-8512067490.tar.zst
$ cd -
$ cd ..
$ git clone https://github.com/secondlife/3p-openssl
$ git clone https://github.com/secondlife/3p-curl
$ cd 3p-openssl/openssl
$ mkdir -p build/`uname -m`-unknown-freebsd14.1
$ cd -p build/`uname -m`-unknown-freebsd14.1
$ ../../config no-shared
$ make -j`nproc`
$ cd ../../../../viewer/indra/newview
$ tar xf ~/Downloads/viewer_fonts-1.0.0.8512067490-common-8512067490.tar.zst
$ cd ../../build/`uname -m`-unknown-freebsd14.1/packages
$ tar xf ~/Downloads/emoji_shortcodes-6.1.0.5413f58-linux64-5413f58.tar.zst
$ tar xf ~/Downloads/glh_linear-1.0.1-dev4-common-984c397.tar.zst
$ tar xf ~/Downloads/llca-202402012004.0-common-0f5d9c3.tar.zst
$ tar xf ~/Downloads/mikktspace-1-linux64-8756084692.tar.zst
$ tar xf ~/Downloads/openssl-1.1.1q.de53f55-linux64-de53f55.tar.zst
$ tar xf ~/Downloads/tinyexr-v1.0.8-common-9373975608.tar.zst
$ tar xf ~/Downloads/tinygltf-v2.5.0-common-1ae57fd.tar.zst
$ cp ../../../../3p-openssl/openssl/build/`uname -m`-unknown-freebsd14.1/lib*.a lib/release/
$ cd ..
$ setenv LL_BUILD "-O3 -std=c++17 -fPIC"
$ sudo su -
# portmaster devel/cmake devel/pkgconf audio/freealut devel/apr1 devel/collada-dom x11-toolkits/fltk textproc/hunspell misc/meshoptimizer graphics/nanosvg graphics/openjpeg devel/sdl20 net/uriparser multimedia/vlc audio/libvorbis net/xmlrpc-epi devel/xxhash
# exit
$ rm CMakeCache.txt
$ cmake -DCMAKE_BUILD_TYPE:STRING=Release -DADDRESS_SIZE:INTERNAL=64 -DUSESYSTEMLIBS:BOOL=ON -DUSE_OPENAL:BOOL=ON -DLL_TESTS:BOOL=OFF -DNDOF:BOOL=OFF -DVIEWER_CHANNEL:STRING=Megapahit -DVIEWER_BINARY_NAME:STRING=megapahit -DBUILD_SHARED_LIBS:BOOL=OFF -DINSTALL:BOOL=ON -DPACKAGE:BOOL=ON -DCPACK_PACKAGE_NAME:STRING=megapahit -DCPACK_BINARY_STGZ:BOOL=OFF -DCPACK_BINARY_TGZ:BOOL=OFF -DCPACK_BINARY_TZ:BOOL=OFF -DCPACK_BINARY_FREEBSD:BOOL=ON -DCPACK_FREEBSD_PACKAGE_COMMENT:STRING="A fork of the Second Life viewer" -DCPACK_FREEBSD_PACKAGE_DESCRIPTION:STRING="An entrance to virtual empires in only megabytes. A shelter for the metaverse refugees, especially those from less supported operating systems." -DCPACK_FREEBSD_PACKAGE_WWW:STRING=https://megapahit.net -DCPACK_FREEBSD_PACKAGE_LICENSE:STRING=LGPL21 -DCPACK_FREEBSD_PACKAGE_MAINTAINER:STRING=$USER@$HOST -DCPACK_FREEBSD_PACKAGE_ORIGIN:STRING=net/megapahit -DCPACK_FREEBSD_PACKAGE_DEPS:STRING="audio/freealut;devel/collada-dom;graphics/libGLU;textproc/hunspell;misc/meshoptimizer;www/libnghttp2;graphics/openjpeg;net/uriparser;multimedia/vlc;audio/libvorbis;net/xmlrpc-epi" ../../indra
$ cmake ../../indra
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
