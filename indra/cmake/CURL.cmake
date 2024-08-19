# -*- cmake -*-
include(Prebuilt)

include_guard()
add_library( ll::libcurl INTERFACE IMPORTED )

if (NOT USESYSTEMLIBS)
use_system_binary(libcurl)
endif (NOT USESYSTEMLIBS)
if (LINUX OR NOT USESYSTEMLIBS)
use_prebuilt_binary(curl)
elseif (${PREBUILD_TRACKING_DIR}/sentinel_installed IS_NEWER_THAN ${PREBUILD_TRACKING_DIR}/curl_installed OR NOT ${curl_installed} EQUAL 0)
  if (NOT EXISTS ${CMAKE_BINARY_DIR}/3p-curl-7.54.1-r1.tar.gz)
    file(DOWNLOAD
      https://github.com/secondlife/3p-curl/archive/refs/tags/v7.54.1-r1.tar.gz
      ${CMAKE_BINARY_DIR}/3p-curl-7.54.1-r1.tar.gz
      )
  endif (NOT EXISTS ${CMAKE_BINARY_DIR}/3p-curl-7.54.1-r1.tar.gz)
  file(ARCHIVE_EXTRACT
    INPUT ${CMAKE_BINARY_DIR}/3p-curl-7.54.1-r1.tar.gz
    DESTINATION ${CMAKE_BINARY_DIR}
    )
  file(
    COPY
      ${CMAKE_BINARY_DIR}/3p-curl-7.54.1-r1/curl/include/curl/curl.h
      ${CMAKE_BINARY_DIR}/3p-curl-7.54.1-r1/curl/include/curl/curlbuild.h
      ${CMAKE_BINARY_DIR}/3p-curl-7.54.1-r1/curl/include/curl/curlrules.h
      ${CMAKE_BINARY_DIR}/3p-curl-7.54.1-r1/curl/include/curl/curlver.h
      ${CMAKE_BINARY_DIR}/3p-curl-7.54.1-r1/curl/include/curl/easy.h
      ${CMAKE_BINARY_DIR}/3p-curl-7.54.1-r1/curl/include/curl/mprintf.h
      ${CMAKE_BINARY_DIR}/3p-curl-7.54.1-r1/curl/include/curl/multi.h
      ${CMAKE_BINARY_DIR}/3p-curl-7.54.1-r1/curl/include/curl/stdcheaders.h
      ${CMAKE_BINARY_DIR}/3p-curl-7.54.1-r1/curl/include/curl/system.h
      ${CMAKE_BINARY_DIR}/3p-curl-7.54.1-r1/curl/include/curl/typecheck-gcc.h
    DESTINATION ${LIBS_PREBUILT_DIR}/include/curl
    )
  file(
    COPY
      ${LIBS_PREBUILT_DIR}/lib/release/libcrypto.a
      ${LIBS_PREBUILT_DIR}/lib/release/libssl.a
    DESTINATION ${LIBS_PREBUILT_DIR}/lib
    )
  message("We need to temporarily have OpenSSL3 header directory and libraries renamed just until the libcurl building process with OpenSSL1.1 now is finished.")
  if (DARWIN)
    set(ENV{CFLAGS} "-arch ${CMAKE_OSX_ARCHITECTURES} -mmacosx-version-min=10.15 -std=c90")
    execute_process(COMMAND sudo mv /opt/local/include/openssl /opt/local/include/openssl3)
    execute_process(COMMAND sudo mv /opt/local/lib/libcrypto.a /opt/local/lib/libcrypto.a.3)
    execute_process(COMMAND sudo mv /opt/local/lib/libcrypto.dylib /opt/local/lib/libcrypto.dylib.3)
    execute_process(COMMAND sudo mv /opt/local/lib/libssl.a /opt/local/lib/libssl.a.3)
    execute_process(COMMAND sudo mv /opt/local/lib/libssl.dylib /opt/local/lib/libssl.dylib.3)
    if (CMAKE_OSX_ARCHITECTURES MATCHES arm64)
      execute_process(
        COMMAND ./configure --host=aarch64-apple-darwin --disable-alt-svc --disable-dict --disable-doh --disable-file --disable-gopher --disable-headers-api --disable-hsts --disable-imap --disable-ldap --disable-ldaps --disable-libcurl-option --disable-manual --disable-mqtt --disable-ntlm --disable-ntlm-wb --disable-pop3 --disable-rtsp --disable-shared --disable-smb --disable-smtp --disable-sspi --disable-telnet --disable-tftp --disable-tls-srp --disable-unix-sockets --disable-verbose --disable-versioned-symbols --enable-threaded-resolver --with-ssl=${LIBS_PREBUILT_DIR} --without-libidn2 --without-libpsl --without-libssh2
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/3p-curl-7.54.1-r1/curl
        )
    else (CMAKE_OSX_ARCHITECTURES MATCHES arm64)
      execute_process(
        COMMAND ./configure --host=${CMAKE_OSX_ARCHITECTURES}-apple-darwin --disable-alt-svc --disable-dict --disable-doh --disable-file --disable-gopher --disable-headers-api --disable-hsts --disable-imap --disable-ldap --disable-ldaps --disable-libcurl-option --disable-manual --disable-mqtt --disable-ntlm --disable-ntlm-wb --disable-pop3 --disable-rtsp --disable-shared --disable-smb --disable-smtp --disable-sspi --disable-telnet --disable-tftp --disable-tls-srp --disable-unix-sockets --disable-verbose --disable-versioned-symbols --enable-threaded-resolver --with-ssl=${LIBS_PREBUILT_DIR} --without-libidn2 --without-libpsl --without-libssh2
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/3p-curl-7.54.1-r1/curl
        )
    endif (CMAKE_OSX_ARCHITECTURES MATCHES arm64)
  else (DARWIN)
    execute_process(COMMAND sudo mv /usr/include/openssl /usr/include/openssl3)
    execute_process(COMMAND sudo mv /usr/lib/libcrypto.a /usr/lib/libcrypto.a.3)
    execute_process(COMMAND sudo mv /usr/lib/libcrypto.so /usr/lib/libcrypto.so.3)
    execute_process(COMMAND sudo mv /usr/lib/libssl.a /usr/lib/libssl.a.3)
    execute_process(COMMAND sudo mv /usr/lib/libssl.so /usr/lib/libssl.so.3)
    execute_process(
      COMMAND ./configure --disable-alt-svc --disable-dict --disable-doh --disable-file --disable-gopher --disable-headers-api --disable-hsts --disable-imap --disable-ldap --disable-ldaps --disable-libcurl-option --disable-manual --disable-mqtt --disable-ntlm --disable-ntlm-wb --disable-pop3 --disable-rtsp --disable-shared --disable-smb --disable-smtp --disable-sspi --disable-telnet --disable-tftp --disable-tls-srp --disable-unix-sockets --disable-verbose --disable-versioned-symbols --enable-threaded-resolver --with-ssl=${LIBS_PREBUILT_DIR} --without-libidn2 --without-libpsl --without-libssh2
      WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/3p-curl-7.54.1-r1/curl
      )
  endif (DARWIN)
  execute_process(
    COMMAND make -j${MAKE_JOBS}
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/3p-curl-7.54.1-r1/curl
    RESULT_VARIABLE curl_installed
    )
  file(
    COPY ${CMAKE_BINARY_DIR}/3p-curl-7.54.1-r1/curl/lib/.libs/libcurl.a
    DESTINATION ${LIBS_PREBUILT_DIR}/lib/release
    )
  if (DARWIN)
    unset(ENV{CFLAGS})
    execute_process(COMMAND sudo mv /opt/local/include/openssl3 /opt/local/include/openssl)
    execute_process(COMMAND sudo mv /opt/local/lib/libcrypto.a.3 /opt/local/lib/libcrypto.a)
    execute_process(COMMAND sudo mv /opt/local/lib/libcrypto.dylib.3 /opt/local/lib/libcrypto.dylib)
    execute_process(COMMAND sudo mv /opt/local/lib/libssl.a.3 /opt/local/lib/libssl.a)
    execute_process(COMMAND sudo mv /opt/local/lib/libssl.dylib.3 /opt/local/lib/libssl.dylib)
  else (DARWIN)
    execute_process(COMMAND sudo mv /usr/include/openssl3 /usr/include/openssl)
    execute_process(COMMAND sudo mv /usr/lib/libcrypto.a.3 /usr/lib/libcrypto.a)
    execute_process(COMMAND sudo mv /usr/lib/libcrypto.so.3 /usr/lib/libcrypto.so)
    execute_process(COMMAND sudo mv /usr/lib/libssl.a.3 /usr/lib/libssl.a)
    execute_process(COMMAND sudo mv /usr/lib/libssl.so.3 /usr/lib/libssl.so)
  endif (DARWIN)
  message("OpenSSL3 header directory and library names have been restored.")
  file(REMOVE
    ${LIBS_PREBUILT_DIR}/lib/libcrypto.a
    ${LIBS_PREBUILT_DIR}/lib/libssl.a
    )
  file(WRITE ${PREBUILD_TRACKING_DIR}/curl_installed "${curl_installed}")
endif (LINUX OR NOT USESYSTEMLIBS)
if (WINDOWS)
  target_link_libraries(ll::libcurl INTERFACE libcurl.lib)
else (WINDOWS)
  target_link_libraries(ll::libcurl INTERFACE libcurl.a)
endif (WINDOWS)
target_include_directories( ll::libcurl SYSTEM INTERFACE ${LIBS_PREBUILT_DIR}/include)
