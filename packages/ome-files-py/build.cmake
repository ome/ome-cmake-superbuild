include("${EP_SCRIPT_CONFIG}")
include("${GENERIC_CMAKE_ENVIRONMENT}")


file(TO_NATIVE_PATH "${OME_EP_INCLUDE_DIR}" NATIVE_INCLUDE_DIR)
file(TO_NATIVE_PATH "${OME_EP_LIB_DIR}" NATIVE_LIB_DIR)
file(TO_NATIVE_PATH "/usr/local/include" NATIVE_LOCAL_INCLUDE_DIR)
file(TO_NATIVE_PATH "/usr/local/lib" NATIVE_LOCAL_LIB_DIR)
set(INCLUDE_DIRS "${NATIVE_INCLUDE_DIR}" "${NATIVE_LOCAL_INCLUDE_DIR}")
set(LIB_DIRS "${NATIVE_LIB_DIR}" "${NATIVE_LOCAL_LIB_DIR}")
if(OME_EP_BUILD_CACHE)
  file(TO_NATIVE_PATH "${OME_EP_BUILD_CACHE}/include" NATIVE_CACHE_INCLUDE_DIR)
  file(TO_NATIVE_PATH "${OME_EP_BUILD_CACHE}/lib" NATIVE_CACHE_LIB_DIR)
  list(APPEND INCLUDE_DIRS "${NATIVE_CACHE_INCLUDE_DIR}")
  list(APPEND LIB_DIRS "${NATIVE_CACHE_LIB_DIR}")
endif()
string(REPLACE ";" ":" INCLUDE_ARG "${INCLUDE_DIRS}")
string(REPLACE ";" ":" LIB_ARG "${LIB_DIRS}")

execute_process(COMMAND python setup.py build_ext
  "-I${INCLUDE_ARG}" "-L${LIB_ARG}" "-R${LIB_ARG}"
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
