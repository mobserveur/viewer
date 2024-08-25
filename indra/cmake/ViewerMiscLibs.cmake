# -*- cmake -*-
include(Prebuilt)

if (NOT DARWIN)
  add_library( ll::fontconfig INTERFACE IMPORTED )

  find_package(Fontconfig REQUIRED)
  target_link_libraries( ll::fontconfig INTERFACE  Fontconfig::Fontconfig )
endif (NOT DARWIN)

if( USE_AUTOBUILD_3P )
  use_prebuilt_binary(libhunspell)
endif()

if (NOT USESYSTEMLIBS)
use_prebuilt_binary(slvoice)
endif (NOT USESYSTEMLIBS)

if ((${LINUX_DISTRO} MATCHES debian OR DARWIN) OR NOT USESYSTEMLIBS)
use_prebuilt_binary(nanosvg)
endif ((${LINUX_DISTRO} MATCHES debian OR DARWIN) OR NOT USESYSTEMLIBS)
use_prebuilt_binary(viewer-fonts)
use_prebuilt_binary(emoji_shortcodes)
