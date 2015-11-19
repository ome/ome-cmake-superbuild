# icu superbuild

# Set dependency list
ome_add_dependencies(icu)

if(NOT ${CMAKE_PROJECT_NAME}_USE_SYSTEM_${EP_PROJECT})
  set(EP_CXXFLAGS ${CMAKE_CXX_FLAGS})
  set(EP_LDFLAGS ${CMAKE_SHARED_LINKER_FLAGS})
  if(WIN32)
    # Windows compiler flags
  else()
    set(EP_CXXFLAGS ${EP_CXXFLAGS} \"-I${BIOFORMATS_EP_INCLUDE_DIR}\")
    set(EP_LDFLAGS ${EP_LDFLAGS} \"-L${BIOFORMATS_EP_LIB_DIR}\")
  endif()

  if(NOT MSVC)
    set(ICU_PATCH)
  # VS 10.0
  elseif(NOT MSVC_VERSION VERSION_LESS 1600 AND MSVC_VERSION VERSION_LESS 1700)
    set(ICU_PATCH)
  # VS 11.0
  elseif(NOT MSVC_VERSION VERSION_LESS 1700 AND MSVC_VERSION VERSION_LESS 1800)
    set(ICU_PATCH PATCH_COMMAND "${CMAKE_COMMAND}" -E copy_directory
        "${CMAKE_CURRENT_LIST_DIR}/files/VC11"
        "${EP_SOURCE_DIR}")
  # VS 12.0
  elseif(NOT MSVC_VERSION VERSION_LESS 1800 AND MSVC_VERSION VERSION_LESS 1900)
    set(ICU_PATCH PATCH_COMMAND "${CMAKE_COMMAND}" -E copy_directory
        "${CMAKE_CURRENT_LIST_DIR}/files/VC12"
        "${EP_SOURCE_DIR}")
  # VS 14.0
  elseif(NOT MSVC_VERSION VERSION_LESS 1900 AND MSVC_VERSION VERSION_LESS 2000)
    message(FATAL_ERROR "VS14 not yet supported")
  else()
    message(FATAL_ERROR "VS version not supported")
  endif()

  # Notes:
  # Patches solution/projects for VS2012 and VS2013

  ExternalProject_Add(${EP_PROJECT}
    ${BIOFORMATS_EP_COMMON_ARGS}
    URL "http://download.icu-project.org/files/icu4c/55.1/icu4c-55_1-src.tgz"
    URL_HASH "SHA512=21a3eb2c3678cd27b659eed073f8f1bd99c9751291d077820e9a370fd90b7d9b3bf414cc03dec4acb7fa61087e02d04f9f40e91a32c5180c718e2102fbd0cd35"
    SOURCE_DIR "${EP_SOURCE_DIR}"
    BINARY_DIR "${EP_BINARY_DIR}"
    INSTALL_DIR ""
    ${ICU_PATCH}
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
    ${cmakeversion_external_update} "${cmakeversion_external_update_value}"
    DEPENDS
      ${EP_PROJECT}-prerequisites
    )
else()
  ome_add_empty_project(${EP_PROJECT})
endif()
