# -*- cmake -*-
include(Prebuilt)
include(GLH)

add_library( ll::glext INTERFACE IMPORTED )

if (NOT (USE_AUTOBUILD_3P OR USE_CONAN))
  return ()
endif ()

if (WINDOWS OR LINUX)
  use_system_binary(glext)
  use_prebuilt_binary(glext)
endif (WINDOWS OR LINUX)


