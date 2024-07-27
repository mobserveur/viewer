# -*- cmake -*-
include(Prebuilt)

if (NOT USESYSTEMLIBS)
use_prebuilt_binary(tinyexr)
endif ()

set(TINYEXR_INCLUDE_DIR ${LIBS_PREBUILT_DIR}/include/tinyexr)

