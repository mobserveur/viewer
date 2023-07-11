# -*- cmake -*-

include(Linking)
include(Prebuilt)

include_guard()
add_library( ll::meshoptimizer INTERFACE IMPORTED )

if (NOT (USE_AUTOBUILD_3P OR USE_CONAN))
  target_include_directories( ll::meshoptimizer SYSTEM INTERFACE /usr/local/include )
  target_link_libraries( ll::meshoptimizer INTERFACE meshoptimizer)
  return ()
endif ()

use_system_binary(meshoptimizer)
use_prebuilt_binary(meshoptimizer)

if (WINDOWS)
  target_link_libraries( ll::meshoptimizer INTERFACE meshoptimizer.lib)
elseif (LINUX)
  target_link_libraries( ll::meshoptimizer INTERFACE meshoptimizer.o)
elseif (DARWIN)
  target_link_libraries( ll::meshoptimizer INTERFACE libmeshoptimizer.a)
endif (WINDOWS)

target_include_directories( ll::meshoptimizer SYSTEM INTERFACE ${LIBS_PREBUILT_DIR}/include/meshoptimizer)
