# bioformats superbuild

# Options to build from git (defaults to source zip if unset)
set(head OFF CACHE BOOL "Force building from current git develop branch")
set(bf-git-url "" CACHE STRING "URL of Bio-Formats git repository")
set(bf-git-branch "" CACHE STRING "URL of Bio-Formats git repository")

# Current stable release.
set(RELEASE_URL "http://downloads.openmicroscopy.org/bio-formats/5.1.8/artifacts/bioformats-dfsg-5.1.8.tar.xz")
set(RELEASE_HASH "SHA512=11a33f1ae8cff7877a4218dc21b8cec68d27c327b7fd1484313c1a4784e928c2a848490ef8962c36e5a397e3b452af81f4de18d0a44a627bc33e813a8eeb4936")

# Current development branch (defaults for head option).
set(GIT_URL "https://github.com/openmicroscopy/bioformats.git")
set(GIT_BRANCH "develop")

if(NOT head)
  if(bf-git-url)
    set(GIT_URL ${bf-git-url})
  endif()
  if(bf-git-branch)
    set(GIT_BRANCH ${bf-git-branch})
  endif()
endif()

if(head OR bf-git-url OR bf-git-branch)
  set(EP_SOURCE_DOWNLOAD
    GIT_REPOSITORY "${GIT_URL}"
    GIT_TAG "${GIT_BRANCH}"
    UPDATE_DISCONNECTED 1)
  set(BOOST_VERSION 1.59)
  message(STATUS "Building Bio-Formats from git (URL ${GIT_URL}, branch/tag ${GIT_BRANCH})")
else()
  set(EP_SOURCE_DOWNLOAD
    URL "${RELEASE_URL}"
    URL_HASH "${RELEASE_HASH}")
  set(BOOST_VERSION 1.59)
  message(STATUS "Building Bio-Formats from source release (${RELEASE_URL})")
endif()

# Set dependency list
if(build-prerequisites)
  set(EP_DEPS boost-${BOOST_VERSION} png tiff xerces py-genshi py-sphinx)
endif()
ome_add_dependencies(bioformats ${EP_DEPS})

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
