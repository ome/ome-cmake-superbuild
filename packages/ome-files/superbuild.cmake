# ome-files superbuild

# Source information
ome_source_settings(ome-files
  NAME            "OME Files C++"
  GIT_NAME        "ome-files-cpp"
  GIT_URL         "https://github.com/ome/ome-files-cpp.git"
  GIT_HEAD_BRANCH "master"
  RELEASE_URL     "https://downloads.openmicroscopy.org/ome-files-cpp/0.5.0/source/ome-files-cpp-0.5.0.tar.xz"
  RELEASE_HASH    "SHA512=682174514fc2ab9ab62a863d008a21ee50a64efa791c3016c2a9092b9f45fdd51eb667a8b9dd59c4cb58ce33fa64838ae9520a3ccb6d37d70500d81f69d9ce1a")

# Set dependency list
ome_add_dependencies(ome-files
                     DEPENDENCIES ome-model
                     THIRD_PARTY_DEPENDENCIES boost hdf5 png tiff gtest
                     THIRD_PARTY_PYTHON2_DEPENDENCIES sphinx)

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
