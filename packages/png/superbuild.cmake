# png superbuild

# Set dependency list
ome_add_dependencies(png zlib)

if(${CMAKE_PROJECT_NAME}_USE_SYSTEM_${EP_PROJECT})
  unset(png_DIR CACHE)
  find_package(PNG REQUIRED)
endif()

if(NOT ${CMAKE_PROJECT_NAME}_USE_SYSTEM_${EP_PROJECT})

  # Notes:
  # INSTALL_LIB_DIR overridden to use GNUInstallDirs setting
  # Installs cmake settings into lib/libpng; could be deleted

  ExternalProject_Add(${EP_PROJECT}
    ${BIOFORMATS_EP_COMMON_ARGS}
    URL "ftp://ftp.heanet.ie/mirrors/download.sourceforge.net/pub/sourceforge/l/li/libpng/libpng16/1.6.17/libpng-1.6.17.tar.xz"
    URL_HASH "SHA512=f22a48b355adea197a2d79f90ccc6b3edef2b5e8f6fb17319bd38652959126bbecb9442fd95e5147a894484446e87e535667fbfcf3b1e901b8375e5bb00a3bf3"
    SOURCE_DIR "${EP_SOURCE_DIR}"
    BINARY_DIR "${EP_BINARY_DIR}"
    INSTALL_DIR ""
    INSTALL_COMMAND ${CMAKE_COMMAND}
      "-DSOURCE_DIR:PATH=${EP_SOURCE_DIR}"
      "-DBUILD_DIR:PATH=${EP_BINARY_DIR}"
      "-DCONFIG:INTERNAL=$<CONFIG>"
      "-DEP_SCRIPT_CONFIG:FILEPATH=${EP_SCRIPT_CONFIG}"
      -P "${GENERIC_CMAKE_INSTALL}"
    TEST_COMMAND ${CMAKE_COMMAND}
      "-DSOURCE_DIR:PATH=${EP_SOURCE_DIR}"
      "-DBUILD_DIR:PATH=${EP_BINARY_DIR}"
      "-DCONFIG:INTERNAL=$<CONFIG>"
      "-DEP_SCRIPT_CONFIG:FILEPATH=${EP_SCRIPT_CONFIG}"
      -P "${GENERIC_CMAKE_TEST}"
    ${cmakeversion_external_update} "${cmakeversion_external_update_value}"
    CMAKE_ARGS
      -Wno-dev --no-warn-unused-cli
    DEPENDS
      ${png_DEPENDENCIES}
    )
else()
  ExternalProject_Add_Empty(${EP_PROJECT} DEPENDS ${png_DEPENDENCIES})
endif()
