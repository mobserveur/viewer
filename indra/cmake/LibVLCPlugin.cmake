# -*- cmake -*-
include(Linking)
include(Prebuilt)

include_guard()
add_library( ll::libvlc INTERFACE IMPORTED )

if (USESYSTEMLIBS)
    if (DARWIN)
        if (CMAKE_OSX_ARCHITECTURES MATCHES arm64)
            if (${PREBUILD_TRACKING_DIR}/sentinel_installed IS_NEWER_THAN ${PREBUILD_TRACKING_DIR}/vlc_installed OR NOT ${vlc_installed} EQUAL 0)
                if (NOT EXISTS ${CMAKE_BINARY_DIR}/vlc-3.0.21-arm64.dmg)
                    file(DOWNLOAD
                        https://get.videolan.org/vlc/3.0.21/macosx/vlc-3.0.21-arm64.dmg
                        ${CMAKE_BINARY_DIR}/vlc-3.0.21-arm64.dmg
                        )
                endif (NOT EXISTS ${CMAKE_BINARY_DIR}/vlc-3.0.21-arm64.dmg)
                file(WRITE ${PREBUILD_TRACKING_DIR}/vlc_installed "0")
            endif (${PREBUILD_TRACKING_DIR}/sentinel_installed IS_NEWER_THAN ${PREBUILD_TRACKING_DIR}/vlc_installed OR NOT ${vlc_installed} EQUAL 0)
            execute_process(
                COMMAND hdiutil attach -noverify vlc-3.0.21-arm64.dmg
                WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
                )
        else (CMAKE_OSX_ARCHITECTURES MATCHES arm64)
            if (${PREBUILD_TRACKING_DIR}/sentinel_installed IS_NEWER_THAN ${PREBUILD_TRACKING_DIR}/vlc_installed OR NOT ${vlc_installed} EQUAL 0)
                if (NOT EXISTS ${CMAKE_BINARY_DIR}/vlc-3.0.21-intel64.dmg)
                    file(DOWNLOAD
                        https://get.videolan.org/vlc/3.0.21/macosx/vlc-3.0.21-intel64.dmg
                        ${CMAKE_BINARY_DIR}/vlc-3.0.21-intel64.dmg
                        )
                endif (NOT EXISTS ${CMAKE_BINARY_DIR}/vlc-3.0.21-intel64.dmg)
                file(WRITE ${PREBUILD_TRACKING_DIR}/vlc_installed "0")
            endif (${PREBUILD_TRACKING_DIR}/sentinel_installed IS_NEWER_THAN ${PREBUILD_TRACKING_DIR}/vlc_installed OR NOT ${vlc_installed} EQUAL 0)
            execute_process(
                COMMAND hdiutil attach -noverify vlc-3.0.21-intel64.dmg
                WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
                )
        endif (CMAKE_OSX_ARCHITECTURES MATCHES arm64)
        target_include_directories( ll::libvlc SYSTEM INTERFACE /Volumes/VLC\ media\ player/VLC.app/Contents/MacOS/include)
        target_link_directories( ll::libvlc INTERFACE /Volumes/VLC\ media\ player/VLC.app/Contents/MacOS/lib)
        target_link_libraries( ll::libvlc INTERFACE vlc vlccore )
    else (DARWIN)
        include(FindPkgConfig)
        pkg_check_modules(Libvlc REQUIRED libvlc vlc-plugin)
        target_include_directories( ll::libvlc SYSTEM INTERFACE ${Libvlc_INCLUDE_DIRS} )
        target_link_directories( ll::libvlc INTERFACE ${Libvlc_LIBRARY_DIRS} )
        target_link_libraries( ll::libvlc INTERFACE ${Libvlc_LIBRARIES} )
    endif (DARWIN)
    set(LIBVLCPLUGIN ON CACHE BOOL
            "LIBVLCPLUGIN support for the llplugin/llmedia test apps.")
    return()
else (USESYSTEMLIBS)

use_prebuilt_binary(vlc-bin)
set(LIBVLCPLUGIN ON CACHE BOOL
        "LIBVLCPLUGIN support for the llplugin/llmedia test apps.")
endif (USESYSTEMLIBS)

if (WINDOWS)
    target_link_libraries( ll::libvlc INTERFACE
            libvlc.lib
            libvlccore.lib
    )
elseif (DARWIN)
    target_link_libraries( ll::libvlc INTERFACE
            libvlc.dylib
            libvlccore.dylib
    )
elseif (LINUX)
    # Specify a full path to make sure we get a static link
    target_link_libraries( ll::libvlc INTERFACE
        ${LIBS_PREBUILT_DIR}/lib/libvlc.a
        ${LIBS_PREBUILT_DIR}/lib/libvlccore.a
    )
endif (WINDOWS)
