# -*- cmake -*-
include(Prebuilt)

include_guard()
add_library( ll::openjpeg INTERFACE IMPORTED )

if (NOT USESYSTEMLIBS)
use_system_binary(openjpeg)
use_prebuilt_binary(openjpeg)
elseif (NOT LINUX)
  include(FindPkgConfig)
  pkg_check_modules(Openjpeg REQUIRED libopenjp2)
  target_include_directories(ll::openjpeg SYSTEM INTERFACE ${Openjpeg_INCLUDE_DIRS})
  target_link_directories(ll::openjpeg INTERFACE ${Openjpeg_LIBRARY_DIRS})
  target_link_libraries(ll::openjpeg INTERFACE ${Openjpeg_LIBRARIES})
  return ()
endif (NOT USESYSTEMLIBS)

target_link_libraries(ll::openjpeg INTERFACE openjp2 )
target_include_directories( ll::openjpeg SYSTEM INTERFACE ${LIBS_PREBUILT_DIR}/include)
