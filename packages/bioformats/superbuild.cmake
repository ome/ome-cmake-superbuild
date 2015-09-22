# bioformats superbuild
set(proj bioformats)

# Options to build from git (defaults to source zip if unset)
set(head OFF CACHE BOOL "Force building from current git develop branch")
set(bf-git-url "" CACHE STRING "URL of Bio-Formats git repository")
set(bf-git-branch "" CACHE STRING "URL of Bio-Formats git repository")

# Current stable release.
set(RELEASE_URL "http://downloads.openmicroscopy.org/bio-formats/5.1.4/artifacts/bioformats-dfsg-5.1.4.zip")
set(RELEASE_HASH "SHA512=8fb973a91ffdb21ca78f37784674f38f8cccd6c49d98402eeb636ae6ae2061c344a27303c4c1099f10066f754174e7f6e185d79e6d3fc14b1a98a1ffd9d2c501")

# Current development branch (defaults for head option).
set(GIT_URL "https://github.com/openmicroscopy/bioformats.git")
set(GIT_BRANCH "develop")

# Set dependency list
set(bioformats_DEPENDENCIES zlib bzip2 png tiff icu boost xerces)
set(bioformats_ARGS)

set(EP_SOURCE_DIR ${CMAKE_BINARY_DIR}/${proj}-source)
set(EP_BINARY_DIR ${CMAKE_BINARY_DIR}/${proj}-build)

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
    GIT_TAG "${GIT_BRANCH}")
  unset(PATCH_COMMAND)
  message(STATUS "Building Bio-Formats from git (URL ${GIT_URL}, branch/tag ${GIT_BRANCH})")
else()
  set(EP_SOURCE_DOWNLOAD
    URL "${RELEASE_URL}"
    URL_HASH "${RELEASE_HASH}")
  set(PATCH_COMMAND
    PATCH_COMMAND ${CMAKE_COMMAND} -E copy_directory
    "${CMAKE_CURRENT_LIST_DIR}/files"
    "${EP_SOURCE_DIR}")
  message(STATUS "Building Bio-Formats from source release (${RELEASE_URL})")
endif()

list(APPEND CONFIGURE_OPTIONS
     ${bioformats_ARGS}
     ${SUPERBUILD_OPTIONS})
string(REPLACE ";" "^^" CONFIGURE_OPTIONS "${CONFIGURE_OPTIONS}")

ExternalProject_Add(${proj}
  ${BIOFORMATS_EP_COMMON_ARGS}
  ${EP_SOURCE_DOWNLOAD}
  SOURCE_DIR ${EP_SOURCE_DIR}
  BINARY_DIR ${EP_BINARY_DIR}
  ${PATCH_COMMAND}
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
  INSTALL_DIR ""
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
    ${bioformats_DEPENDENCIES}
  )
