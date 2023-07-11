# -*- cmake -*-
if (XXHASH_CMAKE_INCLUDED)
  return()
endif (XXHASH_CMAKE_INCLUDED)
set (XXHASH_CMAKE_INCLUDED TRUE)

include(Prebuilt)

if (NOT (USE_AUTOBUILD_3P OR USE_CONAN))
  include(FindPkgConfig)
  pkg_check_modules(Xxhash REQUIRED libxxhash)
  return ()
endif ()

use_prebuilt_binary(xxhash)
