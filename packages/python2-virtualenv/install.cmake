# Install xerces
include("${EP_SCRIPT_CONFIG}")
include("${GENERIC_CMAKE_ENVIRONMENT}")

file(TO_NATIVE_PATH "${OME_EP_TOOL_DIR}/python2-venv" PYTHON_TOOL_DIR)

execute_process(COMMAND "${PYTHON_EXECUTABLE}"
                        -m virtualenv
                        -p "${PYTHON_EXECUTABLE}"
                        "${PYTHON_TOOL_DIR}"
                WORKING_DIRECTORY ${BUILD_DIR}
                RESULT_VARIABLE virtualenvresult)

if (virtualenvresult)
 message(FATAL_ERROR "python2-virtualenv: virtualenv creation failed")
endif()

if (PIP_REQUIREMENT_FILE)
  execute_process(COMMAND python
                          -m pip
                          install
                          -r "${PIP_REQUIREMENT_FILE}"
                  WORKING_DIRECTORY ${BUILD_DIR}
                  RESULT_VARIABLE pipresult)

  if (pipresult)
    message(FATAL_ERROR "python2-virtualenv: pip package installation failed")
  endif()
endif()
