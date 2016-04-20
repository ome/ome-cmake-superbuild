# tofrodos superbuild

if(MSVC)
  # Set dependency list
  ome_add_dependencies(tofrodos
                       TYPE tool)

  ExternalProject_Add(${EP_PROJECT}
    ${OME_EP_COMMON_ARGS}
    URL "http://tofrodos.sourceforge.net/download/tfd1713.zip"
    URL_HASH "SHA512=5f2b12026b0e8d610d1dee2ea6aaff706e7cc767e63b852e74f4a441c66741f67c7992ca89f3c2f2b3b975e5547e5def6ef216679527c6860f57b3ef1964624d"
    SOURCE_DIR "${EP_SOURCE_DIR}"
    BINARY_DIR ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_DIR ""
    INSTALL_COMMAND ${CMAKE_COMMAND}
      "-DSOURCE_DIR:PATH=${EP_SOURCE_DIR}"
      "-DCONFIG:INTERNAL=$<CONFIG>"
      "-DEP_SCRIPT_CONFIG:FILEPATH=${EP_SCRIPT_CONFIG}"
      -P "${CMAKE_CURRENT_LIST_DIR}/install.cmake"
    DEPENDS
      ${EP_PROJECT}-prerequisites
  )
else()
  find_program(FROMDOS_EXECUTABLE fromdos)
  if(NOT FROMDOS_EXECUTABLE)
     message(FATAL_ERROR "fromdos command is required to build; please install tofromdos")
  endif()
  ome_add_empty_project(${EP_PROJECT})
endif()
