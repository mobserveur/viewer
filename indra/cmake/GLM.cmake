# -*- cmake -*-
include(Prebuilt)

add_library( ll::glm INTERFACE IMPORTED )

if (USESYSTEMLIBS)
  find_package( glm REQUIRED )
else ()
use_system_binary( glm )
use_prebuilt_binary(glm)
endif ()
