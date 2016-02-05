# Generic cmake configuration
include("${EP_SCRIPT_CONFIG}")
include("${GENERIC_CMAKE_ENVIRONMENT}")


# Note libdir is manually defined to avoid special-case for arch
# triplet on Debian.

message(STATUS "Configuring with \"${CMAKE_COMMAND}\"
  -G \"${CMAKE_GENERATOR}\"
  \"-DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}\"
  \"-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}\"
  \"-DCMAKE_INSTALL_LIBDIR=${CMAKE_INSTALL_LIBDIR}\"
  \"-DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}\"
  \"-DCMAKE_PROGRAM_PATH=${CMAKE_PROGRAM_PATH}\"
  \"-DCMAKE_LIBRARY_PATH=${CMAKE_LIBRARY_PATH}\"
  ${CONFIGURE_OPTIONS}
  \"${SOURCE_DIR}\"")

execute_process(COMMAND "${CMAKE_COMMAND}"
                        -G "${CMAKE_GENERATOR}"
                        "-DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}"
                        "-DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}"
                        "-DCMAKE_INSTALL_LIBDIR=${CMAKE_INSTALL_LIBDIR}"
                        "-DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}"
                        "-DCMAKE_PROGRAM_PATH=${CMAKE_PROGRAM_PATH}"
                        "-DCMAKE_LIBRARY_PATH=${CMAKE_LIBRARY_PATH}"
                        ${CONFIGURE_OPTIONS}
                        "${SOURCE_DIR}"
                WORKING_DIRECTORY "${BUILD_DIR}"
                RESULT_VARIABLE configure_result)

if(configure_result)
  message(FATAL_ERROR "cmake: Configure failed")
endif()
