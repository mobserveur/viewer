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
    execute_process(
      COMMAND mkdir -p ${AUTOBUILD_INSTALL_DIR}/include/openjpeg-2.5
      COMMAND curl
        -L https://github.com/uclouvain/openjpeg/archive/refs/tags/v2.5.2.tar.gz
        -o openjpeg-2.5.2.tar.gz
      WORKING_DIRECTORY $ENV{HOME}/Downloads
      )
    execute_process(
      COMMAND tar xf $ENV{HOME}/Downloads/openjpeg-2.5.2.tar.gz
      WORKING_DIRECTORY /tmp
      )
    execute_process(
      COMMAND cmake
        -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
        .
      WORKING_DIRECTORY /tmp/openjpeg-2.5.2
      )
    execute_process(
      COMMAND cp
        /tmp/openjpeg-2.5.2/src/lib/openjp2/cio.h
        /tmp/openjpeg-2.5.2/src/lib/openjp2/event.h
        /tmp/openjpeg-2.5.2/src/lib/openjp2/opj_config_private.h
        ${AUTOBUILD_INSTALL_DIR}/include/openjpeg-2.5/
      WORKING_DIRECTORY ${AUTOBUILD_INSTALL_DIR}
      )
    execute_process(
      COMMAND rm -rf openjpeg-2.5.2
      WORKING_DIRECTORY /tmp
      RESULT_VARIABLE openjpeg_installed
      )
    file(WRITE ${PREBUILD_TRACKING_DIR}/openjpeg_installed "${openjpeg_installed}")
  endif (${PREBUILD_TRACKING_DIR}/sentinel_installed IS_NEWER_THAN ${PREBUILD_TRACKING_DIR}/openjpeg_installed OR NOT ${openjpeg_installed} EQUAL 0)
else (USESYSTEMLIBS AND (${LINUX_DISTRO} MATCHES fedora OR DARWIN OR CMAKE_SYSTEM_NAME MATCHES FreeBSD))
use_prebuilt_binary(openjpeg)
  execute_process(COMMAND mv
    openjpeg
    openjpeg-2.5
    WORKING_DIRECTORY ${AUTOBUILD_INSTALL_DIR}/include
    )

target_link_libraries(ll::openjpeg INTERFACE openjp2 )
endif (USESYSTEMLIBS AND (${LINUX_DISTRO} MATCHES fedora OR DARWIN OR CMAKE_SYSTEM_NAME MATCHES FreeBSD))
target_include_directories( ll::openjpeg SYSTEM INTERFACE ${LIBS_PREBUILT_DIR}/include)
