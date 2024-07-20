# -*- cmake -*-

project(media_plugin_gstreamer)

include(00-Common)
include(LLCommon)
include(LLImage)
include(LLMath)
include(LLWindow)
include(Linking)
include(PluginAPI)
include(OpenGL)
include(GLIB)

include(GStreamer10Plugin)

### media_plugin_gstreamer10

set(${PROJECT_NAME}_SOURCE_FILES
    media_plugin_gstreamer10.cpp
    )

set(media_plugin_gstreamer10_HEADER_FILES
    llmediaimplgstreamer_syms.h
    llmediaimplgstreamertriviallogging.h
    )

add_library(${PROJECT_NAME}
    SHARED
    ${${PROJECT_NAME}_SOURCE_FILES}
)

target_link_libraries(${PROJECT_NAME} media_plugin_base ll::gstreamer10 )

if (WINDOWS)
  set_target_properties(
    media_plugin_gstreamer10
    PROPERTIES
    LINK_FLAGS "/MANIFEST:NO /SAFESEH:NO /NODEFAULTLIB:LIBCMT"
    )
endif (WINDOWS)

if (INSTALL)
	if (EXISTS ${CMAKE_SYSROOT}/usr/lib/${ARCH}-linux-gnu)
		set(_LIB lib/${ARCH}-linux-gnu)
	elseif (EXISTS /lib64)
		set(_LIB lib64)
	else ()
		set(_LIB lib)
	endif ()
	install(TARGETS ${PROJECT_NAME} DESTINATION ${_LIB})
endif ()
