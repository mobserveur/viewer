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
      execute_process(
        COMMAND mkdir -p ${AUTOBUILD_INSTALL_DIR}/include/meshoptimizer
        COMMAND curl
          -L https://github.com/zeux/meshoptimizer/archive/refs/tags/v0.21.tar.gz
          -o meshoptimizer-0.21.tar.gz
        WORKING_DIRECTORY $ENV{HOME}/Downloads
        )
      execute_process(
        COMMAND tar xf $ENV{HOME}/Downloads/meshoptimizer-0.21.tar.gz
        WORKING_DIRECTORY /tmp
        )
      execute_process(
        COMMAND cmake
          -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
          .
        WORKING_DIRECTORY /tmp/meshoptimizer-0.21
        )
      if (DARWIN)
        execute_process(
          COMMAND cmake
            -DCMAKE_OSX_ARCHITECTURES:STRING=${CMAKE_OSX_ARCHITECTURES}
            -DCMAKE_OSX_DEPLOYMENT_TARGET:STRING=10.15
            .
          WORKING_DIRECTORY /tmp/meshoptimizer-0.21
          )
      endif (DARWIN)
      execute_process(
        COMMAND make -j${MAKE_JOBS}
        WORKING_DIRECTORY /tmp/meshoptimizer-0.21
        )
      execute_process(
        COMMAND cp /tmp/meshoptimizer-0.21/src/meshoptimizer.h ${AUTOBUILD_INSTALL_DIR}/include/meshoptimizer/
        COMMAND cp /tmp/meshoptimizer-0.21/libmeshoptimizer.a ${AUTOBUILD_INSTALL_DIR}/lib/release/
        WORKING_DIRECTORY ${AUTOBUILD_INSTALL_DIR}
        RESULT_VARIABLE meshoptimizer_installed
        )
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
