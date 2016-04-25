# Install tofrodos
include("${EP_SCRIPT_CONFIG}")
include("${GENERIC_CMAKE_ENVIRONMENT}")

if(WIN32)

  file(MAKE_DIRECTORY "${OME_EP_TOOL_DIR}/bin")

  file(COPY ${SOURCE_DIR}/todos.exe ${SOURCE_DIR}/fromdos.exe
       DESTINATION "${OME_EP_TOOL_DIR}/bin")

endif()


