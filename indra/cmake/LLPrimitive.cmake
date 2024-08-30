# -*- cmake -*-

# these should be moved to their own cmake file
include(Prebuilt)
include(Boost)

include_guard()

add_library( ll::pcre INTERFACE IMPORTED )
add_library( ll::minizip-ng INTERFACE IMPORTED )
add_library( ll::libxml INTERFACE IMPORTED )
add_library( ll::colladadom INTERFACE IMPORTED )

# ND, needs fixup in collada conan pkg
if( USE_CONAN )
  target_include_directories( ll::colladadom SYSTEM INTERFACE
    "${CONAN_INCLUDE_DIRS_COLLADADOM}/collada-dom/"
    "${CONAN_INCLUDE_DIRS_COLLADADOM}/collada-dom/1.4/" )
endif()

if( (${PREBUILD_TRACKING_DIR}/sentinel_installed IS_NEWER_THAN ${PREBUILD_TRACKING_DIR}/colladadom_installed OR NOT ${colladadom_installed} EQUAL 0) AND USESYSTEMLIBS )
  if (NOT EXISTS ${CMAKE_BINARY_DIR}/3p-colladadom-2.3-r4.tar.gz)
    file(DOWNLOAD
      https://github.com/secondlife/3p-colladadom/archive/refs/tags/v2.3-r4.tar.gz
      ${CMAKE_BINARY_DIR}/3p-colladadom-2.3-r4.tar.gz
      )
  endif (NOT EXISTS ${CMAKE_BINARY_DIR}/3p-colladadom-2.3-r4.tar.gz)
  file(ARCHIVE_EXTRACT
    INPUT ${CMAKE_BINARY_DIR}/3p-colladadom-2.3-r4.tar.gz
    DESTINATION ${CMAKE_BINARY_DIR}
    )
  if (DARWIN)
    try_compile(COLLADADOM_RESULT
      PROJECT colladadom
      SOURCE_DIR ${CMAKE_BINARY_DIR}/3p-colladadom-2.3-r4
      BINARY_DIR ${CMAKE_BINARY_DIR}/3p-colladadom-2.3-r4
      TARGET collada14dom
      CMAKE_FLAGS
        -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
        -DOPT_COLLADA14:BOOL=ON
        -DCOLLADA_DOM_INCLUDE_INSTALL_DIR:FILEPATH=${LIBS_PREBUILT_DIR}/include/colladadom
        -DCOLLADA_DOM_SOVERSION:STRING=0
        -DCOLLADA_DOM_VERSION:STRING=2.3-r4
        -Dlibpcrecpp_LIBRARIES:STRING=pcrecpp
        -DZLIB_LIBRARIES:STRING=xml2
        -DBoost_FILESYSTEM_LIBRARY:STRING=boost_filesystem-mt
        -DBoost_SYSTEM_LIBRARY:STRING=boost_system-mt
        -DEXTRA_COMPILE_FLAGS:STRING=-I/opt/local/include/minizip
        -DBoost_CFLAGS:STRING=-I/opt/local/include
        -DCMAKE_SHARED_LINKER_FLAGS:STRING=-L/opt/local/lib
        -DCMAKE_OSX_ARCHITECTURES:STRING=${CMAKE_OSX_ARCHITECTURES}
        -DCMAKE_OSX_DEPLOYMENT_TARGET:STRING=10.15
      OUTPUT_VARIABLE colladadom_installed
      )
  else (DARWIN)
    try_compile(COLLADADOM_RESULT
      PROJECT colladadom
      SOURCE_DIR ${CMAKE_BINARY_DIR}/3p-colladadom-2.3-r4
      BINARY_DIR ${CMAKE_BINARY_DIR}/3p-colladadom-2.3-r4
      TARGET collada14dom
      CMAKE_FLAGS
        -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
        -DOPT_COLLADA14:BOOL=ON
        -DCOLLADA_DOM_INCLUDE_INSTALL_DIR:FILEPATH=${LIBS_PREBUILT_DIR}/include/colladadom
        -DCOLLADA_DOM_SOVERSION:STRING=0
        -DCOLLADA_DOM_VERSION:STRING=2.3-r4
        -Dlibpcrecpp_LIBRARIES:STRING=pcrecpp
        -DZLIB_LIBRARIES:STRING=xml2
      OUTPUT_VARIABLE colladadom_installed
      )
  endif (DARWIN)
  if (${MESHOPTIMIZER_RESULT})
    file(
      COPY ${CMAKE_BINARY_DIR}/3p-colladadom-2.3-r4/dom/include
      DESTINATION ${LIBS_PREBUILT_DIR}/include/colladadom
      )
    file(
      COPY ${CMAKE_BINARY_DIR}/3p-colladadom-2.3-r4/dom/libcollada14dom.a
      DESTINATION ${LIBS_PREBUILT_DIR}/lib/release
      )
    file(WRITE ${PREBUILD_TRACKING_DIR}/colladadom_installed "0")
  endif (${MESHOPTIMIZER_RESULT})
else( (${PREBUILD_TRACKING_DIR}/sentinel_installed IS_NEWER_THAN ${PREBUILD_TRACKING_DIR}/colladadom_installed OR NOT ${colladadom_installed} EQUAL 0) AND USESYSTEMLIBS )
use_system_binary( colladadom )

use_prebuilt_binary(colladadom)
use_prebuilt_binary(minizip-ng) # needed for colladadom
use_prebuilt_binary(pcre)
use_prebuilt_binary(libxml2)
endif( (${PREBUILD_TRACKING_DIR}/sentinel_installed IS_NEWER_THAN ${PREBUILD_TRACKING_DIR}/colladadom_installed OR NOT ${colladadom_installed} EQUAL 0) AND USESYSTEMLIBS )

target_link_libraries( ll::pcre INTERFACE pcrecpp pcre )

if (WINDOWS)
    target_link_libraries( ll::minizip-ng INTERFACE libminizip )
else()
    target_link_libraries( ll::minizip-ng INTERFACE minizip )
endif()

if (WINDOWS)
    target_link_libraries( ll::libxml INTERFACE libxml2_a)
else()
    target_link_libraries( ll::libxml INTERFACE xml2)
endif()

target_include_directories( ll::colladadom SYSTEM INTERFACE
        ${LIBS_PREBUILT_DIR}/include/collada
        ${LIBS_PREBUILT_DIR}/include/collada/1.4
        )
if (WINDOWS)
    target_link_libraries(ll::colladadom INTERFACE libcollada14dom23-s ll::libxml ll::minizip-ng )
elseif (DARWIN)
    target_link_libraries(ll::colladadom INTERFACE collada14dom ll::libxml ll::minizip-ng)
elseif (LINUX)
    target_link_libraries(ll::colladadom INTERFACE collada14dom ll::libxml ll::minizip-ng)
endif()
