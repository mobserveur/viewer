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

if(LINUX OR CMAKE_SYSTEM_NAME MATCHES FreeBSD )
  include(FindPkgConfig)
  pkg_check_modules(Colladadom REQUIRED collada-dom)
  target_compile_definitions( ll::colladadom INTERFACE COLLADA_DOM_SUPPORT141 )
  target_include_directories( ll::colladadom SYSTEM INTERFACE ${Colladadom_INCLUDE_DIRS} ${Colladadom_INCLUDE_DIRS}/1.4 )
  target_link_directories( ll::colladadom INTERFACE ${Colladadom_LIBRARY_DIRS} )
  target_link_libraries( ll::colladadom INTERFACE ${Colladadom_LIBRARIES} )
  return ()
endif(LINUX OR CMAKE_SYSTEM_NAME MATCHES FreeBSD )

if( USESYSTEMLIBS )
  if ( ${PREBUILD_TRACKING_DIR}/sentinel_installed IS_NEWER_THAN ${PREBUILD_TRACKING_DIR}/colladadom_installed OR NOT ${colladadom_installed} EQUAL 0 )
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
    file(MAKE_DIRECTORY ${LIBS_PREBUILT_DIR}/include/collada/1.4)
    include(FindPkgConfig)
    pkg_check_modules(Minizip REQUIRED minizip)
    pkg_check_modules(Libxml2 REQUIRED libxml-2.0)
    pkg_check_modules(Libpcrecpp libpcrecpp)
    if (DARWIN)
      try_compile(COLLADADOM_RESULT
        PROJECT colladadom
        SOURCE_DIR ${CMAKE_BINARY_DIR}/3p-colladadom-2.3-r4
        BINARY_DIR ${CMAKE_BINARY_DIR}/3p-colladadom-2.3-r4
        TARGET collada14dom
        CMAKE_FLAGS
          -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
          -DOPT_COLLADA14:BOOL=ON
          -DCOLLADA_DOM_INCLUDE_INSTALL_DIR:FILEPATH=${LIBS_PREBUILT_DIR}/include/collada
          -DCOLLADA_DOM_SOVERSION:STRING=0
          -DCOLLADA_DOM_VERSION:STRING=2.3-r4
          -DEXTRA_COMPILE_FLAGS:STRING="-I${Minizip_INCLUDE_DIRS} -I${Libxml2_INCLUDE_DIRS}"
          -DCMAKE_SHARED_LINKER_FLAGS:STRING="-L${Libxml2_LIBRARY_DIRS} -l${Libxml2_LIBRARIES}"
          -Dlibpcrecpp_LIBRARIES:STRING=pcrecpp
          -DBoost_FILESYSTEM_LIBRARY:STRING=boost_filesystem-mt
          -DBoost_SYSTEM_LIBRARY:STRING=boost_system-mt
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
          -DCOLLADA_DOM_INCLUDE_INSTALL_DIR:FILEPATH=${LIBS_PREBUILT_DIR}/include/collada
          -DCOLLADA_DOM_SOVERSION:STRING=0
          -DCOLLADA_DOM_VERSION:STRING=2.3-r4
          -DEXTRA_COMPILE_FLAGS:STRING="-I${Minizip_INCLUDE_DIRS} -I${Libxml2_INCLUDE_DIRS} -I${Libpcrecpp_INCLUDE_DIRS}"
          -DCMAKE_SHARED_LINKER_FLAGS:STRING="-L${Libxml2_LIBRARY_DIRS} -l${Libxml2_LIBRARIES}"
          -Dlibpcrecpp_LIBRARIES:STRING=pcrecpp
          -DBoost_FILESYSTEM_LIBRARY:STRING=boost_filesystem
          -DBoost_SYSTEM_LIBRARY:STRING=boost_system
        OUTPUT_VARIABLE colladadom_installed
        )
    endif (DARWIN)
    if (${COLLADADOM_RESULT})
      file(REMOVE_RECURSE ${LIBS_PREBUILT_DIR}/include/collada)
      file(
        COPY ${CMAKE_BINARY_DIR}/3p-colladadom-2.3-r4/dom/include
        DESTINATION ${LIBS_PREBUILT_DIR}/include/collada
        )
      file(
        COPY ${CMAKE_BINARY_DIR}/3p-colladadom-2.3-r4/dom/libcollada14dom.a
        DESTINATION ${LIBS_PREBUILT_DIR}/lib/release
        )
      file(WRITE ${PREBUILD_TRACKING_DIR}/colladadom_installed "0")
    endif (${COLLADADOM_RESULT})
  endif( ${PREBUILD_TRACKING_DIR}/sentinel_installed IS_NEWER_THAN ${PREBUILD_TRACKING_DIR}/colladadom_installed OR NOT ${colladadom_installed} EQUAL 0 )
else( USESYSTEMLIBS )
use_system_binary( colladadom )

use_prebuilt_binary(colladadom)
use_prebuilt_binary(minizip-ng) # needed for colladadom
use_prebuilt_binary(pcre)
use_prebuilt_binary(libxml2)
endif( USESYSTEMLIBS )

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
