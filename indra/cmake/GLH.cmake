# -*- cmake -*-
include(Prebuilt)

add_library( ll::glh_linear INTERFACE IMPORTED )
target_include_directories( ll::glh_linear SYSTEM INTERFACE ${LIBS_PREBUILT_DIR}/include)

if (NOT USESYSTEMLIBS)
use_system_binary( glh_linear )
endif (NOT USESYSTEMLIBS)
use_prebuilt_binary(glh_linear)
