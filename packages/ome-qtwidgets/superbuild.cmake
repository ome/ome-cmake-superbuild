# ome-qtwidgets superbuild

# Source information
ome_source_settings(ome-qtwidgets
  NAME            "OME QtWidgets"
  GIT_NAME        "ome-qtwidgets"
  GIT_URL         "https://github.com/ome/ome-qtwidgets.git"
  GIT_HEAD_BRANCH "master"
  RELEASE_URL     "https://downloads.openmicroscopy.org/ome-qtwidgets/5.4.3/source/ome-qtwidgets-5.4.3.tar.xz"
  RELEASE_HASH    "SHA512=00066fd21e7f2afe2762526977b307fb988747793e728c154556bee7ad340d8909c5be8c18de1b2ab8a3a2071182650ab70e6c1e2d4f15f148426ccc00716132")

# Set dependency list
ome_add_dependencies(ome-qtwidgets
                     DEPENDENCIES ome-files
                     THIRD_PARTY_DEPENDENCIES boost png tiff glm gtest)

list(APPEND CONFIGURE_OPTIONS
     "-DBOOST_ROOT=${OME_EP_INSTALL_DIR}"
     -DBoost_NO_BOOST_CMAKE:BOOL=true
     ${SUPERBUILD_OPTIONS})
if(SOURCE_ARCHIVE_DIR)
  list(APPEND CONFIGURE_OPTIONS "-DSOURCE_ARCHIVE_DIR=${SOURCE_ARCHIVE_DIR}")
endif()
string(REPLACE ";" "^^" CONFIGURE_OPTIONS "${CONFIGURE_OPTIONS}")

ExternalProject_Add(${EP_PROJECT}
  ${OME_EP_COMMON_ARGS}
  ${EP_SOURCE_DOWNLOAD}
  SOURCE_DIR ${EP_SOURCE_DIR}
  BINARY_DIR ${EP_BINARY_DIR}
  INSTALL_DIR ""
  CONFIGURE_COMMAND ${CMAKE_COMMAND}
    "-DSOURCE_DIR:PATH=${EP_SOURCE_DIR}"
    "-DBUILD_DIR:PATH=${EP_BINARY_DIR}"
    "-DCONFIGURE_OPTIONS=${CONFIGURE_OPTIONS}"
    "-DCONFIG:INTERNAL=$<CONFIG>"
    "-DEP_SCRIPT_CONFIG:FILEPATH=${EP_SCRIPT_CONFIG}"
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
