# -*- cmake -*-
include(Linking)
include(Prebuilt)

include_guard()
add_library( ll::libvlc INTERFACE IMPORTED )

if (USESYSTEMLIBS)

    if (DARWIN)
        if (CMAKE_OSX_ARCHITECTURES MATCHES arm64)
            execute_process(COMMAND hdiutil attach -noverify $ENV{HOME}/Downloads/vlc-3.0.21-arm64.dmg)
        elseif (CMAKE_OSX_ARCHITECTURES MATCHES x86_64)
            execute_process(COMMAND hdiutil attach -noverify $ENV{HOME}/Downloads/vlc-3.0.21-intel64.dmg)
        else ()
            execute_process(COMMAND hdiutil attach -noverify $ENV{HOME}/Downloads/vlc-3.0.21-universal.dmg)
        endif ()
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
