# ome-common superbuild

# Options to build from git (defaults to source zip if unset)
set(ome-common-head ON CACHE BOOL "Force building from current git develop branch")
set(ome-common-git-url "" CACHE STRING "URL of OME Common C++ git repository")
set(ome-common-git-branch "" CACHE STRING "URL of OME Common C++ git repository")

# Current stable release.
set(RELEASE_URL "")
set(RELEASE_HASH "SHA512=")

# Current development branch (defaults for head option).
set(GIT_URL "https://github.com/rleigh-dundee/ome-common-cpp.git")
set(GIT_BRANCH "develop")

if(NOT ome-common-head)
  if(ome-common-git-url)
    set(GIT_URL ${ome-common-git-url})
  endif()
  if(ome-common-git-branch)
    set(GIT_BRANCH ${ome-common-git-branch})
  endif()
endif()

if(ome-common-head OR ome-common-git-url OR ome-common-git-branch)
  set(EP_SOURCE_DOWNLOAD
    GIT_REPOSITORY "${GIT_URL}"
    GIT_TAG "${GIT_BRANCH}"
    UPDATE_DISCONNECTED 1)
  set(BOOST_VERSION 1.59)
  message(STATUS "Building OME Common C++ from git (URL ${GIT_URL}, branch/tag ${GIT_BRANCH})")
else()
  set(EP_SOURCE_DOWNLOAD
    URL "${RELEASE_URL}"
    URL_HASH "${RELEASE_HASH}")
  set(BOOST_VERSION 1.59)
  message(STATUS "Building OME Common C++ from source release (${RELEASE_URL})")
endif()

# Set dependency list
if(build-prerequisites)
  set(EP_DEPS boost-${BOOST_VERSION} xerces)
endif()
ome_add_dependencies(ome-common ${EP_DEPS})

unset(CONFIGURE_OPTIONS)
list(APPEND CONFIGURE_OPTIONS
     "-DBOOST_ROOT=${CMAKE_INSTALL_PREFIX}"
     -DBoost_NO_BOOST_CMAKE:BOOL=true
     "-DBoost_ADDITIONAL_VERSIONS=${BOOST_VERSION}"
     ${SUPERBUILD_OPTIONS})
string(REPLACE ";" "^^" CONFIGURE_OPTIONS "${CONFIGURE_OPTIONS}")

ExternalProject_Add(${EP_PROJECT}
  ${BIOFORMATS_EP_COMMON_ARGS}
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
