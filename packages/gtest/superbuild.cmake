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
  ${OME_EP_COMMON_ARGS}
  URL "https://github.com/google/googletest/archive/release-1.8.0.tar.gz"
  URL_HASH "SHA512=1dbece324473e53a83a60601b02c92c089f5d314761351974e097b2cf4d24af4296f9eb8653b6b03b1e363d9c5f793897acae1f0c7ac40149216035c4d395d9d"
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
