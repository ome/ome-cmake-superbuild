# png superbuild

# Set dependency list
ome_add_dependencies(png zlib)

if(NOT ${CMAKE_PROJECT_NAME}_USE_SYSTEM_${EP_PROJECT})

  # Notes:
  # INSTALL_LIB_DIR overridden to use GNUInstallDirs setting
  # Installs cmake settings into lib/libpng; could be deleted

  ExternalProject_Add(${EP_PROJECT}
    ${BIOFORMATS_EP_COMMON_ARGS}
    URL "ftp://ftp.heanet.ie/mirrors/download.sourceforge.net/pub/sourceforge/l/li/libpng/libpng16/1.6.19/libpng-1.6.19.tar.xz"
    URL_HASH "SHA512=166377ce4f8abfcae0e76bafbdbe94aebef60b9a12c1820eda392e63a8ba7a9e8d7ef4840d8d4853cd487418edd2c4515a889cd9f830d4223a13315e1db4c3b8"
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
      ${EP_PROJECT}-prerequisites
    )
else()
  ome_add_empty_project(${EP_PROJECT})
endif()
