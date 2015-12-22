# Configure xerces
include("${EP_SCRIPT_CONFIG}")
include("${GENERIC_CMAKE_ENVIRONMENT}")

if(WIN32) # Use appropriate MSVC solution

  message(STATUS "Bootstrapping xerces (Windows)")

else(WIN32)

  message(STATUS "Bootstrapping xerces (Unix)")

  set(ENV{CXX} "${XERCES_CXX}")

  execute_process(COMMAND "${SOURCE_DIR}/configure"
                          "--prefix=${OME_EP_INSTALL_DIR}"
                          "--libdir=${OME_EP_LIB_DIR}"
                          "--with-pkgconfigdir=${OME_EP_LIB_DIR}/pkgconfig"
                  WORKING_DIRECTORY ${BUILD_DIR}
                  RESULT_VARIABLE configure_result)

endif(WIN32)

if (configure_result)
  message(FATAL_ERROR "xerces: Configure failed")
endif()
