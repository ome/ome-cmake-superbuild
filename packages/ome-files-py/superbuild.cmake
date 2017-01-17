# ome-files superbuild

# Source information
ome_source_settings(ome-files-py
  NAME            "OME Files Python"
  GIT_NAME        "ome-files-py"
  GIT_URL         "https://github.com/ome/ome-files-py.git"
  GIT_HEAD_BRANCH "master"
  RELEASE_URL     ""
  RELEASE_HASH    "")

# Set dependency list
ome_add_dependencies(ome-files-py
                     DEPENDENCIES ome-files
                     THIRD_PARTY_DEPENDENCIES boost)


ExternalProject_Add(${EP_PROJECT}
  ${OME_EP_COMMON_ARGS}
  ${EP_SOURCE_DOWNLOAD}
  SOURCE_DIR "${EP_SOURCE_DIR}"
  BINARY_DIR "${EP_BINARY_DIR}"
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ${CMAKE_COMMAND}
    "-DSOURCE_DIR:PATH=${EP_SOURCE_DIR}"
    "-DBUILD_DIR:PATH=${EP_BINARY_DIR}"
    "-DCONFIG:INTERNAL=$<CONFIG>"
    "-DEP_SCRIPT_CONFIG:FILEPATH=${EP_SCRIPT_CONFIG}"
    -P "${CMAKE_CURRENT_LIST_DIR}/build.cmake"
  INSTALL_DIR ""
  INSTALL_COMMAND ${CMAKE_COMMAND}
    "-DSOURCE_DIR:PATH=${EP_SOURCE_DIR}"
    "-DBUILD_DIR:PATH=${EP_BINARY_DIR}"
    "-DCONFIG:INTERNAL=$<CONFIG>"
    "-DEP_SCRIPT_CONFIG:FILEPATH=${EP_SCRIPT_CONFIG}"
    -P "${CMAKE_CURRENT_LIST_DIR}/install.cmake"
  TEST_COMMAND ${CMAKE_COMMAND}
    "-DSOURCE_DIR:PATH=${EP_SOURCE_DIR}"
    "-DBUILD_DIR:PATH=${EP_BINARY_DIR}"
    "-DCONFIG:INTERNAL=$<CONFIG>"
    "-DEP_SCRIPT_CONFIG:FILEPATH=${EP_SCRIPT_CONFIG}"
    -P "${CMAKE_CURRENT_LIST_DIR}/test.cmake"
  DEPENDS
    ${EP_PROJECT}-prerequisites
)
