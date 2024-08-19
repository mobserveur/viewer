# -*- cmake -*-
include(Prebuilt)

add_library( ll::glm INTERFACE IMPORTED )

if (NOT USESYSTEMLIBS)
use_system_binary( glm )
elseif (NOT LINUX)
  find_package( glm REQUIRED )
endif (NOT USESYSTEMLIBS)

if (LINUX OR USESYSTEMLIBS)
use_prebuilt_binary(glm)
endif (LINUX OR USESYSTEMLIBS)
