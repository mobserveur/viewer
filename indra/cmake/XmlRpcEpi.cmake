# -*- cmake -*-
include(Prebuilt)

include_guard()
add_library( ll::xmlrpc-epi INTERFACE IMPORTED )

if (NOT USESYSTEMLIBS)
use_system_binary( xmlrpc-epi )
endif (NOT USESYSTEMLIBS)

if (${LINUX_DISTRO} MATCHES opensuse-tumbleweed OR DARWIN OR NOT USESYSTEMLIBS)
use_prebuilt_binary(xmlrpc-epi)
  if (DARWIN)
    execute_process(
      COMMAND lipo -archs libxmlrpc-epi.0.dylib
      WORKING_DIRECTORY ${LIBS_PREBUILT_DIR}/lib/release
      OUTPUT_VARIABLE xmlrpc-epi_archs
      OUTPUT_STRIP_TRAILING_WHITESPACE
      )
    if (NOT ${xmlrpc-epi_archs} EQUAL ${CMAKE_OSX_ARCHITECTURES})
      execute_process(
        COMMAND lipo
          libxmlrpc-epi.0.dylib
          -thin ${CMAKE_OSX_ARCHITECTURES}
          -output libxmlrpc-epi.0.dylib
        WORKING_DIRECTORY ${LIBS_PREBUILT_DIR}/lib/release
        )
    endif (NOT ${xmlrpc-epi_archs} EQUAL ${CMAKE_OSX_ARCHITECTURES})
  endif (DARWIN)
endif (${LINUX_DISTRO} MATCHES opensuse-tumbleweed OR DARWIN OR NOT USESYSTEMLIBS)
target_link_libraries(ll::xmlrpc-epi INTERFACE xmlrpc-epi )
if (NOT USESYSTEMLIBS)
target_include_directories( ll::xmlrpc-epi SYSTEM INTERFACE ${LIBS_PREBUILT_DIR}/include)
elseif (${LINUX_DISTRO} MATCHES opensuse-tumbleweed OR DARWIN)
  target_include_directories( ll::xmlrpc-epi SYSTEM INTERFACE ${LIBS_PREBUILT_DIR}/include/xmlrpc-epi)
elseif (LINUX)
  target_include_directories( ll::xmlrpc-epi SYSTEM INTERFACE ${CMAKE_SYSROOT}/usr/include/xmlrpc-epi)
endif ()
