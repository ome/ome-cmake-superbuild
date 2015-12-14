# gtest superbuild

# Set dependency list
ome_add_dependencies(gtest)

# Notes:
# Does not build or install anything since FindGTest won't
# work properly on Windows; each project using it will need
# to build it.  This downloads it, and nothing more.

set(CONFIGURE_OPTIONS -Wno-dev --no-warn-unused-cli)
string(REPLACE ";" "^^" CONFIGURE_OPTIONS "${CONFIGURE_OPTIONS}")

ExternalProject_Add(${EP_PROJECT}
  ${BIOFORMATS_EP_COMMON_ARGS}
  URL "https://github.com/google/googletest/archive/release-1.7.0.tar.gz"
  URL_HASH "SHA512=c623d5720c4ed574e95158529872815ecff478c03bdcee8b79c9b042a603533f93fe55f939bcfe2cd745ce340fd626ad6d9a95981596f1a4d05053d874cd1dfc"
  SOURCE_DIR "${EP_SOURCE_DIR}"
  BINARY_DIR "${EP_SOURCE_DIR}"
  INSTALL_DIR ""
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND ""
  TEST_COMMAND ""
  DEPENDS
    ${EP_PROJECT}-prerequisites
)
