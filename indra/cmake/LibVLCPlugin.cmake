# -*- cmake -*-
include(Linking)
include(Prebuilt)

include_guard()
add_library( ll::libvlc INTERFACE IMPORTED )

if (USE_AUTOBUILD_3P OR USE_CONAN)
use_prebuilt_binary(vlc-bin)
set(LIBVLCPLUGIN ON CACHE BOOL
        "LIBVLCPLUGIN support for the llplugin/llmedia test apps.")
else ()
    include(FindPkgConfig)
    if (DARWIN)
        set(CMAKE_PREFIX_PATH /opt/local/libexec/vlc3/lib/pkgconfig)
        pkg_check_modules(Libvlc REQUIRED libvlc)
        target_link_libraries( ll::libvlc INTERFACE vlccore )
    else ()
        pkg_check_modules(Libvlc REQUIRED libvlc vlc-plugin)
    endif ()
    target_include_directories( ll::libvlc SYSTEM INTERFACE ${Libvlc_INCLUDE_DIRS} )
    target_link_directories( ll::libvlc INTERFACE ${Libvlc_LIBRARY_DIRS} )
    target_link_libraries( ll::libvlc INTERFACE ${Libvlc_LIBRARIES} )
    set(LIBVLCPLUGIN ON CACHE BOOL
            "LIBVLCPLUGIN support for the llplugin/llmedia test apps.")
    return()
endif ()

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
