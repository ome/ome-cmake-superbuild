# Generic cmake configuration
include("${EP_SCRIPT_CONFIG}")
include("${GENERIC_CMAKE_ENVIRONMENT}")

set(seriesfile "${PATCH_DIR}/series")
if(MSVC)
  # VS 12.0
  if(NOT MSVC_VERSION VERSION_LESS 1800 AND MSVC_VERSION VERSION_LESS 1900)
    if(EXISTS "${PATCH_DIR}/series-vc12")
      set(seriesfile "${PATCH_DIR}/series-vc12")
    endif()
  # VS 14.0
  elseif(NOT MSVC_VERSION VERSION_LESS 1900 AND MSVC_VERSION VERSION_LESS 2000)
    if(EXISTS "${PATCH_DIR}/series-vc14")
      set(seriesfile "${PATCH_DIR}/series-vc14")
    endif()
  endif()
endif()

if(EXISTS "${seriesfile}")
  file(STRINGS "${seriesfile}" patches)

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
else()
  message(STATUS "No patch series to apply")
endif()
