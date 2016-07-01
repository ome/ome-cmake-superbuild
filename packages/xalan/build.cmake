# Build xalan
include("${EP_SCRIPT_CONFIG}")
include("${GENERIC_CMAKE_ENVIRONMENT}")
include("${CMAKE_CURRENT_LIST_DIR}/common.cmake")

if(WIN32)

  message(STATUS "Building xalan (Windows)")

  set(N 1)
  if(OME_EP_BUILD_PARALLEL)
    include(ProcessorCount)
    ProcessorCount(N)
    if(N EQUAL 0)
      set(N 1)
    endif()
  endif()

  # Initially create MsgCreator.exe.
  message(STATUS "Building xalan MsgCreator")
  execute_process(COMMAND msbuild "c\\Projects\\Win32\\${XALAN_SOLUTION}\\Xalan.sln"
                          "/p:Configuration=${XALAN_CONFIG}"
                          "/p:Platform=${XALAN_PLATFORM}"
                          "/t:MsgCreator"
                          "/p:useenv=true" "/v:d"
                          "/m:${N}"
                  WORKING_DIRECTORY ${SOURCE_DIR}
                  RESULT_VARIABLE build_result)

  # Run MsgCreator to generate needed sources.
  if(NOT build_result)
    message(STATUS "Running ${XALAN_BINARY_DIR}/MsgCreator to generate sources")
    if(NOT EXISTS "${XALAN_BINARY_DIR}/MsgCreator.exe")
      message(FATAL_ERROR "xalan: MsgCreator not found")
    endif()
    execute_process(COMMAND "${XALAN_BINARY_DIR}/MsgCreator.exe"
                            "${SOURCE_DIR}\\c\\src\\xalanc\\NLS\\en_US\\XalanMsg_en_US.xlf"
                            -TYPE inmem
                    WORKING_DIRECTORY ${SOURCE_DIR}/c/src
                    RESULT_VARIABLE build_result)
  endif()

  # It's now possible to run a full build.
  if(NOT build_result)
    message(STATUS "Building xalan DLLs")
    execute_process(COMMAND msbuild "c\\Projects\\Win32\\${XALAN_SOLUTION}\\Xalan.sln"
                            "/p:Configuration=${XALAN_CONFIG}"
                            "/p:Platform=${XALAN_PLATFORM}"
                            "/t:AllInOne"
                            "/p:useenv=true" "/v:d"
                            "/m:${N}"
                    WORKING_DIRECTORY ${SOURCE_DIR}
                    RESULT_VARIABLE build_result)
  endif()
  if(NOT build_result)
    message(STATUS "Building xalan EXEs")
    execute_process(COMMAND msbuild "c\\Projects\\Win32\\${XALAN_SOLUTION}\\Xalan.sln"
                            "/p:Configuration=${XALAN_CONFIG}"
                            "/p:Platform=${XALAN_PLATFORM}"
                            "/t:XalanExe"
                            "/p:useenv=true" "/v:d"
                            "/m:${N}"
                    WORKING_DIRECTORY ${SOURCE_DIR}
                    RESULT_VARIABLE build_result)
  endif()
else(WIN32)

  message(STATUS "Building xalan (Unix)")

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
  message(FATAL_ERROR "xalan: Build failed")
endif()
