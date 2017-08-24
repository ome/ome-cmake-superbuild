# py-setuptools superbuild

# Set dependency list
ome_add_dependencies(py-py
                     TYPE tool
                     THIRD_PARTY_DEPENDENCIES py-setuptools)

ExternalProject_Add(${EP_PROJECT}
  ${OME_EP_COMMON_ARGS}
  URL "https://pypi.python.org/packages/68/35/58572278f1c097b403879c1e9369069633d1cbad5239b9057944bb764782/py-1.4.34.tar.gz"
  URL_HASH "SHA512=2e19c82c8315274bffe0ba2c7e20ae3af95f942c40c16121ec953af186f8ff33e8f427c070e137bb04b7cc6dcc6779e35df3911c08595fd3294b5ec9897706e1"
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
