# -*- cmake -*-
include(Prebuilt)

include_guard()
add_library( ll::freetype INTERFACE IMPORTED )

if (NOT (USE_AUTOBUILD_3P OR USE_CONAN))
  include(FindPkgConfig)
  pkg_check_modules(Freetype REQUIRED freetype2)
  target_include_directories( ll::freetype SYSTEM INTERFACE ${Freetype_INCLUDE_DIRS} )
  target_link_directories( ll::freetype INTERFACE ${Freetype_LIBRARY_DIRS} )
  target_link_libraries( ll::freetype INTERFACE ${Freetype_LIBRARIES} )
  return ()
endif ()

use_system_binary(freetype)
use_prebuilt_binary(freetype)
target_include_directories( ll::freetype SYSTEM INTERFACE  ${LIBS_PREBUILT_DIR}/include/freetype2/)
target_link_libraries( ll::freetype INTERFACE freetype )

