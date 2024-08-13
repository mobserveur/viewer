# -*- cmake -*-
include(Prebuilt)

include_guard()
add_library( ll::openjpeg INTERFACE IMPORTED )

if (NOT USESYSTEMLIBS)
use_system_binary(openjpeg)
elseif (${LINUX_DISTRO} MATCHES fedora OR DARWIN OR CMAKE_SYSTEM_NAME MATCHES FreeBSD)
  include(FindPkgConfig)
  pkg_check_modules(Openjpeg REQUIRED libopenjp2)
  target_include_directories(ll::openjpeg SYSTEM INTERFACE ${Openjpeg_INCLUDE_DIRS})
  target_link_directories(ll::openjpeg INTERFACE ${Openjpeg_LIBRARY_DIRS})
  target_link_libraries(ll::openjpeg INTERFACE ${Openjpeg_LIBRARIES})
endif (NOT USESYSTEMLIBS)
if (USESYSTEMLIBS AND (${LINUX_DISTRO} MATCHES fedora OR DARWIN OR CMAKE_SYSTEM_NAME MATCHES FreeBSD))
  if (${PREBUILD_TRACKING_DIR}/sentinel_installed IS_NEWER_THAN ${PREBUILD_TRACKING_DIR}/openjpeg_installed OR NOT ${openjpeg_installed} EQUAL 0)
    file(DOWNLOAD
      https://github.com/uclouvain/openjpeg/archive/refs/tags/v2.5.2.tar.gz
      ${CMAKE_BINARY_DIR}/openjpeg-2.5.2.tar.gz
      )
    file(ARCHIVE_EXTRACT
      INPUT ${CMAKE_BINARY_DIR}/openjpeg-2.5.2.tar.gz
      DESTINATION ${CMAKE_BINARY_DIR}
      )
    file(MAKE_DIRECTORY ${LIBS_PREBUILT_DIR}/include/openjpeg-2.5)
    execute_process(
      COMMAND cmake
        -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
        .
      WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/openjpeg-2.5.2
      RESULT_VARIABLE openjpeg_installed
      )
    file(
      COPY
        ${CMAKE_BINARY_DIR}/openjpeg-2.5.2/src/lib/openjp2/cio.h
        ${CMAKE_BINARY_DIR}/openjpeg-2.5.2/src/lib/openjp2/event.h
        ${CMAKE_BINARY_DIR}/openjpeg-2.5.2/src/lib/openjp2/opj_config_private.h
      DESTINATION ${LIBS_PREBUILT_DIR}/include/openjpeg-2.5
      )
    file(WRITE ${PREBUILD_TRACKING_DIR}/openjpeg_installed "${openjpeg_installed}")
  endif (${PREBUILD_TRACKING_DIR}/sentinel_installed IS_NEWER_THAN ${PREBUILD_TRACKING_DIR}/openjpeg_installed OR NOT ${openjpeg_installed} EQUAL 0)
else (USESYSTEMLIBS AND (${LINUX_DISTRO} MATCHES fedora OR DARWIN OR CMAKE_SYSTEM_NAME MATCHES FreeBSD))
use_prebuilt_binary(openjpeg)
  file(RENAME
    ${LIBS_PREBUILT_DIR}/include/openjpeg
    ${LIBS_PREBUILT_DIR}/include/openjpeg-2.5
    )

target_link_libraries(ll::openjpeg INTERFACE openjp2 )
endif (USESYSTEMLIBS AND (${LINUX_DISTRO} MATCHES fedora OR DARWIN OR CMAKE_SYSTEM_NAME MATCHES FreeBSD))
target_include_directories( ll::openjpeg SYSTEM INTERFACE ${LIBS_PREBUILT_DIR}/include)
