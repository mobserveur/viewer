# -*- cmake -*-

add_subdirectory(base)

if (CMAKE_SYSTEM_NAME MATCHES "FreeBSD")
    add_subdirectory(example)
    add_subdirectory(gstreamer10)
endif (CMAKE_SYSTEM_NAME MATCHES "FreeBSD")

if (LINUX)
    add_subdirectory(cef)
    add_subdirectory(example)
    add_subdirectory(gstreamer10)
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
