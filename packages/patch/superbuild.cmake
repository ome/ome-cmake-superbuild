# patch superbuild

# Set dependency list
ome_add_dependencies(patch
                     TYPE tool)

if(MSVC)
ExternalProject_Add(${EP_PROJECT}
  ${OME_EP_COMMON_ARGS}
  URL "http://downloads.sourceforge.net/project/gnuwin32/patch/2.5.9-7/patch-2.5.9-7-bin.zip"
  URL_HASH "SHA512=c6070aabf8172b7f3782eda1f8e4cbbe28b60e41c11d463c64c9aba767e157942279fb7d0638c5caafb527bc979a94813b14ce5f0ee3d32bc678fe4ea419fb61"
  SOURCE_DIR "${EP_SOURCE_DIR}"
  BINARY_DIR ""
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_DIR ""
  INSTALL_COMMAND ${CMAKE_COMMAND}
    "-DSOURCE_DIR:PATH=${EP_SOURCE_DIR}"
    "-DBUILD_DIR:PATH=${EP_BINARY_DIR}"
    "-DCONFIG:INTERNAL=$<CONFIG>"
    "-DEP_SCRIPT_CONFIG:FILEPATH=${EP_SCRIPT_CONFIG}"
    -P "${CMAKE_CURRENT_LIST_DIR}/install.cmake"
  DEPENDS
    ${EP_PROJECT}-prerequisites
)
else()
  find_program(PATCH_EXECUTABLE patch)
  if(NOT PATCH_EXECUTABLE)
     message(FATAL_ERROR "patch command is required to build; please install it")
  endif()
  ome_add_empty_project(${EP_PROJECT})
endif()
