# py-sphinx superbuild

# Set dependency list
ome_add_dependencies(py-sphinx py-setuptools py-pygments py-docutils py-jinja2)

if(NOT ${CMAKE_PROJECT_NAME}_USE_SYSTEM_${EP_PROJECT})

  ExternalProject_Add(${EP_PROJECT}
    ${BIOFORMATS_EP_COMMON_ARGS}
    URL "https://pypi.python.org/packages/source/S/Sphinx/Sphinx-1.2.3.tar.gz"
    URL_HASH "SHA512=00346516e826a65145a3a7fd25ef7cee569ae7fdcc0c1bec3a7301fc08d5d8730d02eee792c3efedfcac17e712ea7e2ad70ea1fcdedc11720ad54f6bcb51ad05"
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
    DEPENDS
      ${EP_PROJECT}-prerequisites
    )
else()
  ExternalProject_Add_Empty(${EP_PROJECT} DEPENDS ${py-sphinx_DEPENDENCIES})
endif()
