# tiff superbuild

# Options to build from git (defaults to source zip if unset)
set(tiff-head OFF CACHE BOOL "Force building libtiff from current CVS head")

# Current stable release.
set(RELEASE_URL "http://download.osgeo.org/libtiff/tiff-4.0.8.tar.gz")
set(RELEASE_HASH "SHA512=5d010ec4ce37aca733f7ab7db9f432987b0cd21664bd9d99452a146833c40f0d1e7309d1870b0395e947964134d5cfeb1366181e761fe353ad585803ff3d6be6")

# Current development branch (defaults for head option).
set(CVS_REPOSITORY ":pserver:cvsanon@cvs.maptools.org:/cvs/maptools/cvsroot")
set(CVS_MODULE "libtiff")

# Set dependency list
ome_add_dependencies(tiff THIRD_PARTY_DEPENDENCIES zlib)

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

list(APPEND CONFIGURE_OPTIONS -Wno-dev --no-warn-unused-cli)
string(REPLACE ";" "^^" CONFIGURE_OPTIONS "${CONFIGURE_OPTIONS}")

ExternalProject_Add(${EP_PROJECT}
  ${OME_EP_COMMON_ARGS}
  ${EP_SOURCE_DOWNLOAD}
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
