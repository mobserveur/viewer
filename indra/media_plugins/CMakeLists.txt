# -*- cmake -*-

add_subdirectory(base)

if (LINUX OR CMAKE_SYSTEM_NAME MATCHES "FreeBSD")
    add_subdirectory(libvlc)
    add_subdirectory(example)
endif (LINUX OR CMAKE_SYSTEM_NAME MATCHES "FreeBSD")

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
