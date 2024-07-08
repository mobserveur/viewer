# -*- cmake -*-
include(Prebuilt)

add_library( ll::glh_linear INTERFACE IMPORTED )

if (USESYSTEMLIBS)
  target_include_directories( ll::glh_linear SYSTEM INTERFACE ${LIBS_PREBUILT_DIR}/include)
  return ()
endif ()

use_system_binary( glh_linear )
use_prebuilt_binary(glh_linear)
