# tiff superbuild

# Options to build from git (defaults to source zip if unset)
set(tiff-head OFF CACHE BOOL "Force building libtiff from current CVS head")

# Current stable release.
set(RELEASE_URL "ftp://ftp.remotesensing.org/pub/libtiff/tiff-4.0.6.tar.gz")
set(RELEASE_HASH "SHA512=2c8dbaaaab9f82a7722bfe8cb6fcfcf67472beb692f1b7dafaf322759e7016dad1bc58457c0f03db50aa5bd088fef2b37358fcbc1524e20e9e14a9620373fdf8")

# Current development branch (defaults for head option).
set(CVS_REPOSITORY ":pserver:cvsanon@cvs.maptools.org:/cvs/maptools/cvsroot")
set(CVS_MODULE "libtiff")

# Set dependency list
ome_add_dependencies(tiff zlib)

if(NOT ${CMAKE_PROJECT_NAME}_USE_SYSTEM_${EP_PROJECT})

  if(tiff-head)
    set(EP_SOURCE_DOWNLOAD
      CVS_REPOSITORY "${CVS_REPOSITORY}"
      CVS_MODULE "${CVS_MODULE}")
    message(STATUS "Building libtiff from CVS (URL ${CVS_REPOSITORY}, module ${CVS_MODULE})")
  else()
    set(EP_SOURCE_DOWNLOAD
      URL "${RELEASE_URL}"
      URL_HASH "${RELEASE_HASH}")
  endif()

  # Notes: Using custom CMake build for tiff; this has been submitted
  # upstream and may be included in a future release.  If so, the
  # files copied in the patch step may be dropped.

  ExternalProject_Add(${EP_PROJECT}
    ${BIOFORMATS_EP_COMMON_ARGS}
    ${EP_SOURCE_DOWNLOAD}
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
      "-DINSTALL_LIB_DIR=/${CMAKE_INSTALL_LIBDIR}"
    CMAKE_CACHE_ARGS
    DEPENDS
      ${EP_PROJECT}-prerequisites
    )
else()
  ome_add_empty_project(${EP_PROJECT})
endif()

