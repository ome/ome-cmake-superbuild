# py-pygments superbuild

# Set dependency list
ome_add_dependencies(py-pygments THIRD_PARTY_DEPENDENCIES py-setuptools)

ExternalProject_Add(${EP_PROJECT}
  ${OME_EP_COMMON_ARGS}
  URL "https://pypi.python.org/packages/source/P/Pygments/Pygments-2.0.2.tar.gz"
  URL_HASH "SHA512=b58e2cc535ba3f1fda7cb147e12af128bc2755de56cf465f8f1d642730eaef50c06551cc4cc44f25f726b00f3f1c9c2078977233b11c0b6a7e1add6a4069c27e"
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
