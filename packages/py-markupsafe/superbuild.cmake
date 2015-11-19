# py-markupsafe superbuild

# Set dependency list
ome_add_dependencies(py-markupsafe py-setuptools)

if(NOT ${CMAKE_PROJECT_NAME}_USE_SYSTEM_${EP_PROJECT})

  ExternalProject_Add(${EP_PROJECT}
    ${BIOFORMATS_EP_COMMON_ARGS}
    URL "https://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-0.23.tar.gz"
    URL_HASH "SHA512=4f1fd91ced5e7119584b56cf7b69cfe6fdd9613bd77412368a38e9ef5d1011ba5c76d1d3a0da3d60f9f474627e6c8c8b613a80a668b32d212f09072f8b1f5b28"
    SOURCE_DIR "${EP_SOURCE_DIR}"
    BINARY_DIR "${EP_BINARY_DIR}"
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_DIR ""
    INSTALL_COMMAND ${CMAKE_COMMAND}
      "-DSOURCE_DIR:PATH=${EP_SOURCE_DIR}"
      "-DBUILD_DIR:PATH=${EP_BINARY_DIR}"
      "-DCONFIG:INTERNAL=$<CONFIG>"
      "-DEP_SCRIPT_CONFIG:FILEPATH=${EP_SCRIPT_CONFIG}"
      -P "${GENERIC_PYTHON_INSTALL}"
    ${cmakeversion_external_update} "${cmakeversion_external_update_value}"
    DEPENDS
      ${EP_PROJECT}-prerequisites
    )
else()
  ome_add_empty_project(${EP_PROJECT})
endif()
