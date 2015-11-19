# png superbuild

# Set dependency list
ome_add_dependencies(png zlib)

if(${CMAKE_PROJECT_NAME}_USE_SYSTEM_${EP_PROJECT})
  unset(png_DIR CACHE)
  find_package(PNG REQUIRED)
endif()

if(NOT ${CMAKE_PROJECT_NAME}_USE_SYSTEM_${EP_PROJECT})

  # Notes:
  # Installs cmake settings into lib/libpng; could be deleted

  set(CONFIGURE_OPTIONS -Wno-dev --no-warn-unused-cli)
  string(REPLACE ";" "^^" CONFIGURE_OPTIONS "${CONFIGURE_OPTIONS}")

  ExternalProject_Add(${EP_PROJECT}
    ${BIOFORMATS_EP_COMMON_ARGS}
    URL "ftp://ftp.heanet.ie/mirrors/download.sourceforge.net/pub/sourceforge/l/li/libpng/libpng16/1.6.19/libpng-1.6.19.tar.xz"
    URL_HASH "SHA512=166377ce4f8abfcae0e76bafbdbe94aebef60b9a12c1820eda392e63a8ba7a9e8d7ef4840d8d4853cd487418edd2c4515a889cd9f830d4223a13315e1db4c3b8"
    SOURCE_DIR "${EP_SOURCE_DIR}"
    BINARY_DIR "${EP_BINARY_DIR}"
    INSTALL_DIR ""
    CONFIGURE_COMMAND ${CMAKE_COMMAND}
      "-DSOURCE_DIR:PATH=${EP_SOURCE_DIR}"
      "-DBUILD_DIR:PATH=${EP_BINARY_DIR}"
      "-DCONFIG:INTERNAL=$<CONFIG>"
      "-DEP_SCRIPT_CONFIG:FILEPATH=${EP_SCRIPT_CONFIG}"
      "-DCONFIGURE_OPTIONS=${CONFIGURE_OPTIONS}"
      -P "${GENERIC_CMAKE_CONFIGURE}"
    BUILD_COMMAND ${CMAKE_COMMAND}
      "-DSOURCE_DIR:PATH=${EP_SOURCE_DIR}"
      "-DBUILD_DIR:PATH=${EP_BINARY_DIR}"
      "-DCONFIG:INTERNAL=$<CONFIG>"
      "-DEP_SCRIPT_CONFIG:FILEPATH=${EP_SCRIPT_CONFIG}"
      -P "${GENERIC_CMAKE_BUILD}"
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
    DEPENDS
      ${EP_PROJECT}-prerequisites
    )
else()
  ExternalProject_Add_Empty(${EP_PROJECT} DEPENDS ${png_DEPENDENCIES})
endif()
