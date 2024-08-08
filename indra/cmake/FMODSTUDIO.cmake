# -*- cmake -*-

include_guard()

# FMODSTUDIO can be set when launching the make using the argument -DUSE_FMODSTUDIO:BOOL=ON
# When building using proprietary binaries though (i.e. having access to LL private servers),
# we always build with FMODSTUDIO.
if (INSTALL_PROPRIETARY)
  set(USE_FMODSTUDIO ON CACHE BOOL "Using FMODSTUDIO sound library.")
endif (INSTALL_PROPRIETARY)

# ND: To streamline arguments passed, switch from FMODSTUDIO to USE_FMODSTUDIO
# To not break all old build scripts convert old arguments but warn about it
if(FMODSTUDIO)
  message( WARNING "Use of the FMODSTUDIO argument is deprecated, please switch to USE_FMODSTUDIO")
  set(USE_FMODSTUDIO ${FMODSTUDIO})
endif()

if (USE_FMODSTUDIO)
  add_library( ll::fmodstudio INTERFACE IMPORTED )
  target_compile_definitions( ll::fmodstudio INTERFACE LL_FMODSTUDIO=1)

  if (FMODSTUDIO_LIBRARY AND FMODSTUDIO_INCLUDE_DIR)
    # If the path have been specified in the arguments, use that

    target_link_libraries(ll::fmodstudio INTERFACE ${FMODSTUDIO_LIBRARY})
    target_include_directories( ll::fmodstudio SYSTEM INTERFACE  ${FMODSTUDIO_INCLUDE_DIR})
  else (FMODSTUDIO_LIBRARY AND FMODSTUDIO_INCLUDE_DIR)
    # If not, we're going to try to get the package listed in autobuild.xml
    # Note: if you're not using INSTALL_PROPRIETARY, the package URL should be local (file:/// URL)
    # as accessing the private LL location will fail if you don't have the credential
    include(Prebuilt)
    if (USESYSTEMLIBS)
      if (DARWIN)
        execute_process(
          COMMAND hdiutil attach -noverify $ENV{HOME}/Downloads/fmodstudioapi20223mac-installer.dmg
          COMMAND mkdir -p ${AUTOBUILD_INSTALL_DIR}/include/fmodstudio
          COMMAND mkdir -p ${AUTOBUILD_INSTALL_DIR}/lib/release
          )
        execute_process(
          COMMAND cp
            /Volumes/FMOD\ Programmers\ API\ Mac/FMOD\ Programmers\ API/api/core/inc/fmod.h
            /Volumes/FMOD\ Programmers\ API\ Mac/FMOD\ Programmers\ API/api/core/inc/fmod.hpp
            /Volumes/FMOD\ Programmers\ API\ Mac/FMOD\ Programmers\ API/api/core/inc/fmod_codec.h
            /Volumes/FMOD\ Programmers\ API\ Mac/FMOD\ Programmers\ API/api/core/inc/fmod_common.h
            /Volumes/FMOD\ Programmers\ API\ Mac/FMOD\ Programmers\ API/api/core/inc/fmod_dsp.h
            /Volumes/FMOD\ Programmers\ API\ Mac/FMOD\ Programmers\ API/api/core/inc/fmod_dsp_effects.h
            /Volumes/FMOD\ Programmers\ API\ Mac/FMOD\ Programmers\ API/api/core/inc/fmod_errors.h
            /Volumes/FMOD\ Programmers\ API\ Mac/FMOD\ Programmers\ API/api/core/inc/fmod_output.h
            ${AUTOBUILD_INSTALL_DIR}/include/fmodstudio/
          COMMAND cp /Volumes/FMOD\ Programmers\ API\ Mac/FMOD\ Programmers\ API/api/core/lib/libfmod.dylib ${AUTOBUILD_INSTALL_DIR}/lib/release/
          )
        execute_process(
          COMMAND hdiutil detach /Volumes/FMOD\ Programmers\ API\ Mac
          WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
          RESULT_VARIABLE ${_binary}_installed
          )
      else (DARWIN)
        execute_process(
          COMMAND tar -xf $ENV{HOME}/Downloads/fmodstudioapi20223linux.tar.gz -C /tmp
          COMMAND mkdir -p ${AUTOBUILD_INSTALL_DIR}/include/fmodstudio
          )
        execute_process(
          COMMAND cp
            /tmp/fmodstudioapi20223linux/api/core/inc/fmod.h
            /tmp/fmodstudioapi20223linux/api/core/inc/fmod.hpp
            /tmp/fmodstudioapi20223linux/api/core/inc/fmod_codec.h
            /tmp/fmodstudioapi20223linux/api/core/inc/fmod_common.h
            /tmp/fmodstudioapi20223linux/api/core/inc/fmod_dsp.h
            /tmp/fmodstudioapi20223linux/api/core/inc/fmod_dsp_effects.h
            /tmp/fmodstudioapi20223linux/api/core/inc/fmod_errors.h
            /tmp/fmodstudioapi20223linux/api/core/inc/fmod_output.h
            ${AUTOBUILD_INSTALL_DIR}/include/fmodstudio/
          COMMAND cp -P
            /tmp/fmodstudioapi20223linux/api/core/lib/${CMAKE_SYSTEM_PROCESSOR}/libfmod.so
            /tmp/fmodstudioapi20223linux/api/core/lib/${CMAKE_SYSTEM_PROCESSOR}/libfmod.so.13
            /tmp/fmodstudioapi20223linux/api/core/lib/${CMAKE_SYSTEM_PROCESSOR}/libfmod.so.13.23
            ${AUTOBUILD_INSTALL_DIR}/lib/release/
          )
        execute_process(
          COMMAND rm -rf /tmp/fmodstudioapi20223linux
          WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
          RESULT_VARIABLE ${_binary}_installed
          )
      endif (DARWIN)
    else (USESYSTEMLIBS)
    use_prebuilt_binary(fmodstudio)
    endif (USESYSTEMLIBS)
    if (WINDOWS)
      target_link_libraries( ll::fmodstudio INTERFACE  fmod_vc)
    elseif (DARWIN)
      #despite files being called libfmod.dylib, we are searching for fmod
      target_link_libraries( ll::fmodstudio INTERFACE  fmod)
    elseif (LINUX)
      target_link_libraries( ll::fmodstudio INTERFACE  fmod)
    endif (WINDOWS)

    target_include_directories( ll::fmodstudio SYSTEM INTERFACE ${LIBS_PREBUILT_DIR}/include/fmodstudio)
  endif (FMODSTUDIO_LIBRARY AND FMODSTUDIO_INCLUDE_DIR)
else()
  set( USE_FMODSTUDIO "OFF")
endif ()

