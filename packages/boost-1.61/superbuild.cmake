# boost superbuild

# Set dependency list
ome_add_dependencies(boost-1.61 THIRD_PARTY_DEPENDENCIES zlib bzip2 icu)

if (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
  # VS 12.0
  if(NOT MSVC_VERSION VERSION_LESS 1800 AND MSVC_VERSION VERSION_LESS 1900)
    set(BOOST_TOOLSET msvc-12.0)
  # VS 14.0
  elseif(NOT MSVC_VERSION VERSION_LESS 1900 AND MSVC_VERSION VERSION_LESS 2000)
    set(BOOST_TOOLSET msvc-14.0)
  else()
    set(BOOST_TOOLSET msvc)
  endif()
elseif (CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  set(BOOST_TOOLSET clang)
elseif (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
  set(BOOST_TOOLSET gcc)
else()
  message(FATAL_ERROR "Unsupported Boost toolset for compiler type ${CMAKE_CXX_COMPILER_ID}.  Please report this deficiency.")
endif()

# Notes:
# Builds boost without Boost.Python (not currently used)

ExternalProject_Add(${EP_PROJECT}
  ${OME_EP_COMMON_ARGS}
  URL "http://sourceforge.net/projects/boost/files/boost/1.61.0/boost_1_61_0.tar.bz2"
  URL_HASH "SHA512=a1c7338e2d2dbac8552ede7c554640d22cbb2fda7fbc325dc3cdcb51e769713626695426ffc158cbe0e1729dd9a7b5ad18af4800d74e24539e8d8564268c2b9d"
  SOURCE_DIR "${EP_SOURCE_DIR}"
  INSTALL_DIR ""
  PATCH_COMMAND
    ${CMAKE_COMMAND}
    ${boost_CLANG_ARG}
    "-DSOURCE_DIR:PATH=${EP_SOURCE_DIR}"
    "-DBOOST_TOOLSET=${BOOST_TOOLSET}"
    "-DCONFIG:INTERNAL=$<CONFIG>"
    "-DEP_SCRIPT_CONFIG=${EP_SCRIPT_CONFIG}"
    -P ${CMAKE_CURRENT_LIST_DIR}/patch.cmake
  CONFIGURE_COMMAND
    ${CMAKE_COMMAND}
    ${boost_CLANG_ARG}
    "-DSOURCE_DIR:PATH=${EP_SOURCE_DIR}"
    "-DBOOST_TOOLSET=${BOOST_TOOLSET}"
    "-DCONFIG:INTERNAL=$<CONFIG>"
    "-DEP_SCRIPT_CONFIG=${EP_SCRIPT_CONFIG}"
    -P ${CMAKE_CURRENT_LIST_DIR}/configure.cmake
  BUILD_IN_SOURCE 1
  BUILD_COMMAND ${CMAKE_COMMAND}
    "-DSOURCE_DIR:PATH=${EP_SOURCE_DIR}"
    "-DEP_INSTALL_DIR:PATH=${OME_EP_INSTALL_DIR}"
    "-DBOOST_TOOLSET=${BOOST_TOOLSET}"
    "-DBOOST_BITS=${BOOST_BITS}"
    "-DCONFIG:INTERNAL=$<CONFIG>"
    "-DEP_SCRIPT_CONFIG=${EP_SCRIPT_CONFIG}"
    -P "${CMAKE_CURRENT_LIST_DIR}/build.cmake"
  INSTALL_COMMAND ""
  DEPENDS
    ${EP_PROJECT}-prerequisites
)