# py-setuptools superbuild

# Set dependency list
ome_add_dependencies(py-pytest
                     TYPE tool
                     THIRD_PARTY_DEPENDENCIES py-py py-setuptools)

ExternalProject_Add(${EP_PROJECT}
  ${OME_EP_COMMON_ARGS}
  URL "https://pypi.python.org/packages/15/c8/6b42bf58f91d72416806472512bb67dabc6edb5a6a8ace29853ff940400a/pytest-3.1.3.tar.gz"
  URL_HASH "SHA512=96edf091925f58a836fdd83e95aeda86177a22d4b6c63cbd89eabc1ffde1302dbb8ed7aaad87f27685110e479f55415931be8c5501b77de1a5ea0d6553c048b6"
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
