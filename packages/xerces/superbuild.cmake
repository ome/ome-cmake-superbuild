# xerces superbuild

# Set dependency list
ome_add_dependencies(xerces icu)

if(NOT ${CMAKE_PROJECT_NAME}_USE_SYSTEM_${EP_PROJECT})
  set(EP_CXXFLAGS ${CMAKE_CXX_FLAGS})
  set(EP_LDFLAGS ${CMAKE_SHARED_LINKER_FLAGS})
  if(WIN32)
    # Windows compiler flags
  else()
    set(EP_CXXFLAGS ${EP_CXXFLAGS} \"-I${BIOFORMATS_EP_INCLUDE_DIR}\")
    set(EP_LDFLAGS ${EP_LDFLAGS} \"-L${BIOFORMATS_EP_LIB_DIR}\")
  endif()

  # Notes:
  # Builds xerces without Xerces.Python (not currently used by Bio-Formats)

  ExternalProject_Add(${EP_PROJECT}
    ${BIOFORMATS_EP_COMMON_ARGS}
    URL "http://www.apache.org/dist/xerces/c/3/sources/xerces-c-3.1.3.tar.xz"
    URL_HASH "SHA512=9931fbf2c91ba2dcb36e5909486c9fc7532420d6f692b1bb24fc93abf3cc67fbd3c9e2ffd443645c93013634000e0bca3ac2ba7ff298d4f5324db9d4d1340600"
    SOURCE_DIR "${EP_SOURCE_DIR}"
    BINARY_DIR "${EP_BINARY_DIR}"
    INSTALL_DIR ""
    PATCH_COMMAND ${CMAKE_COMMAND} -E copy_directory
      "${CMAKE_CURRENT_LIST_DIR}/files"
      "${EP_SOURCE_DIR}"
    CONFIGURE_COMMAND
      ${CMAKE_COMMAND}
      "-DSOURCE_DIR:PATH=${EP_SOURCE_DIR}"
      "-DBUILD_DIR:PATH=${EP_BINARY_DIR}"
      "-DCONFIG:INTERNAL=$<CONFIG>"
      "-DEP_SCRIPT_CONFIG:FILEPATH=${EP_SCRIPT_CONFIG}"
      -P ${CMAKE_CURRENT_LIST_DIR}/configure.cmake
    BUILD_COMMAND ${CMAKE_COMMAND}
      "-DSOURCE_DIR:PATH=${EP_SOURCE_DIR}"
      "-DBUILD_DIR:PATH=${EP_BINARY_DIR}"
      "-DCONFIG:INTERNAL=$<CONFIG>"
      "-DEP_SCRIPT_CONFIG:FILEPATH=${EP_SCRIPT_CONFIG}"
      -P "${CMAKE_CURRENT_LIST_DIR}/build.cmake"
    INSTALL_COMMAND ${CMAKE_COMMAND}
      "-DSOURCE_DIR:PATH=${EP_SOURCE_DIR}"
      "-DBUILD_DIR:PATH=${EP_BINARY_DIR}"
      "-DCONFIG:INTERNAL=$<CONFIG>"
      "-DEP_SCRIPT_CONFIG:FILEPATH=${EP_SCRIPT_CONFIG}"
      -P "${CMAKE_CURRENT_LIST_DIR}/install.cmake"
    DEPENDS
      ${EP_PROJECT}-prerequisites
    )
else()
  ome_add_empty_project(${EP_PROJECT})
endif()

