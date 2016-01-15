# Configure xalan
include("${EP_SCRIPT_CONFIG}")
include("${GENERIC_CMAKE_ENVIRONMENT}")
include("${CMAKE_CURRENT_LIST_DIR}/common.cmake")

if(WIN32) # Use appropriate MSVC solution

  message(STATUS "Bootstrapping xalan (Windows)")

else(WIN32)

  message(STATUS "Bootstrapping xalan (Unix)")

  execute_process(COMMAND "./configure"
                          "--prefix=${OME_EP_INSTALL_DIR}"
                          "--libdir=${OME_EP_LIB_DIR}"
                          "CXXFLAGS=${EP_CXXFLAGS}"
                          "LDFLAGS=${EP_LDFLAGS}"
                  WORKING_DIRECTORY ${BUILD_DIR}
                  RESULT_VARIABLE configure_result)

endif(WIN32)

if (configure_result)
  message(FATAL_ERROR "xalan: Configure failed")
endif()
