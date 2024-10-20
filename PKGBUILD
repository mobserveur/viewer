# Maintainer: Erik Kundiman <erik@megapahit.net>
pkgname=megapahit
pkgver=7.1.10
pkgrel=52697
pkgdesc="A fork of the Second Life viewer"
arch=('x86_64')
url="https://megapahit.net"
license=('LGPL-2.1')
depends=(freealut apr-util boost-libs fltk glu hunspell libnghttp2 sdl2 uriparser vlc libvorbis)

package() {
	cd "$startdir/build-linux-x86_64"
	make DESTDIR="$pkgdir/" install
}
