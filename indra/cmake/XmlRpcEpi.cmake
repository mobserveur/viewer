# -*- cmake -*-
include(Prebuilt)

include_guard()
add_library( ll::xmlrpc-epi INTERFACE IMPORTED )

if (NOT USESYSTEMLIBS)
use_system_binary( xmlrpc-epi )

use_prebuilt_binary(xmlrpc-epi)
elseif (DARWIN AND (${PREBUILD_TRACKING_DIR}/sentinel_installed IS_NEWER_THAN ${PREBUILD_TRACKING_DIR}/xmlrpc-epi_installed OR NOT ${xmlrpc-epi_installed} EQUAL 0))
  file(DOWNLOAD
    https://sourceforge.net/projects/xmlrpc-epi/files/xmlrpc-epi-base/0.54.2/xmlrpc-epi-0.54.2.tar.bz2
    ${CMAKE_BINARY_DIR}/xmlrpc-epi-0.54.2.tar.bz2
    )
  file(ARCHIVE_EXTRACT
    INPUT ${CMAKE_BINARY_DIR}/xmlrpc-epi-0.54.2.tar.bz2
    DESTINATION ${CMAKE_BINARY_DIR}
    )
  file(
    COPY
      ${CMAKE_BINARY_DIR}/xmlrpc-epi-0.54.2/src/base64.h
      ${CMAKE_BINARY_DIR}/xmlrpc-epi-0.54.2/src/encodings.h
      ${CMAKE_BINARY_DIR}/xmlrpc-epi-0.54.2/src/queue.h
      ${CMAKE_BINARY_DIR}/xmlrpc-epi-0.54.2/src/simplestring.h
      ${CMAKE_BINARY_DIR}/xmlrpc-epi-0.54.2/src/xml_element.h
      ${CMAKE_BINARY_DIR}/xmlrpc-epi-0.54.2/src/xml_to_xmlrpc.h
      ${CMAKE_BINARY_DIR}/xmlrpc-epi-0.54.2/src/xmlrpc.h
      ${CMAKE_BINARY_DIR}/xmlrpc-epi-0.54.2/src/xmlrpc_introspection.h
    DESTINATION ${LIBS_PREBUILT_DIR}/include/xmlrpc-epi
    )
  file(REMOVE
    ${CMAKE_BINARY_DIR}/xmlrpc-epi-0.54.2/config.sub
    ${CMAKE_BINARY_DIR}/xmlrpc-epi-0.54.2/missing
    )
  execute_process(
    COMMAND autoreconf -is
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/xmlrpc-epi-0.54.2
    )
  set(ENV{CPPFLAGS} -I${CMAKE_BINARY_DIR}/xmlrpc-epi-0.54.2/src)
  set(ENV{CFLAGS} "-arch ${CMAKE_OSX_ARCHITECTURES} -mmacosx-version-min=10.15")
  if (CMAKE_OSX_ARCHITECTURES MATCHES arm64)
    execute_process(
      COMMAND sed -i '' -e "s/XMLRPC_VALUE find_named_value/__attribute__((always_inline)) XMLRPC_VALUE find_named_value/g"
        xmlrpc_introspection.c
      WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/xmlrpc-epi-0.54.2/src
      )
    execute_process(
      COMMAND sed -i '' -e "s/void describe_method/__attribute__((always_inline)) void describe_method/g"
        xmlrpc_introspection.c
      WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/xmlrpc-epi-0.54.2/src
      )
    execute_process(
      COMMAND ./configure --host=aarch64-apple-darwin
      WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/xmlrpc-epi-0.54.2
      )
  else (CMAKE_OSX_ARCHITECTURES MATCHES arm64)
    execute_process(
      COMMAND ./configure --host=${CMAKE_OSX_ARCHITECTURES}-apple-darwin
      WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/xmlrpc-epi-0.54.2
      )
  endif (CMAKE_OSX_ARCHITECTURES MATCHES arm64)
  execute_process(
    COMMAND make -j${MAKE_JOBS}
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/xmlrpc-epi-0.54.2
    RESULT_VARIABLE xmlrpc-epi_installed
    )
  unset(ENV{CPPFLAGS})
  unset(ENV{CFLAGS})
  file(
    COPY
      ${CMAKE_BINARY_DIR}/xmlrpc-epi-0.54.2/src/.libs/libxmlrpc-epi.dylib
      ${CMAKE_BINARY_DIR}/xmlrpc-epi-0.54.2/src/.libs/libxmlrpc-epi.0.dylib
    DESTINATION ${LIBS_PREBUILT_DIR}/lib/release
    FOLLOW_SYMLINK_CHAIN
    )
  file(WRITE ${PREBUILD_TRACKING_DIR}/xmlrpc-epi_installed "${xmlrpc-epi_installed}")
endif (NOT USESYSTEMLIBS)
target_link_libraries(ll::xmlrpc-epi INTERFACE xmlrpc-epi )
if (NOT USESYSTEMLIBS)
target_include_directories( ll::xmlrpc-epi SYSTEM INTERFACE ${LIBS_PREBUILT_DIR}/include)
elseif (DARWIN)
  target_include_directories( ll::xmlrpc-epi SYSTEM INTERFACE ${LIBS_PREBUILT_DIR}/include/xmlrpc-epi)
elseif (LINUX)
  target_include_directories( ll::xmlrpc-epi SYSTEM INTERFACE ${CMAKE_SYSROOT}/usr/include/xmlrpc-epi)
endif ()
