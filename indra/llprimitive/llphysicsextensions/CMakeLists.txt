# -*- cmake -*-

project(llphysicsextensions)

include(00-Common)
include(Variables)
include(LLCommon)
include(LLMath)

set(LLPHYSICSEXTENSIONS_LIB_NAME     llphysicsextensions)

if (WINDOWS)
   set(LLPHYSICSEXTENSIONS_LIBRARIES ${LLPHYSICSEXTENSIONS_LIB_NAME}.lib)
else (WINDOWS)
   set(LLPHYSICSEXTENSIONS_LIBRARIES ${LLPHYSICSEXTENSIONS_LIB_NAME}.a)
endif (WINDOWS)

set(LLPHYSICSEXTENSIONS_INCLUDE_DIR
    ${CMAKE_CURRENT_SOURCE_DIR})

set(LLPHYSICSEXTENSIONS_DEBUG_LIBRARY_PATH ${LIBS_PREBUILT_DIR}/lib/debug)
set(LLPHYSICSEXTENSIONS_RELEASE_LIBRARY_PATH ${LIBS_PREBUILT_DIR}/lib/release)

#set(LLPHYSICSEXTENSIONS_LIBRARIES_LIBRARIES
#    debug     ${LLPHYSICSEXTENSIONS_DEBUG_LIB}
#    optimized ${LLPHYSICSEXTENTIONS_RELEASE_LIB}
#)

if (LINUX)
    list(INSERT LLPHYSICSEXTENSIONS_LIBRARIES 0 -Wl,--start-group)
    list(APPEND LLPHYSICSEXTENSIONS_LIBRARIES -Wl,--end-group)
endif (LINUX)

#include_directories(
#    ${CMAKE_SOURCE_DIR}/llphysicsextensions
#    ${LLPHYSICSEXTENSIONS_INCLUDE_DIR}
#    ${LLCOMMON_INCLUDE_DIRS}
#    ${LLMATH_INCLUDE_DIRS}
#    )

set(llphysicsextensions_SOURCE_FILES
    llpathinglib.cpp
    LLPathingLibStubImpl.cpp
    llconvexdecomposition.cpp
    LLConvexDecompositionStubImpl.cpp
    llphysicsextensions.cpp
    LLPhysicsExtensionsStubImpl.cpp
    )
    
set(llphysicsextensions_HEADER_FILES

    ${LLPHYSICSEXTENSIONS_INCLUDE_DIR}/llpathinglib.h
    ${LLPHYSICSEXTENSIONS_INCLUDE_DIR}/llconvexdecomposition.h
    ${LLPHYSICSEXTENSIONS_INCLUDE_DIR}/llphysicsextensions.h
    LLPathingLibStubImpl.h
    LLConvexDecompositionStubImpl.h
    LLPhysicsExtensionsStubImpl.h
    )

if (WINDOWS)
   list(APPEND llphysicsextensions_HEADER_FILES 
               ${LLPHYSICSEXTENSIONS_INCLUDE_DIR}/windowsincludes.h)
endif (WINDOWS)

set_source_files_properties(${llphysicsextensions_HEADER_FILES}
                            PROPERTIES HEADER_FILE_ONLY TRUE)

# some of the include files contain compile-time switches based on these
set_source_files_properties(${llphysicsextensions_SOURCE_FILES}
                            PROPERTIES COMPILE_DEFINITIONS "LL_PATHING_LIB_STUB;LL_CONVEX_DECOMP_STUB;LL_PHYSICS_EXTENSIONS_STUB")

list(APPEND llphysicsextensionsstub_SOURCE_FILES ${llphysicsextensions_HEADER_FILES})

add_library(${PROJECT_NAME}stub ${${PROJECT_NAME}_SOURCE_FILES})
target_include_directories(${PROJECT_NAME}stub INTERFACE ${CMAKE_CURRENT_SOURCE_DIR})
target_link_libraries(${PROJECT_NAME}stub llmath llcommon)
list(REMOVE_ITEM ${PROJECT_NAME}_HEADER_FILES
	LLPathingLibStubImpl.h
	LLConvexDecompositionStubImpl.h
	LLPhysicsExtensionsStubImpl.h)
#install(FILES ${${PROJECT_NAME}_HEADER_FILES} DESTINATION include/${PROJECT_NAME})
if (BUILD_SHARED_LIBS)
	install(TARGETS ${PROJECT_NAME}stub DESTINATION lib)
endif ()

if (LINUX)
    IF(CMAKE_BUILD_TYPE MATCHES Release)
    SET(LIBRARY_OUTPUT_PATH ${PROJECT_BINARY_DIR}/release)
    ENDIF(CMAKE_BUILD_TYPE MATCHES Release)
    IF(CMAKE_BUILD_TYPE MATCHES Debug)
    SET(LIBRARY_OUTPUT_PATH ${PROJECT_BINARY_DIR}/debug)
    ENDIF(CMAKE_BUILD_TYPE MATCHES Debug)

endif (LINUX)
