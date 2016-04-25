# Generic cmake configuration
include("${EP_SCRIPT_CONFIG}")
include("${GENERIC_CMAKE_ENVIRONMENT}")

file(STRINGS "${PATCH_DIR}/series" patches)

foreach(patch ${patches})
  message(STATUS "Applying patch ${patch}")

  set(PATCH_OPTIONS -p1 -E)

  if(MSVC)
    execute_process(COMMAND todos
                    COMMAND patch ${PATCH_OPTIONS}
                    WORKING_DIRECTORY "${SOURCE_DIR}"
                    INPUT_FILE "${PATCH_DIR}/${patch}"
                    RESULT_VARIABLE patch_result)
  else()
    execute_process(COMMAND patch ${PATCH_OPTIONS}
                    WORKING_DIRECTORY "${SOURCE_DIR}"
                    INPUT_FILE "${PATCH_DIR}/${patch}"
                    RESULT_VARIABLE patch_result)
  endif()

  if(patch_result)
    message(FATAL_ERROR "Patch ${patch} failed")
  endif()
endforeach()
