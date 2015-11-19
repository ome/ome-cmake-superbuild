# bzip2 superbuild

# Set dependency list
ome_add_dependencies(bzip2)

if(NOT ${CMAKE_PROJECT_NAME}_USE_SYSTEM_${EP_PROJECT})

  # Notes: Using custom CMake build for bzip2; this has been submitted
  # upstream and may be included in a future release.  If so, the
  # files copied in the patch step may be dropped.

  ExternalProject_Add(${EP_PROJECT}
    ${BIOFORMATS_EP_COMMON_ARGS}
    URL "http://bzip.org/1.0.6/bzip2-1.0.6.tar.gz"
    URL_HASH "SHA512=00ace5438cfa0c577e5f578d8a808613187eff5217c35164ffe044fbafdfec9e98f4192c02a7d67e01e5a5ccced630583ad1003c37697219b0f147343a3fdd12"
    SOURCE_DIR "${EP_SOURCE_DIR}"
    BINARY_DIR "${EP_BINARY_DIR}"
    INSTALL_DIR ""
    PATCH_COMMAND ${CMAKE_COMMAND} -E copy_directory
      "${CMAKE_CURRENT_LIST_DIR}/files"
      "${EP_SOURCE_DIR}"
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
      -P "${GENERIC_CMAKE_INSTALL}"
    ${cmakeversion_external_update} "${cmakeversion_external_update_value}"
    CMAKE_ARGS
      -Wno-dev --no-warn-unused-cli
      "-DINSTALL_LIB_DIR=/${CMAKE_INSTALL_LIBDIR}"
    CMAKE_CACHE_ARGS
    DEPENDS
      ${EP_PROJECT}-prerequisites
    )
else()
  ome_add_empty_project(${EP_PROJECT})
endif()

