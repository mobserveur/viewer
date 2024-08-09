# -*- cmake -*-
# Construct the viewer version number based on the indra/VIEWER_VERSION file

if (NOT DEFINED VIEWER_SHORT_VERSION) # will be true in indra/, false in indra/newview/
    set(VIEWER_VERSION_BASE_FILE "${CMAKE_CURRENT_SOURCE_DIR}/newview/VIEWER_VERSION.txt")

    if ( EXISTS ${VIEWER_VERSION_BASE_FILE} )
        file(STRINGS ${VIEWER_VERSION_BASE_FILE} VIEWER_SHORT_VERSION REGEX "^[0-9]+\\.[0-9]+\\.[0-9]+")
        string(REGEX REPLACE "^([0-9]+)\\.[0-9]+\\.[0-9]+" "\\1" VIEWER_VERSION_MAJOR ${VIEWER_SHORT_VERSION})
        string(REGEX REPLACE "^[0-9]+\\.([0-9]+)\\.[0-9]+" "\\1" VIEWER_VERSION_MINOR ${VIEWER_SHORT_VERSION})
        string(REGEX REPLACE "^[0-9]+\\.[0-9]+\\.([0-9]+)" "\\1" VIEWER_VERSION_PATCH ${VIEWER_SHORT_VERSION})

        if (DEFINED ENV{revision})
           set(VIEWER_VERSION_REVISION $ENV{revision})
           message(STATUS "Revision (from environment): ${VIEWER_VERSION_REVISION}")

        elseif (DEFINED ENV{AUTOBUILD_BUILD_ID})
           set(VIEWER_VERSION_REVISION $ENV{AUTOBUILD_BUILD_ID})
           message(STATUS "Revision (from autobuild environment): ${VIEWER_VERSION_REVISION}")

        else (DEFINED ENV{revision})
            find_program(GIT git)
            if (DEFINED GIT )
                execute_process(
                        COMMAND ${GIT} rev-list --count HEAD
                        OUTPUT_VARIABLE VIEWER_VERSION_REVISION
                        OUTPUT_STRIP_TRAILING_WHITESPACE
                )
                if ("${VIEWER_VERSION_REVISION}" MATCHES "^[0-9]+$")
                    message(STATUS "Revision (from git) ${VIEWER_VERSION_REVISION}")
                else ("${VIEWER_VERSION_REVISION}" MATCHES "^[0-9]+$")
                    message(STATUS "Revision not set (repository not found?); using 0")
                    set(VIEWER_VERSION_REVISION 0 )
                endif ("${VIEWER_VERSION_REVISION}" MATCHES "^[0-9]+$")
            else (DEFINED GIT )
                message(STATUS "Revision not set: 'git' found; using 0")
                set(VIEWER_VERSION_REVISION 0)
            endif (DEFINED GIT)
        endif (DEFINED ENV{revision})
        message(STATUS "Building '${VIEWER_CHANNEL}' Version ${VIEWER_SHORT_VERSION}.${VIEWER_VERSION_REVISION}")
    else ( EXISTS ${VIEWER_VERSION_BASE_FILE} )
        message(SEND_ERROR "Cannot get viewer version from '${VIEWER_VERSION_BASE_FILE}'")
    endif ( EXISTS ${VIEWER_VERSION_BASE_FILE} )

    if ("${VIEWER_VERSION_REVISION}" STREQUAL "")
      message(STATUS "Ultimate fallback, revision was blank or not set: will use 0")
      set(VIEWER_VERSION_REVISION 0)
    endif ("${VIEWER_VERSION_REVISION}" STREQUAL "")

    set(VIEWER_CHANNEL_VERSION_DEFINES
        "LL_VIEWER_CHANNEL=${VIEWER_CHANNEL}"
        "LL_VIEWER_VERSION_MAJOR=${VIEWER_VERSION_MAJOR}"
        "LL_VIEWER_VERSION_MINOR=${VIEWER_VERSION_MINOR}"
        "LL_VIEWER_VERSION_PATCH=${VIEWER_VERSION_PATCH}"
        "LL_VIEWER_VERSION_BUILD=${VIEWER_VERSION_REVISION}"
        "LLBUILD_CONFIG=\"${CMAKE_BUILD_TYPE}\""
        )

if (PACKAGE)
    set(CPACK_PACKAGE_NAME ${VIEWER_BINARY_NAME}
        CACHE STRING "Viewer binary name.")
    set(CPACK_PACKAGE_VERSION ${VIEWER_VERSION_MAJOR}.${VIEWER_VERSION_MINOR}.${VIEWER_VERSION_PATCH}.${VIEWER_VERSION_REVISION}
        CACHE STRING "Viewer major.minor.patch.revision versions.")
    set(VIEWER_PACKAGE_COMMENT
        "A fork of the Second Life viewer"
       )
    set(VIEWER_PACKAGE_DESCRIPTION
        "An entrance to virtual empires in only megabytes. A shelter for the metaverse refugees, especially those from less supported operating systems."
       )
    set(VIEWER_PACKAGE_DOMAIN_NAME
        ${VIEWER_BINARY_NAME}.net
       )
    if (LINUX)
        set(CPACK_BINARY_DEB ON CACHE BOOL "Able to package Debian DEB.")
        set(CPACK_DEBIAN_PACKAGE_ARCHITECTURE
            amd64
            CACHE STRING "Debian package architecture.")
        set(CPACK_DEBIAN_PACKAGE_DESCRIPTION ${VIEWER_PACKAGE_COMMENT}
            CACHE STRING "Debian package description.")
        set(CPACK_DEBIAN_PACKAGE_MAINTAINER
            $ENV{USER}@${VIEWER_PACKAGE_DOMAIN_NAME}
            CACHE STRING "Debian package maintainer.")
        set(CPACK_DEBIAN_PACKAGE_SECTION net
            CACHE STRING "Debian package section.")
        set(CPACK_BINARY_RPM ON CACHE BOOL "Able to package Fedora RPM.")
	set(CPACK_RPM_PACKAGE_SUMMARY ${VIEWER_PACKAGE_COMMENT}
            CACHE STRING "RPM package summary.")
        set(CPACK_RPM_PACKAGE_ARCHITECTURE
            ${CMAKE_SYSTEM_PROCESSOR}
            CACHE STRING "RPM package architecture.")
        set(CPACK_RPM_PACKAGE_LICENSE LGPL-2.1-only
            CACHE STRING "RPM package license.")
        set(CPACK_RPM_PACKAGE_VENDOR ${VIEWER_CHANNEL}
            CACHE STRING "RPM package vendor.")
        set(CPACK_RPM_PACKAGE_URL
            https://${VIEWER_PACKAGE_DOMAIN_NAME}
            CACHE STRING "RPM package URL.")
        set(CPACK_RPM_PACKAGE_DESCRIPTION ${VIEWER_PACKAGE_DESCRIPTION}
            CACHE STRING "RPM package description.")
        set(CPACK_RPM_PACKAGE_REQUIRES
            "apr-util, boost-fiber, boost-program-options, boost-regex, boost-thread, collada-dom, expat, fltk, mesa-libGLU, hunspell, jsoncpp, libnghttp2, SDL2, uriparser, vlc-libs, vlc-plugins-base, libvorbis, xmlrpc-epi"
            CACHE STRING "RPM package requirements.")
    elseif (CMAKE_SYSTEM_NAME MATCHES FreeBSD)
        set(CPACK_BINARY_FREEBSD ON CACHE BOOL "Able to package FreeBSD PKG.")
	set(CPACK_FREEBSD_PACKAGE_COMMENT ${VIEWER_PACKAGE_COMMENT}
            CACHE STRING "FreeBSD package comment.")
        set(CPACK_FREEBSD_PACKAGE_DESCRIPTION ${VIEWER_PACKAGE_DESCRIPTION}
            CACHE STRING "FreeBSD package description.")
        set(CPACK_FREEBSD_PACKAGE_WWW
            https://${VIEWER_PACKAGE_DOMAIN_NAME}
            CACHE STRING "FreeBSD package WWW.")
        set(CPACK_FREEBSD_PACKAGE_LICENSE LGPL21
            CACHE STRING "FreeBSD package license.")
        set(CPACK_FREEBSD_PACKAGE_MAINTAINER
            $ENV{USER}@${VIEWER_PACKAGE_DOMAIN_NAME}
            CACHE STRING "FreeBSD package maintainer.")
        set(CPACK_FREEBSD_PACKAGE_ORIGIN net/${VIEWER_BINARY_NAME}
            CACHE STRING "FreeBSD package origin.")
        set(CPACK_FREEBSD_PACKAGE_DEPS
            "audio/freealut;devel/collada-dom;graphics/libGLU;textproc/hunspell;misc/meshoptimizer;www/libnghttp2;graphics/openjpeg;net/uriparser;multimedia/vlc;audio/libvorbis;net/xmlrpc-epi"
            CACHE STRING "FreeBSD package dependencies.")
    endif ()
    include(CPack)
endif (PACKAGE)

endif (NOT DEFINED VIEWER_SHORT_VERSION)
