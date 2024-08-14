# -*- cmake -*-
include(Prebuilt)

if (NOT DARWIN)
  add_library( ll::fontconfig INTERFACE IMPORTED )

  find_package(Fontconfig REQUIRED)
  target_link_libraries( ll::fontconfig INTERFACE  Fontconfig::Fontconfig )
endif (NOT DARWIN)

if( USE_AUTOBUILD_3P )
  use_prebuilt_binary(libhunspell)
endif()

if (NOT USESYSTEMLIBS)
use_prebuilt_binary(slvoice)

use_prebuilt_binary(nanosvg)
elseif (${LINUX_DISTRO} MATCHES debian OR (${LINUX_DISTRO} MATCHES ubuntu) OR DARWIN)
  if (${PREBUILD_TRACKING_DIR}/sentinel_installed IS_NEWER_THAN ${PREBUILD_TRACKING_DIR}/nanosvg_installed OR NOT ${nanosvg_installed} EQUAL 0)
    if (DARWIN)
      if (NOT EXISTS ${CMAKE_BINARY_DIR}/nanosvg-2022.09.27-darwin64-580364.tar.bz2)
        file(DOWNLOAD
          https://automated-builds-secondlife-com.s3.amazonaws.com/ct2/115452/994130/nanosvg-2022.09.27-darwin64-580364.tar.bz2
          ${CMAKE_BINARY_DIR}/nanosvg-2022.09.27-darwin64-580364.tar.bz2
          )
      endif (NOT EXISTS ${CMAKE_BINARY_DIR}/nanosvg-2022.09.27-darwin64-580364.tar.bz2)
      file(ARCHIVE_EXTRACT
        INPUT ${CMAKE_BINARY_DIR}/nanosvg-2022.09.27-darwin64-580364.tar.bz2
        DESTINATION ${LIBS_PREBUILT_DIR}
        )
    else (DARWIN)
      if (NOT EXISTS ${CMAKE_BINARY_DIR}/nanosvg-2022.09.27-linux-580337.tar.bz2)
        file(DOWNLOAD
          https://automated-builds-secondlife-com.s3.amazonaws.com/ct2/115397/993664/nanosvg-2022.09.27-linux-580337.tar.bz2
          ${CMAKE_BINARY_DIR}/nanosvg-2022.09.27-linux-580337.tar.bz2
          )
      endif (NOT EXISTS ${CMAKE_BINARY_DIR}/nanosvg-2022.09.27-linux-580337.tar.bz2)
      file(ARCHIVE_EXTRACT
        INPUT ${CMAKE_BINARY_DIR}/nanosvg-2022.09.27-linux-580337.tar.bz2
        DESTINATION ${LIBS_PREBUILT_DIR}
        )
    endif (DARWIN)
    file(WRITE ${PREBUILD_TRACKING_DIR}/nanosvg_installed "0")
  endif (${PREBUILD_TRACKING_DIR}/sentinel_installed IS_NEWER_THAN ${PREBUILD_TRACKING_DIR}/nanosvg_installed OR NOT ${nanosvg_installed} EQUAL 0)
endif (NOT USESYSTEMLIBS)
use_prebuilt_binary(viewer-fonts)
use_prebuilt_binary(emoji_shortcodes)
