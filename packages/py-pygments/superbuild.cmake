# py-pygments superbuild
set(proj py-pygments)

# Set dependency list
set(py-pygments_DEPENDENCIES py-setuptools)

if(NOT ${CMAKE_PROJECT_NAME}_USE_SYSTEM_${proj})
  set(EP_SOURCE_DIR ${CMAKE_BINARY_DIR}/${proj}-source)
  set(EP_BINARY_DIR ${CMAKE_BINARY_DIR}/${proj}-build)

  ExternalProject_Add(${proj}
    ${BIOFORMATS_EP_COMMON_ARGS}
    URL "https://pypi.python.org/packages/source/P/Pygments/Pygments-2.0.2.tar.gz"
    URL_HASH "SHA512=b58e2cc535ba3f1fda7cb147e12af128bc2755de56cf465f8f1d642730eaef50c06551cc4cc44f25f726b00f3f1c9c2078977233b11c0b6a7e1add6a4069c27e"
    SOURCE_DIR "${EP_SOURCE_DIR}"
    BINARY_DIR "${EP_BINARY_DIR}"
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_DIR ""
    INSTALL_COMMAND ${CMAKE_COMMAND}
      "-DSOURCE_DIR:PATH=${EP_SOURCE_DIR}"
      "-DBUILD_DIR:PATH=${EP_BINARY_DIR}"
      "-DCONFIG:INTERNAL=$<CONFIG>"
      "-DEP_SCRIPT_CONFIG:FILEPATH=${EP_SCRIPT_CONFIG}"
      -P "${GENERIC_PYTHON_INSTALL}"
    ${cmakeversion_external_update} "${cmakeversion_external_update_value}"
    DEPENDS
      ${py-pygments_DEPENDENCIES}
    )
else()
  ExternalProject_Add_Empty(${proj} DEPENDS ${py-pygments_DEPENDENCIES})
endif()
