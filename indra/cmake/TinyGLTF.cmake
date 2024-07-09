# -*- cmake -*-
include(Prebuilt)

if (NOT USESYSTEMLIBS)
use_prebuilt_binary(tinygltf)
endif (NOT USESYSTEMLIBS)

set(TINYGLTF_INCLUDE_DIR ${LIBS_PREBUILT_DIR}/include/tinygltf)

