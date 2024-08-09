# -*- cmake -*-
include(Linking)
include(Prebuilt)

include_guard()
add_library( ll::cef INTERFACE IMPORTED )

if (CMAKE_OSX_ARCHITECTURES MATCHES arm64 AND (${PREBUILD_TRACKING_DIR}/sentinel_installed IS_NEWER_THAN ${PREBUILD_TRACKING_DIR}/dullahan_installed OR NOT ${dullahan_installed} EQUAL 0))
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
else ()
use_prebuilt_binary(dullahan)
endif ()

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
