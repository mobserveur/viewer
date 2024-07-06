project(SLPlugin)

include(00-Common)
include(LLCommon)
include(Linking)
include(PluginAPI)

### SLPlugin

set(SLPlugin_SOURCE_FILES
    slplugin.cpp
    )

if (DARWIN)
  list(APPEND SLPlugin_SOURCE_FILES
    slplugin-objc.mm
  )
  list(APPEND SLPlugin_HEADER_FILES
    slplugin-objc.h
  )
endif (DARWIN)

if (SLPlugin_HEADER_FILES)
  list(APPEND SLPlugin_SOURCE_FILES ${SLPlugin_HEADER_FILES})
endif (SLPlugin_HEADER_FILES)

add_executable(SLPlugin
    WIN32
    MACOSX_BUNDLE
    ${SLPlugin_SOURCE_FILES}
    )

if (WINDOWS)
set_target_properties(SLPlugin
  PROPERTIES
  LINK_FLAGS_DEBUG "/NODEFAULTLIB:\"LIBCMTD\""
  )
else ()
set_target_properties(SLPlugin
  PROPERTIES
  MACOSX_BUNDLE_INFO_PLIST ${CMAKE_CURRENT_SOURCE_DIR}/slplugin_info.plist
  )
endif ()

target_link_libraries(SLPlugin
        llplugin
        llmessage
        llcommon
        ll::pluginlibraries
        )

if (DARWIN)
  # Make sure the app bundle has a Resources directory (it will get populated by viewer-manifest.py later)
  add_custom_command(
    TARGET SLPlugin POST_BUILD
    COMMAND mkdir
    ARGS
      -p
      ${CMAKE_CURRENT_BINARY_DIR}/$<IF:$<BOOL:${LL_GENERATOR_IS_MULTI_CONFIG}>,$<CONFIG>,>/SLPlugin.app/Contents/Frameworks
  )
  set(frameworks ${CMAKE_CURRENT_BINARY_DIR}/SLPlugin.app/Contents/Frameworks)
  file(CREATE_LINK "../../../../Frameworks/libnghttp2.14.dylib" "${frameworks}/libnghttp2.14.dylib" SYMBOLIC)
  file(CREATE_LINK "../../../../Frameworks/libxmlrpc-epi.0.dylib" "${frameworks}/libxmlrpc-epi.0.dylib" SYMBOLIC)
  file(CREATE_LINK "../../../../Frameworks/libopenjp2.7.dylib" "${frameworks}/libopenjp2.7.dylib" SYMBOLIC)
  file(CREATE_LINK "../../../../Frameworks/libpng16.16.dylib" "${frameworks}/libpng16.16.dylib" SYMBOLIC)
  file(CREATE_LINK "../../../../Frameworks/libjpeg.8.dylib" "${frameworks}/libjpeg.8.dylib" SYMBOLIC)
  file(CREATE_LINK "../../../../Frameworks/libmeshoptimizer.dylib" "${frameworks}/libmeshoptimizer.dylib" SYMBOLIC)
  file(CREATE_LINK "../../../../Frameworks/libaprutil-1.0.dylib" "${frameworks}/libaprutil-1.0.dylib" SYMBOLIC)
  file(CREATE_LINK "../../../../Frameworks/libiconv.2.dylib" "${frameworks}/libiconv.2.dylib" SYMBOLIC)
  file(CREATE_LINK "../../../../Frameworks/libapr-1.0.dylib" "${frameworks}/libapr-1.0.dylib" SYMBOLIC)
  file(CREATE_LINK "../../../../Frameworks/libjsoncpp.25.dylib" "${frameworks}/libjsoncpp.25.dylib" SYMBOLIC)
  file(CREATE_LINK "../../../../Frameworks/libz.1.dylib" "${frameworks}/libz.1.dylib" SYMBOLIC)
  file(CREATE_LINK "../../../../Frameworks/libboost_context-mt.dylib" "${frameworks}/libboost_context-mt.dylib" SYMBOLIC)
  file(CREATE_LINK "../../../../Frameworks/libboost_fiber-mt.dylib" "${frameworks}/libboost_fiber-mt.dylib" SYMBOLIC)
  file(CREATE_LINK "../../../../Frameworks/libboost_filesystem-mt.dylib" "${frameworks}/libboost_filesystem-mt.dylib" SYMBOLIC)
  file(CREATE_LINK "../../../../Frameworks/libboost_program_options-mt.dylib" "${frameworks}/libboost_program_options-mt.dylib" SYMBOLIC)
  file(CREATE_LINK "../../../../Frameworks/libboost_regex-mt.dylib" "${frameworks}/libboost_regex-mt.dylib" SYMBOLIC)
  file(CREATE_LINK "../../../../Frameworks/libboost_system-mt.dylib" "${frameworks}/libboost_system-mt.dylib" SYMBOLIC)
  file(CREATE_LINK "../../../../Frameworks/libboost_thread-mt.dylib" "${frameworks}/libboost_thread-mt.dylib" SYMBOLIC)
  file(CREATE_LINK "../../../../Frameworks/liburiparser.1.dylib" "${frameworks}/liburiparser.1.dylib" SYMBOLIC)
  file(CREATE_LINK "../../../../Frameworks/libexpat.1.dylib" "${frameworks}/libexpat.1.dylib" SYMBOLIC)
  file(CREATE_LINK "../../../../Frameworks/libfreetype.6.dylib" "${frameworks}/libfreetype.6.dylib" SYMBOLIC)
  file(CREATE_LINK "../../../../Frameworks/libicudata.74.dylib" "${frameworks}/libicudata.74.dylib" SYMBOLIC)
  file(CREATE_LINK "../../../../Frameworks/libicui18n.74.dylib" "${frameworks}/libicui18n.74.dylib" SYMBOLIC)
  file(CREATE_LINK "../../../../Frameworks/libicuuc.74.dylib" "${frameworks}/libicuuc.74.dylib" SYMBOLIC)
  file(CREATE_LINK "../../../../Frameworks/libbz2.1.0.dylib" "${frameworks}/libbz2.1.0.dylib" SYMBOLIC)
  file(CREATE_LINK "../../../../Frameworks/libbrotlidec.1.1.0.dylib" "${frameworks}/libbrotlidec.1.1.0.dylib" SYMBOLIC)
  file(CREATE_LINK "../../../../Frameworks/libbrotlicommon.1.dylib" "${frameworks}/libbrotlicommon.1.dylib" SYMBOLIC)
endif (DARWIN)

if (BUILD_SHARED_LIBS)
  set_target_properties(SLPlugin PROPERTIES LINK_FLAGS_RELEASE
    "${LINK_FLAGS_RELEASE} -Wl,--allow-shlib-undefined")
endif ()

if (INSTALL)
  if (DARWIN)
    install(TARGETS ${PROJECT_NAME}
      DESTINATION ${viewer_BINARY_DIR}/${VIEWER_CHANNEL}.app/Contents/Resources)
  else (DARWIN)
    install(TARGETS ${PROJECT_NAME} DESTINATION libexec/${VIEWER_BINARY_NAME})
  endif (DARWIN)
endif (INSTALL)

if (LL_TESTS)
  ll_deploy_sharedlibs_command(SLPlugin)
endif (LL_TESTS)
