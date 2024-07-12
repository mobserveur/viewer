if (DARWIN)

    configure_file(
        ${CMAKE_CURRENT_SOURCE_DIR}/English.lproj/InfoPlist.strings
        ${VIEWER_APP_BUNDLE}/Contents/Resources/English.lproj/InfoPlist.strings
        )

    install(FILES
        ${CMAKE_CURRENT_SOURCE_DIR}/English.lproj/language.txt
        DESTINATION English.lproj
        )

    install(DIRECTORY
        German.lproj
        Japanese.lproj
        Korean.lproj
        app_settings
        character
        cursors_mac
        da.lproj
        es.lproj
        fonts
        fr.lproj
        uk.lproj
        hu.lproj
        it.lproj
        nl.lproj
        pl.lproj
        pt.lproj
        ru.lproj
        skins
        tr.lproj
        zh-Hans.lproj
        DESTINATION .
        )

    add_custom_command(
        OUTPUT contributors.txt
        COMMAND sed
        ARGS -e '/Linden Lab.*/d' ${CMAKE_HOME_DIRECTORY}/../doc/contributions.txt > ${CMAKE_CURRENT_BINARY_DIR}/contributions.txt
        COMMAND sed
        ARGS -i '' -e '/following residents.*/d' ${CMAKE_CURRENT_BINARY_DIR}/contributions.txt
        COMMAND sed
        ARGS -i '' -e '/along with.*/d' ${CMAKE_CURRENT_BINARY_DIR}/contributions.txt
        COMMAND sed
        ARGS -i '' -e '/^$$/d' ${CMAKE_CURRENT_BINARY_DIR}/contributions.txt
        COMMAND sed
        ARGS -i '' -e '/\t.*/d' ${CMAKE_CURRENT_BINARY_DIR}/contributions.txt
        COMMAND sed
        ARGS -i '' -e '/^    .*/d' ${CMAKE_CURRENT_BINARY_DIR}/contributions.txt
        COMMAND sort
        ARGS -R contributions.txt -o ${CMAKE_CURRENT_BINARY_DIR}/contributions.txt
        COMMAND paste
        ARGS -s -d, ${CMAKE_CURRENT_BINARY_DIR}/contributions.txt > ${CMAKE_CURRENT_BINARY_DIR}/contributors.txt
        COMMAND sed
        ARGS -i '' -e 's/,/, /g' ${CMAKE_CURRENT_BINARY_DIR}/contributors.txt
        )

    add_custom_target(contributors ALL
        DEPENDS contributors.txt
        )

    install(FILES
        SecondLife.nib
        ${AUTOBUILD_INSTALL_DIR}/ca-bundle.crt
        cube.dae
        featuretable_mac.txt
        DESTINATION .
        )

    if (NOT PACKAGE)
        install(FILES
            secondlife.icns
            RENAME ${VIEWER_CHANNEL}.icns
            DESTINATION .
            )
    endif (NOT PACKAGE)

    install(FILES
        licenses-mac.txt
        RENAME licenses.txt
        DESTINATION .
        )

    install(FILES
        ${SCRIPTS_DIR}/messages/message_template.msg
        ${SCRIPTS_DIR}/../etc/message.xml
        ${CMAKE_CURRENT_BINARY_DIR}/contributors.txt
        DESTINATION app_settings
        )

    install(DIRECTORY
        "${AUTOBUILD_INSTALL_DIR}/lib/release/Chromium Embedded Framework.framework"
        DESTINATION ../Frameworks
        )

    install(DIRECTORY
        "${AUTOBUILD_INSTALL_DIR}/lib/release/DullahanHelper.app"
        "${AUTOBUILD_INSTALL_DIR}/lib/release/DullahanHelper (GPU).app"
        "${AUTOBUILD_INSTALL_DIR}/lib/release/DullahanHelper (Plugin).app"
        "${AUTOBUILD_INSTALL_DIR}/lib/release/DullahanHelper (Renderer).app"
        DESTINATION SLPlugin.app/Contents/Frameworks
        )

    if (NDOF)
        install(FILES
            "${AUTOBUILD_INSTALL_DIR}/lib/release/libndofdev.dylib"
            DESTINATION .
            )
    endif ()

    if (PACKAGE)
        configure_file(
            ${CMAKE_CURRENT_SOURCE_DIR}/FixPackage.cmake.in
            ${CMAKE_CURRENT_BINARY_DIR}/FixBundle.cmake
            )
    else (PACKAGE)
        configure_file(
            ${CMAKE_CURRENT_SOURCE_DIR}/FixBundle.cmake.in
            ${CMAKE_CURRENT_BINARY_DIR}/FixBundle.cmake
            )
    endif (PACKAGE)
    install(SCRIPT ${CMAKE_CURRENT_BINARY_DIR}/FixBundle.cmake)

else (DARWIN)

install(PROGRAMS ${CMAKE_CURRENT_BINARY_DIR}/${VIEWER_BINARY_NAME}
        DESTINATION bin
        )

install(PROGRAMS linux_tools/launch_url.sh
        DESTINATION libexec/${VIEWER_BINARY_NAME}
        )

if (LINUX)
        if (EXISTS ${CMAKE_SYSROOT}/usr/lib/${ARCH}-linux-gnu)
                set(_LIB lib/${ARCH}-linux-gnu)
        elseif (EXISTS /lib64)
                set(_LIB lib64)
        else ()
                set(_LIB lib)
        endif ()
        install(FILES
                ${AUTOBUILD_INSTALL_DIR}/lib/release/libcef.so
                DESTINATION ${_LIB})
        if (USE_FMODSTUDIO)
            install(FILES
                ${AUTOBUILD_INSTALL_DIR}/lib/release/libfmod.so
                ${AUTOBUILD_INSTALL_DIR}/lib/release/libfmod.so.13
                ${AUTOBUILD_INSTALL_DIR}/lib/release/libfmod.so.13.22
            DESTINATION ${_LIB})
        endif (USE_FMODSTUDIO)
        install(PROGRAMS
                ${AUTOBUILD_INSTALL_DIR}/bin/release/chrome-sandbox
                DESTINATION libexec/${VIEWER_BINARY_NAME}
                #PERMISSIONS SETUID OWNER_READ OWNER_WRITE OWNER_EXECUTE
                #GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE
        )
        install(PROGRAMS
                ${AUTOBUILD_INSTALL_DIR}/bin/release/dullahan_host
                DESTINATION libexec/${VIEWER_BINARY_NAME})
        install(FILES
                ${AUTOBUILD_INSTALL_DIR}/bin/release/snapshot_blob.bin
                ${AUTOBUILD_INSTALL_DIR}/bin/release/v8_context_snapshot.bin
                DESTINATION ${_LIB})
        install(FILES
                ${AUTOBUILD_INSTALL_DIR}/resources/chrome_100_percent.pak
                ${AUTOBUILD_INSTALL_DIR}/resources/chrome_200_percent.pak
                ${AUTOBUILD_INSTALL_DIR}/resources/icudtl.dat
                ${AUTOBUILD_INSTALL_DIR}/resources/resources.pak
                DESTINATION ${_LIB})
        install(DIRECTORY
                ${AUTOBUILD_INSTALL_DIR}/resources/locales
                DESTINATION ${_LIB})
endif (LINUX)

install(DIRECTORY skins app_settings fonts
        DESTINATION share/${VIEWER_BINARY_NAME}
        PATTERN ".svn" EXCLUDE
        )

install(DIRECTORY icons/hicolor
        DESTINATION share/icons
        )

find_file(IS_ARTWORK_PRESENT NAMES have_artwork_bundle.marker
          PATHS ${VIEWER_DIR}/newview/res)

if (IS_ARTWORK_PRESENT)
  install(DIRECTORY res res-sdl character
          DESTINATION share/${VIEWER_BINARY_NAME}
          PATTERN ".svn" EXCLUDE
          )
else (IS_ARTWORK_PRESENT)
  message(STATUS "WARNING: Artwork is not present, and will not be installed")
endif (IS_ARTWORK_PRESENT)

    install(FILES
        ${AUTOBUILD_INSTALL_DIR}/ca-bundle.crt
        featuretable_linux.txt
        #featuretable_solaris.txt
        DESTINATION share/${VIEWER_BINARY_NAME}
        )

    install(FILES
        licenses-linux.txt
        RENAME licenses.txt
        DESTINATION share/${VIEWER_BINARY_NAME}
        )

install(FILES ${SCRIPTS_DIR}/messages/message_template.msg
        ${SCRIPTS_DIR}/../etc/message.xml
        DESTINATION share/${VIEWER_BINARY_NAME}/app_settings
        )

    install(FILES linux_tools/${VIEWER_BINARY_NAME}.desktop
        DESTINATION share/applications
        )

endif (DARWIN)
