# Generic cmake installation
include("${EP_SCRIPT_CONFIG}")
include("${GENERIC_CMAKE_ENVIRONMENT}")

message(STATUS "Building with \"${CMAKE_COMMAND}\" --build .
  --config \"${CONFIG}\"
  -- ${MAKE_VERBOSE}")

execute_process(COMMAND "${CMAKE_COMMAND}" --build .
                                           --config "${CONFIG}"
                                           -- ${MAKE_VERBOSE}
                WORKING_DIRECTORY "${EP_BUILD_DIR}"
                RESULT_VARIABLE install_result)

if(install_result)
  message(FATAL_ERROR "cmake: Install failed")
endif()
