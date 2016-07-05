# Build xerces
include("${EP_SCRIPT_CONFIG}")
include("${GENERIC_CMAKE_ENVIRONMENT}")
include("${CMAKE_CURRENT_LIST_DIR}/common.cmake")

if(WIN32)

  message(STATUS "Building xerces (Windows)")

  set(N 1)
  if(OME_EP_BUILD_PARALLEL)
    include(ProcessorCount)
    ProcessorCount(N)
    if(N EQUAL 0)
      set(N 1)
    endif()
  endif()

  execute_process(COMMAND msbuild "projects\\Win32\\${XERCES_SOLUTION}\\xerces-all\\xerces-all.sln"
                          "/p:Configuration=${XERCES_CONFIG}"
                          "/p:Platform=${XERCES_PLATFORM}"
                          "/p:useenv=true" "/v:d"
                          "/m:${N}"
                  WORKING_DIRECTORY ${SOURCE_DIR}
                  RESULT_VARIABLE build_result)

else(WIN32)

  message(STATUS "Building xerces (Unix)")

  if(OME_EP_BUILD_PARALLEL)
    include(ProcessorCount)
    ProcessorCount(N)
    if(N EQUAL 0)
      set(build_parallel "-j${N}")
    endif()
  endif()

  execute_process(COMMAND ${OME_MAKE_PROGRAM} ${build_parallel}
                  WORKING_DIRECTORY ${BUILD_DIR}
                  RESULT_VARIABLE build_result)

endif(WIN32)

if (build_result)
  message(FATAL_ERROR "xerces: Build failed")
endif()
