# -*- cmake -*-

add_subdirectory(base)

if (CMAKE_SYSTEM_NAME MATCHES "FreeBSD")
    add_subdirectory(libvlc)
    add_subdirectory(example)
endif (CMAKE_SYSTEM_NAME MATCHES "FreeBSD")

if (DARWIN OR LINUX)
    add_subdirectory(cef)
    add_subdirectory(libvlc)
    add_subdirectory(example)
endif (DARWIN OR LINUX)

if (WINDOWS)
    add_subdirectory(cef)
    add_subdirectory(libvlc)
    add_subdirectory(example)
endif (WINDOWS)
