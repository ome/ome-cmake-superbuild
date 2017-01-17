include("${EP_SCRIPT_CONFIG}")
include("${GENERIC_CMAKE_ENVIRONMENT}")


file(TO_NATIVE_PATH "${OME_EP_INSTALL_DIR}" NATIVE_INSTALL_DIR)

execute_process(COMMAND python setup.py install --skip-build
  "--prefix=${NATIVE_INSTALL_DIR}"
  WORKING_DIRECTORY "${SOURCE_DIR}"
  RESULT_VARIABLE install_result)

if(install_result)
  message(FATAL_ERROR "cmake: Install failed")
endif()
