# -*- cmake -*-
include(Linking)
include(Prebuilt)

include_guard()
add_library( ll::cef INTERFACE IMPORTED )

if (CMAKE_OSX_ARCHITECTURES MATCHES arm64)
    if (${PREBUILD_TRACKING_DIR}/sentinel_installed IS_NEWER_THAN ${PREBUILD_TRACKING_DIR}/dullahan_installed OR NOT ${dullahan_installed} EQUAL 0)
        execute_process(COMMAND curl
            -O
            https://megapahit.net/downloads/dullahan-1.14.0.202312131437_118.7.1_g99817d2_chromium-118.0.5993.119-darwin64-242070244.tar.bz2
            WORKING_DIRECTORY $ENV{HOME}/Downloads
            )
        execute_process(COMMAND tar
            xf
            $ENV{HOME}/Downloads/dullahan-1.14.0.202312131437_118.7.1_g99817d2_chromium-118.0.5993.119-darwin64-242070244.tar.bz2
            WORKING_DIRECTORY ${AUTOBUILD_INSTALL_DIR}
            RESULT_VARIABLE dullahan_installed
            )
        file(WRITE ${PREBUILD_TRACKING_DIR}/dullahan_installed "${dullahan_installed}")
    endif (${PREBUILD_TRACKING_DIR}/sentinel_installed IS_NEWER_THAN ${PREBUILD_TRACKING_DIR}/dullahan_installed OR NOT ${dullahan_installed} EQUAL 0)
elseif (CMAKE_OSX_ARCHITECTURES MATCHES x86_64)
    if (${PREBUILD_TRACKING_DIR}/sentinel_installed IS_NEWER_THAN ${PREBUILD_TRACKING_DIR}/dullahan_installed OR NOT ${dullahan_installed} EQUAL 0)
        execute_process(COMMAND curl
            -O
            https://megapahit.net/downloads/dullahan-1.14.0.202312131437_118.7.1_g99817d2_chromium-118.0.5993.119-darwin64-242070158.tar.bz2
            WORKING_DIRECTORY $ENV{HOME}/Downloads
            )
        execute_process(COMMAND tar
            xf
            $ENV{HOME}/Downloads/dullahan-1.14.0.202312131437_118.7.1_g99817d2_chromium-118.0.5993.119-darwin64-242070158.tar.bz2
            WORKING_DIRECTORY ${AUTOBUILD_INSTALL_DIR}
            RESULT_VARIABLE dullahan_installed
            )
        file(WRITE ${PREBUILD_TRACKING_DIR}/dullahan_installed "${dullahan_installed}")
    endif (${PREBUILD_TRACKING_DIR}/sentinel_installed IS_NEWER_THAN ${PREBUILD_TRACKING_DIR}/dullahan_installed OR NOT ${dullahan_installed} EQUAL 0)
else (CMAKE_OSX_ARCHITECTURES MATCHES arm64)
use_prebuilt_binary(dullahan)
  if (LINUX)
    if (${LINUX_DISTRO} MATCHES fedora)
      execute_process(
        COMMAND patchelf --remove-rpath bin/release/dullahan_host
        WORKING_DIRECTORY ${AUTOBUILD_INSTALL_DIR}
        )
    endif (${LINUX_DISTRO} MATCHES fedora)
  endif (LINUX)
endif (CMAKE_OSX_ARCHITECTURES MATCHES arm64)

target_include_directories( ll::cef SYSTEM INTERFACE  ${LIBS_PREBUILT_DIR}/include/cef)

if (WINDOWS)
    target_link_libraries( ll::cef INTERFACE
        libcef.lib
        libcef_dll_wrapper.lib
        dullahan.lib
    )
elseif (DARWIN)
    FIND_LIBRARY(APPKIT_LIBRARY AppKit)
    if (NOT APPKIT_LIBRARY)
        message(FATAL_ERROR "AppKit not found")
    endif()

    set(CEF_LIBRARY "'${ARCH_PREBUILT_DIRS_RELEASE}/Chromium\ Embedded\ Framework.framework'")
    if (NOT CEF_LIBRARY)
        message(FATAL_ERROR "CEF not found")
    endif()

    target_link_libraries( ll::cef INTERFACE
        ${ARCH_PREBUILT_DIRS_RELEASE}/libcef_dll_wrapper.a
        ${ARCH_PREBUILT_DIRS_RELEASE}/libdullahan.a
        ${APPKIT_LIBRARY}
        "-F ${CEF_LIBRARY}"
       )

elseif (LINUX)
    target_link_libraries( ll::cef INTERFACE
            libdullahan.a
            cef
            cef_dll_wrapper.a
    )
endif (WINDOWS)
