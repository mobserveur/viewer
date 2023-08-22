# -*- cmake -*-
include(Prebuilt)

include_guard()
add_library( ll::xmlrpc-epi INTERFACE IMPORTED )

if (USE_AUTOBUILD_3P OR USE_CONAN)
use_system_binary( xmlrpc-epi )

use_prebuilt_binary(xmlrpc-epi)
endif ()

target_link_libraries(ll::xmlrpc-epi INTERFACE xmlrpc-epi )

if (USE_AUTOBUILD_3P OR USE_CONAN)
target_include_directories( ll::xmlrpc-epi SYSTEM INTERFACE ${LIBS_PREBUILT_DIR}/include)
elseif (LINUX)
	target_include_directories( ll::xmlrpc-epi SYSTEM INTERFACE
		${CMAKE_SYSROOT}/usr/include/xmlrpc-epi)
elseif (DARWIN)
	target_include_directories( ll::xmlrpc-epi SYSTEM INTERFACE /usr/local/include)
	target_link_directories( ll::xmlrpc-epi INTERFACE /usr/local/lib)
endif ()
