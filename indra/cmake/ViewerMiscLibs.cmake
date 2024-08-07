# -*- cmake -*-
include(Prebuilt)

if (NOT (USE_AUTOBUILD_3P OR USE_CONAN))
  add_library( ll::fontconfig INTERFACE IMPORTED )
  use_system_binary(fontconfig)
endif ()

if (LINUX)
  add_library( ll::fontconfig INTERFACE IMPORTED )

  find_package(Fontconfig REQUIRED)
  target_link_libraries( ll::fontconfig INTERFACE  Fontconfig::Fontconfig )
endif (LINUX)

if( NOT USE_CONAN )
  use_prebuilt_binary(libhunspell)
endif()

use_prebuilt_binary(slvoice)

use_prebuilt_binary(nanosvg)
use_prebuilt_binary(viewer-fonts)
use_prebuilt_binary(emoji_shortcodes)
