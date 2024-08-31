# -*- cmake -*-

project(llprimitive)

include(00-Common)
include(DepsBuild)
include(LLCommon)
include(LLCoreHttp)
include(LLPhysicsExtensions)
include(LLPrimitive)
include(GLH)
include(GLM)
include(TinyGLTF)

if(LINUX OR CMAKE_SYSTEM_NAME MATCHES FreeBSD )
  checkout_deps_repository(
	"https://github.com/oikumene/3p-colladadom-test.git"
	"collada-dom" "v2.3-r7-megapahit"
  )
  set(OPT_COLLADA14 TRUE)
  add_subdirectory(${CMAKE_SOURCE_DIR}/../../collada-dom "collada-dom")
  target_include_directories(
	  ll::colladadom INTERFACE
	  ${colladadom_SOURCE_DIR}/include
	  ${colladadom_SOURCE_DIR}/include/1.4
  )
  target_link_libraries( ll::colladadom INTERFACE collada14dom )
endif(LINUX OR CMAKE_SYSTEM_NAME MATCHES FreeBSD )

set(llprimitive_SOURCE_FILES
    lldaeloader.cpp
    llgltfloader.cpp
    llgltfmaterial.cpp
    llmaterialid.cpp
    llmaterial.cpp
    llmaterialtable.cpp
    llmediaentry.cpp
    llmodel.cpp
    llmodelloader.cpp
    llprimitive.cpp
    llprimtexturelist.cpp
    lltextureanim.cpp
    lltextureentry.cpp
    lltreeparams.cpp
    llvolumemessage.cpp
    material_codes.cpp
    )

set(llprimitive_HEADER_FILES
    CMakeLists.txt
    lldaeloader.h
    llgltfloader.h
    llgltfmaterial.h
    llgltfmaterial_templates.h
    legacy_object_types.h
    llmaterial.h
    llmaterialid.h
    llmaterialtable.h
    llmediaentry.h
    llmodel.h
    llmodelloader.h
    llprimitive.h
    llprimtexturelist.h
    lllslconstants.h
    lltextureanim.h
    lltextureentry.h
    lltreeparams.h
    lltree_common.h
    llvolumemessage.h
    material_codes.h
    object_flags.h
    )

list(APPEND llprimitive_SOURCE_FILES ${llprimitive_HEADER_FILES})

add_library (llprimitive ${llprimitive_SOURCE_FILES})
target_include_directories( llprimitive  INTERFACE   ${CMAKE_CURRENT_SOURCE_DIR})

target_link_libraries(llprimitive
        llcommon
        llmath
        llmessage
        llcorehttp
        llxml
        llcharacter
        llrender
        llphysicsextensions_impl
        ll::colladadom
        ll::pcre
        ll::glh_linear
        )

if (USESYSTEMLIBS)
    add_subdirectory(llphysicsextensions)
endif ()

include(LibraryInstall)

#add unit tests
if (LL_TESTS)
    INCLUDE(LLAddBuildTest)
    SET(llprimitive_TEST_SOURCE_FILES
      llmediaentry.cpp
      llprimitive.cpp
      llgltfmaterial.cpp
      )

    set_property(SOURCE llprimitive.cpp PROPERTY LL_TEST_ADDITIONAL_LIBRARIES llmessage)
    LL_ADD_PROJECT_UNIT_TESTS(llprimitive "${llprimitive_TEST_SOURCE_FILES}")
endif (LL_TESTS)
