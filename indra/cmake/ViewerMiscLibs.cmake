# -*- cmake -*-
include(Prebuilt)

if (NOT (USE_AUTOBUILD_3P OR USE_CONAN))
  add_library( ll::fontconfig INTERFACE IMPORTED )
  use_system_binary(fontconfig)
  return ()
endif ()

if (LINUX)
  #use_prebuilt_binary(libuuid)
  add_library( ll::fontconfig INTERFACE IMPORTED )

  if( NOT USE_CONAN )
    use_prebuilt_binary(fontconfig)
  else()
    target_link_libraries( ll::fontconfig INTERFACE CONAN_PKG::fontconfig )
  endif()
endif (LINUX)

if( NOT USE_CONAN )
  use_prebuilt_binary(libhunspell)
endif()

use_prebuilt_binary(slvoice)

