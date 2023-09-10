# -*- cmake -*-
include(Prebuilt)

add_library( ll::glh_linear INTERFACE IMPORTED )

if (USESYSTEMLIBS)
	target_include_directories(ll::glh_linear SYSTEM INTERFACE
		${CMAKE_SYSROOT}/usr/local/include)
	return ()
endif ()

use_system_binary( glh_linear )
use_prebuilt_binary(glh_linear)
