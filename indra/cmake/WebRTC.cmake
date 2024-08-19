# -*- cmake -*-
include(Linking)
include(Prebuilt)

include_guard()

add_library( ll::webrtc INTERFACE IMPORTED )
target_include_directories( ll::webrtc SYSTEM INTERFACE "${LIBS_PREBUILT_DIR}/include/webrtc" "${LIBS_PREBUILT_DIR}/include/webrtc/third_party/abseil-cpp")
if (CMAKE_OSX_ARCHITECTURES MATCHES arm64)
    if (${PREBUILD_TRACKING_DIR}/sentinel_installed IS_NEWER_THAN ${PREBUILD_TRACKING_DIR}/webrtc_installed OR NOT ${webrtc_installed} EQUAL 0)
        if (NOT EXISTS ${CMAKE_BINARY_DIR}/libwebrtc-macos-arm64.tar.xz)
            file(DOWNLOAD
                https://github.com/crow-misia/libwebrtc-bin/releases/download/114.5735.6.1/libwebrtc-macos-arm64.tar.xz
                ${CMAKE_BINARY_DIR}/libwebrtc-macos-arm64.tar.xz
                SHOW_PROGRESS
                )
        endif (NOT EXISTS ${CMAKE_BINARY_DIR}/libwebrtc-macos-arm64.tar.xz)
        file(ARCHIVE_EXTRACT
            INPUT ${CMAKE_BINARY_DIR}/libwebrtc-macos-arm64.tar.xz
            DESTINATION ${LIBS_PREBUILT_DIR}
            )
        file(RENAME
          ${LIBS_PREBUILT_DIR}/lib/libwebrtc.a
          ${LIBS_PREBUILT_DIR}/lib/release/libwebrtc.a
          )
        file(REMOVE_RECURSE ${LIBS_PREBUILT_DIR}/Frameworks/WebRTC.xcframework/macos-arm64/WebRTC.framework)
        file(RENAME
          ${LIBS_PREBUILT_DIR}/Frameworks/WebRTC.xcframework/macos-arm64/WebRTC.framework
          ${LIBS_PREBUILT_DIR}/lib/release/WebRTC.framework
          )
        file(REMOVE_RECURSE ${LIBS_PREBUILT_DIR}/Frameworks)
        file(WRITE ${PREBUILD_TRACKING_DIR}/webrtc_installed "0")
    endif (${PREBUILD_TRACKING_DIR}/sentinel_installed IS_NEWER_THAN ${PREBUILD_TRACKING_DIR}/webrtc_installed OR NOT ${webrtc_installed} EQUAL 0)
elseif (NOT CMAKE_SYSTEM_NAME MATCHES FreeBSD)
use_prebuilt_binary(webrtc)
endif (CMAKE_OSX_ARCHITECTURES MATCHES arm64)

if (WINDOWS)
    target_link_libraries( ll::webrtc INTERFACE webrtc.lib )
elseif (DARWIN)
    FIND_LIBRARY(COREAUDIO_LIBRARY CoreAudio)
    FIND_LIBRARY(COREGRAPHICS_LIBRARY CoreGraphics)
    FIND_LIBRARY(AUDIOTOOLBOX_LIBRARY AudioToolbox)
    FIND_LIBRARY(COREFOUNDATION_LIBRARY CoreFoundation)
    FIND_LIBRARY(COCOA_LIBRARY Cocoa)

    target_link_libraries( ll::webrtc INTERFACE
        libwebrtc.a
        ${COREAUDIO_LIBRARY}
        ${AUDIOTOOLBOX_LIBRARY}
        ${COREGRAPHICS_LIBRARY}
        ${COREFOUNDATION_LIBRARY}
        ${COCOA_LIBRARY}
    )
elseif (LINUX)
    target_link_libraries( ll::webrtc INTERFACE libwebrtc.a X11 )
endif (WINDOWS)


