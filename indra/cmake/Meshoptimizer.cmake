# -*- cmake -*-

include(Linking)
include(Prebuilt)

include_guard()
add_library( ll::meshoptimizer INTERFACE IMPORTED )

if (NOT USESYSTEMLIBS)
use_system_binary(meshoptimizer)
else (NOT USESYSTEMLIBS)
  if (NOT (${LINUX_DISTRO} MATCHES fedora OR DARWIN))
    find_package(meshoptimizer)
    target_link_libraries( ll::meshoptimizer INTERFACE meshoptimizer)
  endif (NOT (${LINUX_DISTRO} MATCHES fedora OR DARWIN))
endif (NOT USESYSTEMLIBS)

if (${LINUX_DISTRO} MATCHES fedora OR DARWIN OR NOT USESYSTEMLIBS)
  if (USESYSTEMLIBS)
    if (${PREBUILD_TRACKING_DIR}/sentinel_installed IS_NEWER_THAN ${PREBUILD_TRACKING_DIR}/meshoptimizer_installed OR NOT ${meshoptimizer_installed} EQUAL 0)
      if (NOT EXISTS ${CMAKE_BINARY_DIR}/meshoptimizer-0.21.tar.gz)
        file(DOWNLOAD
          https://github.com/zeux/meshoptimizer/archive/refs/tags/v0.21.tar.gz
          ${CMAKE_BINARY_DIR}/meshoptimizer-0.21.tar.gz
          )
      endif (NOT EXISTS ${CMAKE_BINARY_DIR}/meshoptimizer-0.21.tar.gz)
      file(ARCHIVE_EXTRACT
        INPUT ${CMAKE_BINARY_DIR}/meshoptimizer-0.21.tar.gz
        DESTINATION ${CMAKE_BINARY_DIR}
        )
      if (DARWIN)
        try_compile(MESHOPTIMIZER_RESULT
          PROJECT meshoptimizer
          SOURCE_DIR ${CMAKE_BINARY_DIR}/meshoptimizer-0.21
          BINARY_DIR ${CMAKE_BINARY_DIR}/meshoptimizer-0.21
          TARGET meshoptimizer
          CMAKE_FLAGS
            -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
            -DCMAKE_OSX_ARCHITECTURES:STRING=${CMAKE_OSX_ARCHITECTURES}
            -DCMAKE_OSX_DEPLOYMENT_TARGET:STRING=10.15
          OUTPUT_VARIABLE meshoptimizer_installed
          )
      else (DARWIN)
        try_compile(MESHOPTIMIZER_RESULT
          PROJECT meshoptimizer
          SOURCE_DIR ${CMAKE_BINARY_DIR}/meshoptimizer-0.21
          BINARY_DIR ${CMAKE_BINARY_DIR}/meshoptimizer-0.21
          TARGET meshoptimizer
          CMAKE_FLAGS
            -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
          OUTPUT_VARIABLE meshoptimizer_installed
          )
      endif (DARWIN)
      if (${MESHOPTIMIZER_RESULT})
        file(
          COPY ${CMAKE_BINARY_DIR}/meshoptimizer-0.21/src/meshoptimizer.h
          DESTINATION ${LIBS_PREBUILT_DIR}/include/meshoptimizer
          )
        file(
          COPY ${CMAKE_BINARY_DIR}/meshoptimizer-0.21/libmeshoptimizer.a
          DESTINATION ${LIBS_PREBUILT_DIR}/lib/release
          )
        file(WRITE ${PREBUILD_TRACKING_DIR}/meshoptimizer_installed "0")
      endif (${MESHOPTIMIZER_RESULT})
    endif (${PREBUILD_TRACKING_DIR}/sentinel_installed IS_NEWER_THAN ${PREBUILD_TRACKING_DIR}/meshoptimizer_installed OR NOT ${meshoptimizer_installed} EQUAL 0)
  else (USESYSTEMLIBS)
use_prebuilt_binary(meshoptimizer)
  endif (USESYSTEMLIBS)

if (WINDOWS)
  target_link_libraries( ll::meshoptimizer INTERFACE meshoptimizer.lib)
elseif (LINUX)
  target_link_libraries( ll::meshoptimizer INTERFACE libmeshoptimizer.a)
elseif (DARWIN)
  target_link_libraries( ll::meshoptimizer INTERFACE libmeshoptimizer.a)
endif (WINDOWS)

target_include_directories( ll::meshoptimizer SYSTEM INTERFACE ${LIBS_PREBUILT_DIR}/include/meshoptimizer)
endif (${LINUX_DISTRO} MATCHES fedora OR DARWIN OR NOT USESYSTEMLIBS)
