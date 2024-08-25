# -*- cmake -*-
include(Prebuilt)

include_guard()
add_library( ll::openssl INTERFACE IMPORTED )

if (NOT USESYSTEMLIBS)
use_system_binary(openssl)
endif (NOT USESYSTEMLIBS)
if (DARWIN OR LINUX OR NOT USESYSTEMLIBS)
use_prebuilt_binary(openssl)
  if (DARWIN)
    execute_process(
      COMMAND lipo -archs libcrypto.a
      WORKING_DIRECTORY ${LIBS_PREBUILT_DIR}/lib/release
      OUTPUT_VARIABLE crypto_archs
      OUTPUT_STRIP_TRAILING_WHITESPACE
      )
    if (NOT ${crypto_archs} STREQUAL ${CMAKE_OSX_ARCHITECTURES})
      execute_process(
        COMMAND lipo
          libcrypto.a
          -thin ${CMAKE_OSX_ARCHITECTURES}
          -output libcrypto.a
        WORKING_DIRECTORY ${LIBS_PREBUILT_DIR}/lib/release
        )
    endif (NOT ${crypto_archs} STREQUAL ${CMAKE_OSX_ARCHITECTURES})
    execute_process(
      COMMAND lipo -archs libssl.a
      WORKING_DIRECTORY ${LIBS_PREBUILT_DIR}/lib/release
      OUTPUT_VARIABLE ssl_archs
      OUTPUT_STRIP_TRAILING_WHITESPACE
      )
    if (NOT ${ssl_archs} STREQUAL ${CMAKE_OSX_ARCHITECTURES})
      execute_process(
        COMMAND lipo
          libssl.a
          -thin ${CMAKE_OSX_ARCHITECTURES}
          -output libssl.a
        WORKING_DIRECTORY ${LIBS_PREBUILT_DIR}/lib/release
        )
    endif (NOT ${ssl_archs} STREQUAL ${CMAKE_OSX_ARCHITECTURES})
  endif (DARWIN)
elseif (${PREBUILD_TRACKING_DIR}/sentinel_installed IS_NEWER_THAN ${PREBUILD_TRACKING_DIR}/openssl_installed OR NOT ${openssl_installed} EQUAL 0)
  if (NOT EXISTS ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55.tar.gz)
    file(DOWNLOAD
      https://github.com/secondlife/3p-openssl/archive/refs/tags/v1.1.1q.de53f55.tar.gz
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55.tar.gz
      )
  endif (NOT EXISTS ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55.tar.gz)
  file(ARCHIVE_EXTRACT
    INPUT ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55.tar.gz
    DESTINATION ${CMAKE_BINARY_DIR}
    )
  execute_process(
    COMMAND ./config no-shared
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl
    )
  execute_process(
    COMMAND make -j${MAKE_JOBS}
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl
    RESULT_VARIABLE openssl_installed
    )
  file(
    COPY
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/aes.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/bnerr.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/conf_api.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/dtls1.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/evperr.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/obj_mac.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/pkcs12.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/rsa.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/stack.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/x509.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/asn1.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/buffer.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/conferr.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/e_os2.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/hmac.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/objects.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/pkcs12err.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/rsaerr.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/store.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/x509_vfy.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/asn1_mac.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/buffererr.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/crypto.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/ebcdic.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/idea.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/objectserr.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/pkcs7.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/safestack.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/storeerr.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/x509err.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/asn1err.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/camellia.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/cryptoerr.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/ec.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/kdf.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/ocsp.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/pkcs7err.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/seed.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/symhacks.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/x509v3.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/asn1t.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/cast.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/ct.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/ecdh.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/kdferr.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/ocsperr.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/rand.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/sha.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/tls1.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/x509v3err.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/async.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/cmac.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/cterr.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/ecdsa.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/lhash.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/opensslconf.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/rand_drbg.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/srp.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/ts.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/asyncerr.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/cms.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/des.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/ecerr.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/md2.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/opensslv.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/randerr.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/srtp.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/tserr.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/bio.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/cmserr.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/dh.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/engine.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/md4.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/ossl_typ.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/rc2.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/ssl.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/txt_db.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/bioerr.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/comp.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/dherr.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/engineerr.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/md5.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/pem.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/rc4.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/ssl2.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/ui.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/blowfish.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/comperr.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/dsa.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/err.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/mdc2.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/pem2.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/rc5.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/ssl3.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/uierr.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/bn.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/conf.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/dsaerr.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/evp.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/modes.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/pemerr.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/ripemd.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/sslerr.h
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/include/openssl/whrlpool.h
    DESTINATION ${LIBS_PREBUILT_DIR}/include/openssl
    )
  file(
    COPY
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/libcrypto.a
      ${CMAKE_BINARY_DIR}/3p-openssl-1.1.1q.de53f55/openssl/libssl.a
    DESTINATION ${LIBS_PREBUILT_DIR}/lib/release
    )
  file(WRITE ${PREBUILD_TRACKING_DIR}/openssl_installed "${openssl_installed}")
endif (DARWIN OR LINUX OR NOT USESYSTEMLIBS)
if (WINDOWS)
  target_link_libraries(ll::openssl INTERFACE libssl libcrypto)
elseif (LINUX)
  target_link_libraries(ll::openssl INTERFACE ssl crypto dl)
else()
  target_link_libraries(ll::openssl INTERFACE ssl crypto)
endif (WINDOWS)
target_include_directories( ll::openssl SYSTEM INTERFACE ${LIBS_PREBUILT_DIR}/include)

