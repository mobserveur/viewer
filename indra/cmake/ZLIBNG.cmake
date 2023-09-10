# -*- cmake -*-

include(Prebuilt)

include_guard()
add_library( ll::zlib-ng INTERFACE IMPORTED )

if(USE_CONAN )
  target_link_libraries( ll::zlib-ng INTERFACE CONAN_PKG::zlib )
  return()
elseif(NOT USE_AUTOBUILD_3P)
  pkg_check_modules(Zlib REQUIRED zlib)
  target_include_directories( ll::zlib-ng SYSTEM INTERFACE ${Zlib_INCLUDE_DIRS})
  target_link_directories( ll::zlib-ng INTERFACE ${Zlib_LIBRARY_DIRS} )
  target_link_libraries( ll::zlib-ng INTERFACE ${Zlib_LIBRARIES})
  return()
endif()

use_prebuilt_binary(zlib-ng)
if (WINDOWS)
  target_link_libraries( ll::zlib-ng INTERFACE zlib )
else()
  target_link_libraries( ll::zlib-ng INTERFACE z )
endif (WINDOWS)

if( NOT LINUX )
  target_include_directories( ll::zlib-ng SYSTEM INTERFACE ${LIBS_PREBUILT_DIR}/include/zlib-ng)
endif()
