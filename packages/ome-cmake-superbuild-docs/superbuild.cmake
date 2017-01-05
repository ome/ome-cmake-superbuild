# ome-cmake-superbuild-docs superbuild

# We need to ensure that the documentation of all projects is
# installed before we build, or else the link checking will fail.
set(ome_docs_dependencies ${build-packages})
list(REMOVE_ITEM ome_docs_dependencies ome-cmake-superbuild-docs ome-cmake-superbuild-docs-contents)

# Set dependency list
ome_add_dependencies(ome-cmake-superbuild-docs
                     DEPENDENCIES ${ome_docs_dependencies}
                     THIRD_PARTY_DEPENDENCIES py-sphinx)

unset(ome_docs_dependencies)

list(APPEND CONFIGURE_OPTIONS
     "-DDOC_VERSION_MAJOR=${OME_VERSION_MAJOR}"
     "-DDOC_VERSION_MINOR=${OME_VERSION_MINOR}"
     "-DDOC_VERSION_PATCH=${OME_VERSION_PATCH}"
     ${SUPERBUILD_OPTIONS})
string(REPLACE ";" "^^" CONFIGURE_OPTIONS "${CONFIGURE_OPTIONS}")

ExternalProject_Add(${EP_PROJECT}
  SOURCE_DIR "${PROJECT_SOURCE_DIR}/docs/sphinx"
  BINARY_DIR "${EP_BINARY_DIR}"
  ${OME_EP_COMMON_ARGS}
  INSTALL_DIR ""
  CONFIGURE_COMMAND ${CMAKE_COMMAND}
    "-DSOURCE_DIR:PATH=${PROJECT_SOURCE_DIR}/docs/sphinx"
    "-DBUILD_DIR:PATH=${EP_BINARY_DIR}"
    "-DCONFIGURE_OPTIONS=${CONFIGURE_OPTIONS}"
    "-DCONFIG:INTERNAL=$<CONFIG>"
    "-DEP_SCRIPT_CONFIG:FILEPATH=${EP_SCRIPT_CONFIG}"
    -P "${GENERIC_CMAKE_CONFIGURE}"
  BUILD_COMMAND ${CMAKE_COMMAND}
    "-DSOURCE_DIR:PATH=${PROJECT_SOURCE_DIR}/docs/sphinx"
    "-DBUILD_DIR:PATH=${EP_BINARY_DIR}"
    "-DCONFIG:INTERNAL=$<CONFIG>"
    "-DEP_SCRIPT_CONFIG:FILEPATH=${EP_SCRIPT_CONFIG}"
    -P "${GENERIC_CMAKE_BUILD}"
  INSTALL_COMMAND ${CMAKE_COMMAND}
    "-DSOURCE_DIR:PATH=${PROJECT_SOURCE_DIR}/docs/sphinx"
    "-DBUILD_DIR:PATH=${EP_BINARY_DIR}"
    "-DCONFIG:INTERNAL=$<CONFIG>"
    "-DEP_SCRIPT_CONFIG:FILEPATH=${EP_SCRIPT_CONFIG}"
    -P "${GENERIC_CMAKE_INSTALL}"
  TEST_COMMAND ""
  DEPENDS
    ${EP_PROJECT}-prerequisites
  )
