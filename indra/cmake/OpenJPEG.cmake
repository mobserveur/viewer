# -*- cmake -*-
include(Prebuilt)

include_guard()
add_library( ll::openjpeg INTERFACE IMPORTED )

if (NOT USESYSTEMLIBS)
use_system_binary(openjpeg)
endif (NOT USESYSTEMLIBS)
if (USESYSTEMLIBS AND NOT LINUX)
  if (${PREBUILD_TRACKING_DIR}/sentinel_installed IS_NEWER_THAN ${PREBUILD_TRACKING_DIR}/openjpeg_installed OR NOT ${openjpeg_installed} EQUAL 0)
  if (NOT EXISTS ${CMAKE_BINARY_DIR}/3p-openjpeg-2.5.0.ea12248.tar.gz)
    file(DOWNLOAD
      https://github.com/secondlife/3p-openjpeg/archive/refs/tags/v2.5.0.ea12248.tar.gz
      ${CMAKE_BINARY_DIR}/3p-openjpeg-2.5.0.ea12248.tar.gz
      )
  endif (NOT EXISTS ${CMAKE_BINARY_DIR}/3p-openjpeg-2.5.0.ea12248.tar.gz)
  file(ARCHIVE_EXTRACT
    INPUT ${CMAKE_BINARY_DIR}/3p-openjpeg-2.5.0.ea12248.tar.gz
    DESTINATION ${CMAKE_BINARY_DIR}
    )
  if (DARWIN)
    try_compile(OPENJPEG_RESULT
      PROJECT OPENJPEG
      SOURCE_DIR ${CMAKE_BINARY_DIR}/3p-openjpeg-2.5.0.ea12248/openjpeg
      BINARY_DIR ${CMAKE_BINARY_DIR}/3p-openjpeg-2.5.0.ea12248/openjpeg
      TARGET openjp2
      CMAKE_FLAGS
        -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
        -DBUILD_SHARED_LIBS:BOOL=OFF
        -DCMAKE_OSX_ARCHITECTURES:STRING=${CMAKE_OSX_ARCHITECTURES}
        -DCMAKE_OSX_DEPLOYMENT_TARGET:STRING=10.15
      OUTPUT_VARIABLE openjpeg_installed
      )
  else (DARWIN)
    try_compile(OPENJPEG_RESULT
      PROJECT OPENJPEG
      SOURCE_DIR ${CMAKE_BINARY_DIR}/3p-openjpeg-2.5.0.ea12248/openjpeg
      BINARY_DIR ${CMAKE_BINARY_DIR}/3p-openjpeg-2.5.0.ea12248/openjpeg
      TARGET openjp2
      CMAKE_FLAGS
        -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
        -DBUILD_SHARED_LIBS:BOOL=OFF
        -DCMAKE_BUILD_WITH_INSTALL_RPATH:BOOL=ON
      OUTPUT_VARIABLE openjpeg_installed
      )
  endif (DARWIN)
  if (${OPENJPEG_RESULT})
    file(
      COPY
        ${CMAKE_BINARY_DIR}/3p-openjpeg-2.5.0.ea12248/openjpeg/src/lib/openjp2/cio.h
        ${CMAKE_BINARY_DIR}/3p-openjpeg-2.5.0.ea12248/openjpeg/src/lib/openjp2/event.h
        ${CMAKE_BINARY_DIR}/3p-openjpeg-2.5.0.ea12248/openjpeg/src/lib/openjp2/openjpeg.h
        ${CMAKE_BINARY_DIR}/3p-openjpeg-2.5.0.ea12248/openjpeg/src/lib/openjp2/opj_config.h
        ${CMAKE_BINARY_DIR}/3p-openjpeg-2.5.0.ea12248/openjpeg/src/lib/openjp2/opj_config_private.h
        ${CMAKE_BINARY_DIR}/3p-openjpeg-2.5.0.ea12248/openjpeg/src/lib/openjp2/opj_stdint.h
      DESTINATION ${LIBS_PREBUILT_DIR}/include/openjpeg
      )
    file(
      COPY ${CMAKE_BINARY_DIR}/3p-openjpeg-2.5.0.ea12248/openjpeg/bin/libopenjp2.a
      DESTINATION ${LIBS_PREBUILT_DIR}/lib/release
      )
    file(WRITE ${PREBUILD_TRACKING_DIR}/openjpeg_installed "${openjpeg_installed}")
  endif (${OPENJPEG_RESULT})
  endif (${PREBUILD_TRACKING_DIR}/sentinel_installed IS_NEWER_THAN ${PREBUILD_TRACKING_DIR}/openjpeg_installed OR NOT ${openjpeg_installed} EQUAL 0)
else (USESYSTEMLIBS AND NOT LINUX)
use_prebuilt_binary(openjpeg)
endif (USESYSTEMLIBS AND NOT LINUX)

target_link_libraries(ll::openjpeg INTERFACE openjp2 )
target_include_directories( ll::openjpeg SYSTEM INTERFACE ${LIBS_PREBUILT_DIR}/include)
