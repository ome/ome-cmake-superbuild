include("${EP_SCRIPT_CONFIG}")
include("${GENERIC_CMAKE_ENVIRONMENT}")


file(TO_NATIVE_PATH "${SOURCE_DIR}/test" NATIVE_TEST_DIR)

execute_process(COMMAND python all_tests.py
  WORKING_DIRECTORY "${NATIVE_TEST_DIR}"
  RESULT_VARIABLE test_result)

if(test_result)
  message(FATAL_ERROR "ome-files-py: test failed")
endif()
