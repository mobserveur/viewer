# -*- cmake -*-
include(Prebuilt)

add_library( ll::glh_linear INTERFACE IMPORTED )

if (NOT (USE_AUTOBUILD_3P OR USE_CONAN))
  target_include_directories( ll::glh_linear SYSTEM INTERFACE /usr/local/include )
  return ()
endif ()

use_system_binary( glh_linear )
use_prebuilt_binary(glh_linear)
