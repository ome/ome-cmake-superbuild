# boost superbuild

# Set dependency list
ome_add_dependencies(boost-1.59 zlib bzip2 icu)

if(NOT ${CMAKE_PROJECT_NAME}_USE_SYSTEM_${EP_PROJECT})

  if (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
    # VS 10.0
    if(NOT MSVC_VERSION VERSION_LESS 1600 AND MSVC_VERSION VERSION_LESS 1700)
      set(BOOST_TOOLSET msvc-10.0)
    # VS 11.0
    elseif(NOT MSVC_VERSION VERSION_LESS 1700 AND MSVC_VERSION VERSION_LESS 1800)
      set(BOOST_TOOLSET msvc-11.0)
    # VS 12.0
    elseif(NOT MSVC_VERSION VERSION_LESS 1800 AND MSVC_VERSION VERSION_LESS 1900)
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
  # Builds boost without Boost.Python (not currently used by Bio-Formats)

  ExternalProject_Add(${EP_PROJECT}
    ${BIOFORMATS_EP_COMMON_ARGS}
    URL "http://sourceforge.net/projects/boost/files/boost/1.59.0/boost_1_59_0.tar.bz2"
    URL_HASH "SHA512=8139e1ae997a86974071c5714ad3307e3d8fd15ef702b81a953410dd4d424b932135f53a0ef4891d9b9b747a38e539e66d6a803388fe0cc98e5166be872d682a"
    SOURCE_DIR "${EP_SOURCE_DIR}"
    INSTALL_DIR ""
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
      "-DEP_INSTALL_DIR:PATH=${BIOFORMATS_EP_INSTALL_DIR}"
      "-DBOOST_TOOLSET=${BOOST_TOOLSET}"
      "-DBOOST_BITS=${BOOST_BITS}"
      "-DCONFIG:INTERNAL=$<CONFIG>"
      "-DEP_SCRIPT_CONFIG=${EP_SCRIPT_CONFIG}"
      -P "${CMAKE_CURRENT_LIST_DIR}/build.cmake"
    INSTALL_COMMAND ""
    DEPENDS
      ${EP_PROJECT}-prerequisites
    )
else()
  ome_add_empty_project(${EP_PROJECT})
endif()
