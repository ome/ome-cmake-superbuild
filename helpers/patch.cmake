# Generic cmake configuration
include("${EP_SCRIPT_CONFIG}")
include("${GENERIC_CMAKE_ENVIRONMENT}")

file(STRINGS "${PATCH_DIR}/series" patches)

foreach(patch ${patches})
  message(STATUS "Applying patch ${patch}")

  if(MSVC)
    set(PATCH_OPTIONS --binary)
  endif()

  execute_process(COMMAND patch -p1 -E ${PATCH_OPTIONS}
                  WORKING_DIRECTORY "${SOURCE_DIR}"
                  INPUT_FILE "${PATCH_DIR}/${patch}"
                  RESULT_VARIABLE patch_result)

  if(patch_result)
    message(FATAL_ERROR "cmake: Patch failed")
  endif()
endforeach()
