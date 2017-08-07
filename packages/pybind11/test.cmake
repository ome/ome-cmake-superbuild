# Generic cmake testing
include("${EP_SCRIPT_CONFIG}")
include("${GENERIC_CMAKE_ENVIRONMENT}")

message(STATUS "Testing with \"${CMAKE_COMMAND}\" --build .
  --config \"${CONFIG}\" --target check
  -- ${MAKE_VERBOSE}")

execute_process(COMMAND "${CMAKE_COMMAND}" --build .
                                           --config "${CONFIG}"
                                           --target check
                                           -- ${MAKE_VERBOSE}
                WORKING_DIRECTORY "${EP_BUILD_DIR}"
                RESULT_VARIABLE test_result)

if(test_result)
  message(FATAL_ERROR "cmake: Testing failed")
else()
  message(STATUS "cmake: Testing passed")
endif()
