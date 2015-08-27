# tiff superbuild
set(proj tiff)

# Options to build from git (defaults to source zip if unset)
set(tiff-head OFF CACHE BOOL "Force building libtiff from current CVS head")

# Current stable release.
set(RELEASE_URL "ftp://ftp.remotesensing.org/pub/libtiff/tiff-4.0.4.tar.gz")
set(RELEASE_HASH "SHA512=4c83f8d7c10224c481c58721044813056b6fbc44c94b1b94a35d2f829bf4a89d35edd878e40e4d8579fd04b889edab946c95b0dc04b090794d1bd9120a79882b")

# Current development branch (defaults for head option).
set(CVS_REPOSITORY ":pserver:cvsanon@cvs.maptools.org:/cvs/maptools/cvsroot")
set(CVS_MODULE "libtiff")

# Set dependency list
set(tiff_DEPENDENCIES zlib)

if(${CMAKE_PROJECT_NAME}_USE_SYSTEM_${proj})
  unset(tiff_DIR CACHE)
  find_package(TIFF REQUIRED)
endif()

if(NOT ${CMAKE_PROJECT_NAME}_USE_SYSTEM_${proj})
  set(EP_SOURCE_DIR ${CMAKE_BINARY_DIR}/${proj}-source)
  set(EP_BINARY_DIR ${CMAKE_BINARY_DIR}/${proj}-build)

  if(tiff-head)
    set(EP_SOURCE_DOWNLOAD
      CVS_REPOSITORY "${CVS_REPOSITORY}"
      CVS_MODULE "${CVS_MODULE}")
    message(STATUS "Building libtiff from CVS (URL ${CVS_REPOSITORY}, module ${CVS_MODULE})")
  else()
    set(EP_SOURCE_DOWNLOAD
      URL "${RELEASE_URL}"
      URL_HASH "${RELEASE_HASH}")
    set(PATCH_COMMAND
        PATCH_COMMAND ${CMAKE_COMMAND} -E copy_directory
          "${CMAKE_CURRENT_LIST_DIR}/files"
          "${EP_SOURCE_DIR}")
    message(STATUS "Building libtiff from source release (${RELEASE_URL})")
  endif()

  # Notes: Using custom CMake build for tiff; this has been submitted
  # upstream and may be included in a future release.  If so, the
  # files copied in the patch step may be dropped.

  ExternalProject_Add(${proj}
    ${BIOFORMATS_EP_COMMON_ARGS}
    ${EP_SOURCE_DOWNLOAD}
    SOURCE_DIR "${EP_SOURCE_DIR}"
    BINARY_DIR "${EP_BINARY_DIR}"
    INSTALL_DIR ""
    ${PATCH_COMMAND}
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
      ${tiff_DEPENDENCIES}
    )
else()
  ExternalProject_Add_Empty(${proj} DEPENDS ${tiff_DEPENDENCIES})
endif()

