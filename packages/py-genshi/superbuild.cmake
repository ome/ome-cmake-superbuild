# py-genshi superbuild

# Set dependency list
ome_add_dependencies(py-genshi THIRD_PARTY_DEPENDENCIES py-setuptools)

ExternalProject_Add(${EP_PROJECT}
  ${BIOFORMATS_EP_COMMON_ARGS}
  URL "https://pypi.python.org/packages/source/G/Genshi/Genshi-0.7.tar.gz"
  URL_HASH "SHA512=2d0042d4da4566725ddd80b73c5b7be09f479f5529e4aa69903edc2a98905ff6de42a0d5a6f02986d7962deb7740c4a3acf6955a8b77fdb42d3cf4ca037de6bf"
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
