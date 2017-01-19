include("${EP_SCRIPT_CONFIG}")
include("${GENERIC_CMAKE_ENVIRONMENT}")


file(TO_NATIVE_PATH "${OME_EP_INCLUDE_DIR}" NATIVE_INCLUDE_DIR)
file(TO_NATIVE_PATH "${OME_EP_LIB_DIR}" NATIVE_LIB_DIR)
file(TO_NATIVE_PATH "/usr/local/include" NATIVE_LOCAL_INCLUDE_DIR)
file(TO_NATIVE_PATH "/usr/local/lib" NATIVE_LOCAL_LIB_DIR)

execute_process(COMMAND python setup.py build_ext
  "-I${NATIVE_INCLUDE_DIR}:${NATIVE_LOCAL_INCLUDE_DIR}"
  "-L${NATIVE_LIB_DIR}:${NATIVE_LOCAL_LIB_DIR}"
  "-R${NATIVE_LIB_DIR}:${NATIVE_LOCAL_LIB_DIR}"
  WORKING_DIRECTORY "${SOURCE_DIR}"
  RESULT_VARIABLE build_ext_result)
if(build_ext_result)
  message(FATAL_ERROR "ome-files-py: build_ext failed")
endif()

execute_process(COMMAND python setup.py build
  WORKING_DIRECTORY "${SOURCE_DIR}"
  RESULT_VARIABLE build_result)
if(build_result)
  message(FATAL_ERROR "ome-files-py: build failed")
endif()
