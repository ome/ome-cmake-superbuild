if(WIN32)

  file(TO_NATIVE_PATH "${OME_EP_BUILD_CACHE}" WINDOWS_BUILD_CACHE)
  file(TO_NATIVE_PATH "${OME_EP_TOOL_CACHE}" WINDOWS_TOOL_CACHE)

  file(TO_NATIVE_PATH "${OME_EP_BIN_DIR}" WINDOWS_BIN_DIR)
  file(TO_NATIVE_PATH "${OME_EP_TOOL_DIR}" WINDOWS_TOOL_DIR)
  if(WINDOWS_BUILD_CACHE)
    set(ENV{PATH} "${WINDOWS_BUILD_CACHE}\\bin;$ENV{PATH}")
  endif()
  if(WINDOWS_TOOL_CACHE)
    set(ENV{PATH} "${WINDOWS_TOOL_CACHE}\\bin;${WINDOWS_TOOL_CACHE}\\scripts;$ENV{PATH}")
  endif()
  set(ENV{PATH} "${WINDOWS_BIN_DIR};${WINDOWS_TOOL_DIR}\\bin;$ENV{PATH}")
  set(ENV{PATH} "${WINDOWS_BIN_DIR};${WINDOWS_TOOL_DIR}\\scripts;$ENV{PATH}")
  file(GLOB python_dirs LIST_DIRECTORIES true
       "${OME_EP_TOOL_CACHE}/*/site-packages"
       "${OME_EP_TOOL_CACHE}/*/*/site-packages"
       "${OME_EP_TOOL_DIR}/*/site-packages"
       "${OME_EP_TOOL_DIR}/*/*/site-packages"
       "${OME_EP_LIB_DIR}/*/site-packages"
       "${OME_EP_BUILD_CACHE}/lib/*/site-packages")
  foreach(dir ${python_dirs})
    file(TO_NATIVE_PATH "${dir}" dir)
    if(PYTHONPATH)
      set(PYTHONPATH "${dir};${PYTHONPATH}")
    else()
      set(PYTHONPATH "${dir}")
    endif()
  endforeach()
  set(ENV{PYTHONPATH} "${PYTHONPATH};$ENV{PYTHONPATH}")

else()

  if(OME_EP_BUILD_CACHE)
    set(ENV{PATH} "${OME_EP_BUILD_CACHE}/bin:$ENV{PATH}")
    if(APPLE)
      set(ENV{DYLD_FALLBACK_LIBRARY_PATH} "${OME_EP_BUILD_CACHE}/lib:$ENV{DYLD_FALLBACK_LIBRARY_PATH}")
    else()
      set(ENV{LD_LIBRARY_PATH} "${OME_EP_BUILD_CACHE}/lib:$ENV{LD_LIBRARY_PATH}")
    endif()
  endif()
  if(OME_EP_TOOL_CACHE)
    set(ENV{PATH} "${OME_EP_TOOL_CACHE}/bin:$ENV{PATH}")
  endif()
  set(ENV{PATH} "${OME_EP_BIN_DIR}:${OME_EP_TOOL_DIR}/bin:$ENV{PATH}")
  if(APPLE)
    set(ENV{DYLD_FALLBACK_LIBRARY_PATH} "${OME_EP_LIB_DIR}:$ENV{DYLD_FALLBACK_LIBRARY_PATH}")
  else()
    set(ENV{LD_LIBRARY_PATH} "${OME_EP_LIB_DIR}:$ENV{LD_LIBRARY_PATH}")
  endif()
  file(GLOB python_dirs LIST_DIRECTORIES true
       "${OME_EP_TOOL_CACHE}/*/site-packages"
       "${OME_EP_TOOL_CACHE}/*/*/site-packages"
       "${OME_EP_TOOL_DIR}/*/site-packages"
       "${OME_EP_TOOL_DIR}/*/*/site-packages"
       "${OME_EP_LIB_DIR}/*/site-packages"
       "${OME_EP_BUILD_CACHE}/lib/*/site-packages")
  foreach(dir ${python_dirs})
    if(PYTHONPATH)
      set(PYTHONPATH "${dir}:${PYTHONPATH}")
    else()
      set(PYTHONPATH "${dir}")
    endif()
  endforeach()
  set(ENV{PYTHONPATH} "${PYTHONPATH}:$ENV{PYTHONPATH}")

endif()

if(WIN32)
  # Windows compiler and linker flags

  file(TO_NATIVE_PATH "${OME_EP_INSTALL_DIR}" WINDOWS_INSTALL_DIR)
  file(TO_NATIVE_PATH "${OME_EP_INCLUDE_DIR}" WINDOWS_INCLUDE_DIR)
  file(TO_NATIVE_PATH "${OME_EP_LIB_DIR}" WINDOWS_LIB_DIR)

  set(EP_CXXFLAGS "${EP_CXXFLAGS} \"/I${WINDOWS_INCLUDE_DIR}\"")
  set(EP_LDFLAGS)
  set(ENV{INCLUDE} "${WINDOWS_INCLUDE_DIR};$ENV{INCLUDE}")
  set(ENV{LIB} "${WINDOWS_LIB_DIR};$ENV{LIB}")
else()
  # Unix compiler and linker flags
  set(ENV{AR} "${CMAKE_AR}")
  set(ENV{CC} "${CMAKE_C_COMPILER}")
  set(ENV{CXX} "${CMAKE_CXX_COMPILER}")
  set(ENV{LD} "${CMAKE_LINKER}")
  set(ENV{NM} "${CMAKE_NM}")
  set(ENV{OBJDUMP} "${CMAKE_OBJDUMP}")
  set(ENV{OBJCOPY} "${CMAKE_OBJCOPY}")
  set(ENV{RANLIB} "${CMAKE_RANLIB}")
  set(ENV{STRIP} "${CMAKE_STRIP}")

  set(EP_CXXFLAGS "${EP_CXXFLAGS} -I${OME_EP_INCLUDE_DIR}")
  set(EP_LDFLAGS "${EP_LDFLAGS} -L${OME_EP_LIB_DIR}")
endif()

string(REPLACE "^^" ";" CONFIGURE_OPTIONS "${CONFIGURE_OPTIONS}")
string(REPLACE "^^" ";" CMAKE_PREFIX_PATH "${CMAKE_PREFIX_PATH}")
string(REPLACE "^^" ";" CMAKE_LIBRARY_PATH "${CMAKE_LIBRARY_PATH}")
string(REPLACE "^^" ";" CMAKE_PROGRAM_PATH "${CMAKE_PROGRAM_PATH}")

if (CMAKE_VERBOSE_MAKEFILE AND CMAKE_GENERATOR MATCHES "Ninja")
  set(MAKE_VERBOSE -v)
endif()
