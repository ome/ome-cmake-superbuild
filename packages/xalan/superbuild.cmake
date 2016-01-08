# xalan superbuild

# Set dependency list
ome_add_dependencies(xalan THIRD_PARTY_DEPENDENCIES xerces icu)

if(NOT ${CMAKE_PROJECT_NAME}_USE_SYSTEM_${EP_PROJECT})
  set(EP_CXXFLAGS ${CMAKE_CXX_FLAGS})
  set(EP_LDFLAGS ${CMAKE_SHARED_LINKER_FLAGS})
  if(WIN32)
    # Windows compiler flags
  else()
    set(EP_CXXFLAGS ${EP_CXXFLAGS} \"-I${OME_EP_INCLUDE_DIR}\")
    set(EP_LDFLAGS ${EP_LDFLAGS} \"-L${OME_EP_LIB_DIR}\")
  endif()

  set(EP_BINARY_DIR "${EP_SOURCE_DIR}/c")

  ExternalProject_Add(${EP_PROJECT}
    ${OME_EP_COMMON_ARGS}
    URL "http://www.apache.org/dist/xalan/xalan-c/sources/xalan_c-1.11-src.tar.gz"
    URL_HASH "SHA512=7e45559119d88ab95fc97d8c83b0ea92c4f61540afeee18a84f2ef529c7de3be52156ddf8966288ccc16e9a635b5a7f49eb7095f79c95793ddbd0974983d1f83"
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
