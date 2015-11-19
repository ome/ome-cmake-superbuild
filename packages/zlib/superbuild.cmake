# zlib superbuild

# Set dependency list
ome_add_dependencies(zlib)

if(NOT ${CMAKE_PROJECT_NAME}_USE_SYSTEM_${EP_PROJECT})

  # Notes:
  # INSTALL_LIB_DIR overridden to use GNUInstallDirs setting
  if (CMAKE_GENERATOR MATCHES "Unix Makefiles")
    set(ZLIB_OPTIONS "-DINSTALL_LIB_DIR=/${CMAKE_INSTALL_LIBDIR}")
  else()
    set(ZLIB_OPTIONS "-DINSTALL_LIB_DIR=${BIOFORMATS_EP_INSTALL_DIR}/${CMAKE_INSTALL_LIBDIR}")
  endif()

  ExternalProject_Add(${EP_PROJECT}
    ${BIOFORMATS_EP_COMMON_ARGS}
    URL "ftp://ftp.heanet.ie/mirrors/download.sourceforge.net/pub/sourceforge/l/li/libpng/zlib/1.2.8/zlib-1.2.8.tar.xz"
    URL_HASH "SHA512=405fbb4fc9ca8a59f34488205f403e77d4f184b08d344efbec6a8f558cac0512ee6cda1dc01b7913d61d9bed04cc710e61db1081bb8782c139fcb727f586fa54"
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
      ${ZLIB_OPTIONS}
    CMAKE_CACHE_ARGS
    DEPENDS
      ${EP_PROJECT}-prerequisites
    )
else()
  ome_add_empty_project(${EP_PROJECT})
endif()

