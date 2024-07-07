# -*- cmake -*-

project(media_plugin_libvlc)

include(00-Common)
include(LLCommon)
include(LLImage)
include(LLWindow)
include(Linking)
include(PluginAPI)

include(LibVLCPlugin)

### media_plugin_libvlc

if(NOT ADDRESS_SIZE EQUAL 32)
  if(WINDOWS)
    ##add_definitions(/FIXED:NO)
  else(WINDOWS) # not windows therefore gcc LINUX and DARWIN
    add_definitions(-fPIC)
  endif(WINDOWS)
endif(NOT ADDRESS_SIZE EQUAL 32)

set(media_plugin_libvlc_SOURCE_FILES
    media_plugin_libvlc.cpp
    )

add_library(media_plugin_libvlc
    SHARED
    ${media_plugin_libvlc_SOURCE_FILES}
    )

target_link_libraries(media_plugin_libvlc
        media_plugin_base
        ll::libvlc
)

if (WINDOWS)
  set_target_properties(
    media_plugin_libvlc
    PROPERTIES
    LINK_FLAGS "/MANIFEST:NO /SAFESEH:NO /NODEFAULTLIB:LIBCMT"
    )
endif (WINDOWS)

if (DARWIN)
  # Don't prepend 'lib' to the executable name, and don't embed a full path in the library's install name
  set_target_properties(
    media_plugin_libvlc
    PROPERTIES
    PREFIX ""
    BUILD_WITH_INSTALL_RPATH 1
    INSTALL_NAME_DIR "@executable_path"
    LINK_FLAGS "-exported_symbols_list ${CMAKE_CURRENT_SOURCE_DIR}/../base/media_plugin_base.exp"
  )

  add_custom_command(TARGET ${PROJECT_NAME}
    POST_BUILD COMMAND ${CMAKE_INSTALL_NAME_TOOL}
        -change "/opt/local/lib/libopenjp2.7.dylib" "@loader_path/../../Frameworks/libopenjp2.7.dylib"
        -change "/opt/local/lib/libpng16.16.dylib" "@loader_path/../../Frameworks/libpng16.16.dylib"
        -change "/opt/local/lib/libjpeg.8.dylib" "@loader_path/../../Frameworks/libjpeg.8.dylib"
        -change "/opt/local/lib/libfreetype.6.dylib" "@loader_path/../../Frameworks/libfreetype.6.dylib"
        -change "@rpath/libmeshoptimizer.dylib" "@loader_path/../../Frameworks/libmeshoptimizer.dylib"
        -change "/opt/local/lib/libaprutil-1.0.dylib" "@loader_path/../../Frameworks/libaprutil-1.0.dylib"
        -change "/opt/local/lib/libiconv.2.dylib" "@loader_path/../../Frameworks/libiconv.2.dylib"
        -change "/opt/local/lib/libapr-1.0.dylib" "@loader_path/../../Frameworks/libapr-1.0.dylib"
        -change "/opt/local/lib/libexpat.1.dylib" "@loader_path/../../Frameworks/libexpat.1.dylib"
        -change "/opt/local/lib/libjsoncpp.25.dylib" "@loader_path/../../Frameworks/libjsoncpp.25.dylib"
        -change "/opt/local/lib/libz.1.dylib" "@loader_path/../../Frameworks/libz.1.dylib"
        -change "/opt/local/libexec/boost/1.76/lib/libboost_context-mt.dylib" "@loader_path/../../Frameworks/libboost_context-mt.dylib"
        -change "/opt/local/libexec/boost/1.76/lib/libboost_fiber-mt.dylib" "@loader_path/../../Frameworks/libboost_fiber-mt.dylib"
        -change "/opt/local/libexec/boost/1.76/lib/libboost_filesystem-mt.dylib" "@loader_path/../../Frameworks/libboost_filesystem-mt.dylib"
        -change "/opt/local/libexec/boost/1.76/lib/libboost_program_options-mt.dylib" "@loader_path/../../Frameworks/libboost_program_options-mt.dylib"
        -change "/opt/local/libexec/boost/1.76/lib/libboost_regex-mt.dylib" "@loader_path/../../Frameworks/libboost_regex-mt.dylib"
        -change "/opt/local/libexec/boost/1.76/lib/libboost_system-mt.dylib" "@loader_path/../../Frameworks/libboost_system-mt.dylib"
        -change "/opt/local/libexec/boost/1.76/lib/libboost_thread-mt.dylib" "@loader_path/../../Frameworks/libboost_thread-mt.dylib"
        -change "/opt/local/lib/liburiparser.1.dylib" "@loader_path/../../Frameworks/liburiparser.1.dylib"
        -change "/opt/local/lib/libnghttp2.14.dylib" "@loader_path/../../Frameworks/libnghttp2.14.dylib"
        -change "/usr/local/lib/libxmlrpc-epi.0.dylib" "@loader_path/../../Frameworks/libxmlrpc-epi.0.dylib"
        -change "@rpath/libvlc.dylib" "@loader_path/../../Frameworks/libvlc.dylib"
        -change "@rpath/libvlccore.dylib" "@loader_path/../../Frameworks/libvlccore.dylib"
        "$<TARGET_FILE:media_plugin_libvlc>"
    VERBATIM
    COMMENT "Fixing paths to LibVLC media plugin dependencies"
  )

endif (DARWIN)

if (INSTALL)
    if (DARWIN)
        set(_LIB Resources/llplugin)
    elseif (EXISTS ${CMAKE_SYSROOT}/usr/lib/${ARCH}-linux-gnu)
        set(_LIB lib/${ARCH}-linux-gnu)
    elseif (EXISTS /lib64)
        set(_LIB lib64)
    else (DARWIN)
        set(_LIB lib)
    endif (DARWIN)
    install(TARGETS ${PROJECT_NAME} DESTINATION ${_LIB})
endif (INSTALL)
