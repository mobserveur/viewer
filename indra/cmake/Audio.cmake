# -*- cmake -*-
include(Prebuilt)

include_guard()
add_library( ll::vorbis INTERFACE IMPORTED )

if (NOT (USE_AUTOBUILD_3P OR USE_CONAN))
  include(FindPkgConfig)
  pkg_check_modules(Vorbis REQUIRED ogg vorbis vorbisenc vorbisfile)
  target_include_directories(ll::vorbis SYSTEM INTERFACE ${Vorbis_INCLUDE_DIRS})
  target_link_directories(ll::vorbis INTERFACE ${Vorbis_LIBRARY_DIRS})
  target_link_libraries(ll::vorbis INTERFACE ${Vorbis_LIBRARIES})
  return ()
endif ()

use_system_binary(vorbis)
use_prebuilt_binary(ogg_vorbis)
target_include_directories( ll::vorbis SYSTEM INTERFACE ${LIBS_PREBUILT_DIR}/include )

if (WINDOWS)
  target_link_libraries(ll::vorbis INTERFACE ogg_static vorbis_static vorbisenc_static vorbisfile_static )
else (WINDOWS)
  target_link_libraries(ll::vorbis INTERFACE ogg vorbis vorbisenc vorbisfile )
endif (WINDOWS)

