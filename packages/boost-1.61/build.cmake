# Build boost
include("${EP_SCRIPT_CONFIG}")
include("${GENERIC_CMAKE_ENVIRONMENT}")

if (CONFIG MATCHES Rel)
  set(BOOST_VARIANT release)
  set(BZIP2_BINARY bz2)
  set(ZLIB_BINARY zlib)
else()
  set(BOOST_VARIANT debug)
  set(BZIP2_BINARY bz2d)
  set(ZLIB_BINARY zlibd)
endif()

if(OME_EP_BUILD_PARALLEL)
  include(ProcessorCount)
  ProcessorCount(N)
  if(NOT N EQUAL 0)
    set(build_parallel -j ${N})
  endif()
endif()

if(WIN32)

  message(STATUS "Running ./b2 install
--prefix=${OME_EP_INSTALL_DIR}
--lib=${WINDOWS_LIB_DIR}
--without-python
cxxflags=${CMAKE_CXX_FLAGS}
linkflags=${CMAKE_SHARED_LINKER_FLAGS}
toolset=${BOOST_TOOLSET}
variant=${BOOST_VARIANT}
address-model=${EP_PLATFORM_BITS}
link=shared
runtime-link=shared
threading=multi
-d+2
-sBZIP2_BINARY=${BZIP2_BINARY}
-sBZIP2_INCLUDE=${WINDOWS_INCLUDE_DIR}
-sBZIP2_LIBPATH=${WINDOWS_LIB_DIR}
-sZLIB_BINARY=${ZLIB_BINARY}
-sZLIB_INCLUDE=${WINDOWS_INCLUDE_DIR}
-sZLIB_LIBPATH=${WINDOWS_LIB_DIR}
-sICU_PATH=${WINDOWS_INSTALL_DIR}"
${build_parallel})

  execute_process(COMMAND ./b2 install
                               "--prefix=${WINDOWS_INSTALL_DIR}"
                               "--lib=${WINDOWS_LIB_DIR}"
                               --without-python
                               "cxxflags=${CMAKE_CXX_FLAGS}"
                               "linkflags=${CMAKE_SHARED_LINKER_FLAGS}"
                               "toolset=${BOOST_TOOLSET}"
                               "variant=${BOOST_VARIANT}"
                               "address-model=${EP_PLATFORM_BITS}"
                               "link=shared"
                               "runtime-link=shared"
                               "threading=multi"
                               "-d+2"
                               "-sBZIP2_BINARY=${BZIP2_BINARY}"
                               "-sBZIP2_INCLUDE=${WINDOWS_INCLUDE_DIR}"
                               "-sBZIP2_LIBPATH=${WINDOWS_LIB_DIR}"
                               "-sZLIB_BINARY=${ZLIB_BINARY}"
                               "-sZLIB_INCLUDE=${WINDOWS_INCLUDE_DIR}"
                               "-sZLIB_LIBPATH=${WINDOWS_LIB_DIR}"
                               "-sICU_PATH=${WINDOWS_INSTALL_DIR}"
                               ${build_parallel}
                  WORKING_DIRECTORY "${SOURCE_DIR}"
                  RESULT_VARIABLE build_result)

  # Boost installs the DLLs into lib; move to bin for consistency.
  file(GLOB BOOST_DLLS "${OME_EP_LIB_DIR}/*boost*.dll")
  foreach(dll ${BOOST_DLLS})
    get_filename_component(dllbase "${dll}" NAME)
    file(RENAME "${dll}" "${OME_EP_BIN_DIR}/${dllbase}")
  endforeach()

else(WIN32)

  message(STATUS "Building boost (Unix) with toolset=${BOOST_TOOLSET} cxxflags=${CMAKE_CXX_FLAGS} linkflags=${CMAKE_SHARED_LINKER_FLAGS}")

  execute_process(COMMAND ./b2 install
                               "cxxflags=${CMAKE_CXX_FLAGS}"
                               "linkflags=${CMAKE_SHARED_LINKER_FLAGS}"
                               "link=shared"
                               "runtime-link=shared"
                               "threading=multi"
                               "toolset=${BOOST_TOOLSET}"
                               "-d+2"
                               ${build_parallel}
                  WORKING_DIRECTORY "${SOURCE_DIR}"
                  RESULT_VARIABLE build_result)

endif(WIN32)

if (build_result)
  message(FATAL_ERROR "boost: Build failed")
endif()
