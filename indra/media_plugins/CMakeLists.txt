# -*- cmake -*-

add_subdirectory(base)

if (NOT (USE_AUTOBUILD_3P OR USE_CONAN))
    add_subdirectory(libvlc)
    add_subdirectory(example)
    return()
endif ()

if (LINUX)
    #add_subdirectory(gstreamer010)
    add_subdirectory(example)
endif (LINUX)

if (DARWIN)
    add_subdirectory(cef)
    add_subdirectory(libvlc)
    add_subdirectory(example)
endif (DARWIN)

if (WINDOWS)
    add_subdirectory(cef)
    add_subdirectory(libvlc)
    add_subdirectory(example)
endif (WINDOWS)
