# Install xalan
include("${EP_SCRIPT_CONFIG}")
include("${GENERIC_CMAKE_ENVIRONMENT}")
include("${CMAKE_CURRENT_LIST_DIR}/common.cmake")

if(WIN32)
  message(STATUS "Installing xalan (Windows)")

  file(GLOB XALAN_DLLS "${XALAN_BINARY_DIR}/Xalan*.dll")
  file(GLOB XALAN_EXES "${XALAN_BINARY_DIR}/Xalan*.exe")
  file(GLOB XALAN_ILKS "${XALAN_BINARY_DIR}/Xalan*.ilk")
  file(GLOB XALAN_EXPS "${XALAN_BINARY_DIR}/Xalan*.exp")
  file(GLOB XALAN_LIBS "${XALAN_BINARY_DIR}/Xalan*.lib")
  file(GLOB XALAN_PDBS "${XALAN_BINARY_DIR}/Xalan*.pdb")
  file(GLOB_RECURSE XALAN_HDRS
       RELATIVE ${SOURCE_DIR}/c/src/xalanc
       "${SOURCE_DIR}/c/src/xalanc/*.hpp"
       "${SOURCE_DIR}/c/src/xalanc/*.h")
  file(GLOB_RECURSE XALAN_NLS_HDRS
       RELATIVE ${XALAN_BINARY_DIR}/Nls/Include
       "${XALAN_BINARY_DIR}/Nls/Include/*.hpp"
       "${XALAN_BINARY_DIR}/Nls/Include/*.h")

  file(INSTALL ${XALAN_EXES}
       DESTINATION "${BIOFORMATS_EP_BIN_DIR}")
  file(INSTALL ${XALAN_DLLS}
       DESTINATION "${BIOFORMATS_EP_BIN_DIR}")
  file(INSTALL ${XALAN_ILKS}
       DESTINATION "${BIOFORMATS_EP_BIN_DIR}")
  file(INSTALL ${XALAN_EXPS}
       DESTINATION "${BIOFORMATS_EP_LIB_DIR}")
  file(INSTALL ${XALAN_LIBS}
       DESTINATION "${BIOFORMATS_EP_LIB_DIR}")
  file(INSTALL ${XALAN_PDBS}
       DESTINATION "${BIOFORMATS_EP_LIB_DIR}")
  foreach(hdr ${XALAN_HDRS})
    get_filename_component(hdir "${hdr}" DIRECTORY)
    file(MAKE_DIRECTORY "${BIOFORMATS_EP_INCLUDE_DIR}/xalanc/${hdir}")
    file(INSTALL "${SOURCE_DIR}/c/src/xalanc/${hdr}"
         DESTINATION "${BIOFORMATS_EP_INCLUDE_DIR}/xalanc/${hdir}")
  endforeach()
  foreach(hdr ${XALAN_NLS_HDRS})
    file(MAKE_DIRECTORY "${BIOFORMATS_EP_INCLUDE_DIR}/xalanc/PlatformSupport")
    file(INSTALL "${XALAN_BINARY_DIR}/Nls/Include/${hdr}"
         DESTINATION "${BIOFORMATS_EP_INCLUDE_DIR}/xalanc/PlatformSupport")
  endforeach()

else()

  message(STATUS "Installing xalan (Unix)")

  execute_process(COMMAND ${OME_MAKE_PROGRAM} install
                  WORKING_DIRECTORY ${BUILD_DIR}
                  RESULT_VARIABLE install_result)

  if (install_result)
    message(FATAL_ERROR "xalan: Install failed")
  endif()

endif()


