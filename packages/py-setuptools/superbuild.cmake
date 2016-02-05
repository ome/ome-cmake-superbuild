# py-setuptools superbuild

# Set dependency list
ome_add_dependencies(py-setuptools)

ExternalProject_Add(${EP_PROJECT}
  ${OME_EP_COMMON_ARGS}
  URL "https://pypi.python.org/packages/source/s/setuptools/setuptools-18.3.2.tar.gz"
  URL_HASH "SHA512=0af522af1dc783e4d6b84c44d3cf4205aed75815bfc050ea89c4976434f08edd662501c4063b1618c0ce7a7120bcbd5331818d3f06912aa9136736018ec4b6a1"
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
