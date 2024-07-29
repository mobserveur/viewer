# -*- cmake -*-
include(Prebuilt)

add_library( ll::glm INTERFACE IMPORTED )

if (USESYSTEMLIBS)
  if (NOT LINUX)
    find_package( glm REQUIRED )
  endif ()
  return ()
else ()
use_system_binary( glm )
use_prebuilt_binary(glm)
endif ()
