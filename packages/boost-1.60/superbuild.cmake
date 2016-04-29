# boost superbuild

# Set dependency list
ome_add_dependencies(boost-1.60 THIRD_PARTY_DEPENDENCIES zlib bzip2 icu)

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
  URL "http://sourceforge.net/projects/boost/files/boost/1.60.0/boost_1_60_0.tar.bz2"
  URL_HASH "SHA512=7c851b3fc2b322ff05d642d9cf03e7c30c5f04d5cf0579c99046b1ec708901c58a3d349031dfe24591f5b88c1e664b6a0d40abea6cce89abb52080c02eb725df"
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
