## #%L
# OME C++ libraries (cmake super-build infrastructure)
# %%
# Copyright © 2006 - 2014 Open Microscopy Environment:
#   - Massachusetts Institute of Technology
#   - National Institutes of Health
#   - University of Dundee
#   - Board of Regents of the University of Wisconsin-Madison
#   - Glencoe Software, Inc.
# %%
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#
# The views and conclusions contained in the software and documentation are
# those of the authors and should not be interpreted as representing official
# policies, either expressed or implied, of any organization.
# #L%

include(CMakeParseArguments)

# Location of python2 virtualenv requirements
set(OME_EP_PYTHON2_REQUIREMENTS_FILE "${PROJECT_BINARY_DIR}/python2-packages")

# Single target to build all prerequisites
add_custom_target(third-party-prerequisites)

# Include superbuild logic for the given package(s)
# Each package is only included once, using the ${name}_INCLUDED guard
function(ome_add_package name)
  set(options THIRD_PARTY)
  set(oneValueArgs TARGETVAR)
  set(multiValueArgs)

  cmake_parse_arguments(OAP "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(OAP_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "Unknown keywords given to OME_ADD_PACKAGES(): \"${OAP_UNPARSED_ARGUMENTS}\"")
  endif()

  if(OAP_TARGETVAR)
    set(${OAP_TARGETVAR} "${name}-NOTFOUND" PARENT_SCOPE)
  endif()

  if(NOT OAP_THIRD_PARTY OR
      (OAP_THIRD_PARTY AND build-prerequisites AND NOT ${CMAKE_PROJECT_NAME}_USE_SYSTEM_${name}) OR
      (OAP_THIRD_PARTY AND NOT build-prerequisites AND ${CMAKE_PROJECT_NAME}_BUILD_${name}))
    get_property(included GLOBAL PROPERTY ${name}_INCLUDED SET)
    if(NOT included)
      set_property(GLOBAL PROPERTY ${name}_INCLUDED ON)
      set(EP_PROJECT "${name}")
      set(EP_SOURCE_DIR "${CMAKE_BINARY_DIR}/${name}-source")
      set(EP_BINARY_DIR "${CMAKE_BINARY_DIR}/${name}-build")
      set(CONFIGURE_OPTIONS
          "-DCMAKE_CXX_STANDARD=${CMAKE_CXX_STANDARD}"
          "-DCMAKE_CXX_STANDARD_REQUIRED=${CMAKE_CXX_STANDARD_REQUIRED}"
          "-DCMAKE_MODULE_PATH:BOOL=${PROJECT_SOURCE_DIR}/cmake/compat;${CMAKE_MODULE_PATH}")
      if(OAP_THIRD_PARTY)
        add_dependencies(third-party-prerequisites "${name}")
        message(STATUS "Adding third-party dependency - ${name}")
      else()
        message(STATUS "Adding dependency - ${name}")
      endif()
      include("${PROJECT_SOURCE_DIR}/packages/${name}/superbuild.cmake")
    endif()
    if(OAP_TARGETVAR)
      set(${OAP_TARGETVAR} "${name}" PARENT_SCOPE)
    endif()
  else()
    message(STATUS "Ignoring dependency - ${name}")
  endif()
endfunction()

# Allow recursive addition of dependencies; store them in the specified
# variable and recursively add them.  Dependencies are stored in
# target_DEPENDENCIES
function(ome_add_dependencies target)
  set(options)
  set(oneValueArgs TYPE)
  set(multiValueArgs DEPENDENCIES THIRD_PARTY_DEPENDENCIES THIRD_PARTY_PYTHON2_DEPENDENCIES)

  cmake_parse_arguments(OAD "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(OAD_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "Unknown keywords given to OME_ADD_DEPENDENCIES(): \"${OAD_UNPARSED_ARGUMENTS}\"")
  endif()

  if(NOT OAD_TYPE)
    set(OAD_TYPE "source")
  endif()

  get_property(dependencies_added GLOBAL PROPERTY ${target}_DEPENDENCIES_ADDED SET)
  if(NOT dependencies_added)
    set_property(GLOBAL PROPERTY ${target}_DEPENDENCIES_ADDED ON)
    foreach(name ${OAD_DEPENDENCIES})
      ome_add_package("${name}" TARGETVAR targetname)
      if(targetname)
        list(APPEND ${target}_DEPENDENCIES "${targetname}")
      endif()
    endforeach()
    foreach(name ${OAD_THIRD_PARTY_DEPENDENCIES})
      ome_add_package("${name}" THIRD_PARTY TARGETVAR targetname)
      if(targetname)
        list(APPEND ${target}_DEPENDENCIES "${targetname}")
      endif()
    endforeach()
    foreach(name ${OAD_THIRD_PARTY_PYTHON2_DEPENDENCIES})
      # All python2 dependencies are installed into the virtualenv in
      # a single step (due to pip not handling parallel install).
      ome_add_package("python2-virtualenv" THIRD_PARTY TARGETVAR targetname)
      if(targetname)
        list(APPEND ${target}_DEPENDENCIES "${targetname}")
      endif()
      get_property(python2_dependencies_added GLOBAL PROPERTY PYTHON2_DEPENDENCIES SET)
      if(python2_dependencies_added)
        get_property(python2_dependencies GLOBAL PROPERTY PYTHON2_DEPENDENCIES)
      endif()
      list(APPEND python2_dependencies "${name}")
      list(REMOVE_DUPLICATES python2_dependencies)
      set_property(GLOBAL PROPERTY PYTHON2_DEPENDENCIES "${python2_dependencies}")
      string(REPLACE ";" "\n" python2_dependencies "${python2_dependencies}")
      file(WRITE "${OME_EP_PYTHON2_REQUIREMENTS_FILE}" "${python2_dependencies}\n")
    endforeach()
    if (${target}_DEPENDENCIES)
      list(REMOVE_DUPLICATES ${target}_DEPENDENCIES)
    endif()
    set(${target}_DEPENDENCIES "${${target}_DEPENDENCIES}" PARENT_SCOPE)
    add_custom_target(${target}-prerequisites
      DEPENDS ${${target}_DEPENDENCIES})
  endif()

  set(dl_dir ${source-cache})
  if(OAD_TYPE STREQUAL "tool")
    set(dl_dir ${tool-cache})
  endif()
  set(OME_EP_COMMON_ARGS
    LIST_SEPARATOR "^^"
    DOWNLOAD_DIR ${dl_dir}
    CMAKE_GENERATOR ${OME_EP_GENERATOR}
    CMAKE_ARGS ${OME_EP_CMAKE_ARGS}
    CMAKE_CACHE_ARGS ${OME_EP_CMAKE_CACHE_ARGS}
    PARENT_SCOPE)
endfunction()

macro(ome_add_empty_project project)
  ExternalProject_Add(${project}
    SOURCE_DIR ""
    BINARY_DIR ""
    DOWNLOAD_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
    DEPENDS ${project}-prerequisites)
endmacro()

function(ome_source_settings target)
  set(options)
  set(oneValueArgs NAME GIT_NAME GIT_URL GIT_HEAD_BRANCH RELEASE_URL RELEASE_HASH)
  set(multiValueArgs DEPENDENCIES THIRD_PARTY_DEPENDENCIES)

  cmake_parse_arguments(OSS "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  if(OSS_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "Unknown keywords given to OME_SOURCE_SETTINGS(): \"${OSS_UNPARSED_ARGUMENTS}\"")
  endif()

  if(NOT OSS_NAME)
    set(OSS_NAME "${target}")
  endif()
  if(NOT OSS_GIT_NAME)
    set(OSS_GIT_NAME "${target}")
  endif()
  if(NOT OSS_GIT_URL)
    set(OSS_GIT_URL "")
  endif()
  if(NOT OSS_GIT_BRANCH)
    set(OSS_GIT_BRANCH "")
  endif()
  if(NOT OSS_GIT_HEAD_BRANCH)
    set(OSS_GIT_HEAD_BRANCH "")
  endif()

  # Options to build from git (defaults to source zip if unset)
  set(${target}-head ${head} CACHE BOOL "Force building ${OSS_NAME} from current git ${OSS_GIT_HEAD} branch")

  set(git-dir-default "")
  if(EXISTS "${git-dir}")
    set(git-dir-default "${git-dir}/${OSS_GIT_NAME}")
  endif()
  set(${target}-dir "${git-dir-default}" CACHE PATH "Local directory containing the ${OSS_NAME} source code")

  set(${target}-git-url "${OSS_GIT_URL}" CACHE STRING "URL of ${OSS_NAME} git repository")
  set(${target}-git-branch "${OSS_GIT_BRANCH}" CACHE STRING "Branch or tag of ${OSS_NAME} git repository to build")

  if(NOT ${target}-head)
    if(${target}-git-url)
      set(OSS_GIT_URL ${${target}-git-url})
    endif()
    if(${target}-git-branch)
      set(OSS_GIT_BRANCH ${${target}-git-branch})
    endif()
  endif()

  if(${target}-dir AND NOT ${target}-dir STREQUAL git-dir-default)
    if(NOT EXISTS "${${target}-dir}")
      message(FATAL_ERROR "Git directory ${${target}-dir} defined for target ${target} does not exist")
    endif()
  endif()

  if(OSS_GIT_HEAD_BRANCH AND ${target}-head)
    set(EP_SOURCE_DOWNLOAD
      GIT_REPOSITORY "${OSS_GIT_URL}"
      GIT_TAG "${OSS_GIT_HEAD_BRANCH}"
      UPDATE_DISCONNECTED 1)
    message(STATUS "Building ${OSS_NAME} from git HEAD (URL ${OSS_GIT_URL}, branch/tag ${OSS_GIT_HEAD_BRANCH})")
  elseif(OSS_GIT_URL AND ${target}-git-branch)
    set(EP_SOURCE_DOWNLOAD
      GIT_REPOSITORY "${OSS_GIT_URL}"
      GIT_TAG "${OSS_GIT_BRANCH}"
      UPDATE_DISCONNECTED 1)
    message(STATUS "Building ${OSS_NAME} from git (URL ${OSS_GIT_URL}, branch/tag ${OSS_GIT_BRANCH})")
  elseif(${target}-dir AND EXISTS "${${target}-dir}")
    set(EP_SOURCE_DOWNLOAD
      DOWNLOAD_COMMAND "")
    set(EP_SOURCE_DIR "${${target}-dir}")
    message(STATUS "Building ${OSS_NAME} from local directory (${${target}-dir})")
  elseif(OSS_RELEASE_URL AND OSS_RELEASE_HASH)
    set(EP_SOURCE_DOWNLOAD
      URL "${OSS_RELEASE_URL}"
      URL_HASH "${OSS_RELEASE_HASH}")
    message(STATUS "Building ${OSS_NAME} from source release (${OSS_RELEASE_URL})")
  else()
    message(FATAL_ERROR "No sources defined for target ${target}")
  endif()

  set(EP_SOURCE_DIR "${EP_SOURCE_DIR}" PARENT_SCOPE)
  set(EP_SOURCE_DOWNLOAD "${EP_SOURCE_DOWNLOAD}" PARENT_SCOPE)
endfunction()

set(GENERIC_CMAKE_CONFIGURE "${PROJECT_SOURCE_DIR}/helpers/cmake_configure.cmake")
set(GENERIC_CMAKE_BUILD "${PROJECT_SOURCE_DIR}/helpers/cmake_build.cmake")
set(GENERIC_CMAKE_INSTALL "${PROJECT_SOURCE_DIR}/helpers/cmake_install.cmake")
set(GENERIC_CMAKE_TEST "${PROJECT_SOURCE_DIR}/helpers/cmake_test.cmake")
set(GENERIC_CMAKE_ENVIRONMENT "${PROJECT_SOURCE_DIR}/helpers/cmake_environment.cmake")
set(GENERIC_PATCH "${PROJECT_SOURCE_DIR}/helpers/patch.cmake")

# Compute -G arg for configuring external projects with the same CMake generator:
if(CMAKE_EXTRA_GENERATOR)
  set(OME_EP_GENERATOR "${CMAKE_EXTRA_GENERATOR} - ${CMAKE_GENERATOR}")
else()
  set(OME_EP_GENERATOR "${CMAKE_GENERATOR}")
endif()

set(source-cache "${CMAKE_BINARY_DIR}/sourcecache" CACHE FILEPATH "Directory for cached source downloads")
file(MAKE_DIRECTORY ${source-cache})

set(tool-cache "${CMAKE_BINARY_DIR}/toolcache" CACHE FILEPATH "Directory for cached tool downloads (doxygen, sphinx etc.)")
file(MAKE_DIRECTORY ${tool-cache})

set(OME_EP_INSTALL_DIR ${CMAKE_BINARY_DIR}/stage)
set(OME_EP_INCLUDE_DIR ${CMAKE_BINARY_DIR}/stage/include)
set(OME_EP_LIB_DIR ${CMAKE_BINARY_DIR}/stage/lib)
set(OME_EP_BIN_DIR ${CMAKE_BINARY_DIR}/stage/bin)
set(OME_EP_TOOL_DIR ${CMAKE_BINARY_DIR}/tools)

list(APPEND CMAKE_PREFIX_PATH "${OME_EP_INSTALL_DIR}" "${OME_EP_TOOL_DIR}")

# Look in superbuild staging tree when building
if(WIN32)
  # Windows compiler flags
else()
  set(CMAKE_CXX_FLAGS           "${CMAKE_CXX_FLAGS} -I${OME_EP_INCLUDE_DIR}")
  set(CMAKE_EXE_LINKER_FLAGS    "${CMAKE_EXE_LINKER_FLAGS} -L${OME_EP_LIB_DIR}")
  set(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} -L${OME_EP_LIB_DIR}")
  set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -L${OME_EP_LIB_DIR}")
endif()


set(EP_SCRIPT_CONFIG "${PROJECT_BINARY_DIR}/project-config.cmake")

string(REPLACE ";" "^^" OME_EP_ESCAPED_CMAKE_PREFIX_PATH "${CMAKE_PREFIX_PATH}")
string(REPLACE ";" "^^" OME_EP_ESCAPED_CMAKE_LIBRARY_PATH "${CMAKE_LIBRARY_PATH}")
string(REPLACE ";" "^^" OME_EP_ESCAPED_CMAKE_PROGRAM_PATH "${CMAKE_PROGRAM_PATH}")

set(OME_EP_CMAKE_ARGS
  "-DCMAKE_PREFIX_PATH:INTERNAL=${OME_EP_ESCAPED_CMAKE_PREFIX_PATH}"
  "-DCMAKE_LIBRARY_PATH:INTERNAL=${OME_EP_ESCAPED_CMAKE_LIBRARY_PATH}"
  "-DCMAKE_PROGRAM_PATH:INTERNAL=${OME_EP_ESCAPED_CMAKE_PROGRAM_PATH}"
  "-DCMAKE_BUILD_TYPE:INTERNAL=${CMAKE_BUILD_TYPE}"
)

# Set CMake OSX variables needed to be passed to external projects
if(APPLE)
  list(APPEND OME_EP_CMAKE_ARGS
    -DCMAKE_OSX_ARCHITECTURES:STRING=${CMAKE_OSX_ARCHITECTURES}
    -DCMAKE_OSX_SYSROOT:PATH=${CMAKE_OSX_SYSROOT}
    -DCMAKE_OSX_DEPLOYMENT_TARGET:STRING=${CMAKE_OSX_DEPLOYMENT_TARGET})
endif()

set(OME_EP_CMAKE_CACHE_ARGS
  "-DCMAKE_AR:FILEPATH=${CMAKE_AR}"
  "-DCMAKE_C_COMPILER:FILEPATH=${CMAKE_C_COMPILER}"
  "-DCMAKE_CXX_COMPILER:FILEPATH=${CMAKE_CXX_COMPILER}"
  "-DCMAKE_LINKER:FILEPATH=${CMAKE_LINKER}"
  "-DCMAKE_NM:FILEPATH=${CMAKE_NM}"
  "-DCMAKE_OBJCOPY:FILEPATH=${CMAKE_OBJCOPY}"
  "-DCMAKE_OBJDUMP:FILEPATH=${CMAKE_OBJDUMP}"
  "-DCMAKE_RANLIB:FILEPATH=${CMAKE_RANLIB}"
  "-DCMAKE_STRIP:FILEPATH=${CMAKE_STRIP}"

  "-DCMAKE_BUILD_TOOL:FILEPATH=${CMAKE_BUILD_TOOL}"
  "-DCMAKE_MAKE_PROGRAM:FILEPATH=${CMAKE_MAKE_PROGRAM}"
  "-DOME_MAKE_PROGRAM:FILEPATH=${OME_MAKE_PROGRAM}"

  "-DCMAKE_CXX_FLAGS:STRING=${CMAKE_CXX_FLAGS}"
  "-DCMAKE_CXX_FLAGS_DEBUG:STRING=${CMAKE_CXX_FLAGS_DEBUG}"
  "-DCMAKE_CXX_FLAGS_MINSIZEREL:STRING=${CMAKE_CXX_FLAGS_MINSIZEREL}"
  "-DCMAKE_CXX_FLAGS_RELEASE:STRING=${CMAKE_CXX_FLAGS_RELEASE}"
  "-DCMAKE_CXX_FLAGS_RELWITHDEBINFO:STRING=${CMAKE_CXX_FLAGS_RELWITHDEBINFO}"

  "-DCMAKE_C_FLAGS:STRING=${CMAKE_C_FLAGS}"
  "-DCMAKE_C_FLAGS_DEBUG:STRING=${CMAKE_C_FLAGS_DEBUG}"
  "-DCMAKE_C_FLAGS_MINSIZEREL:STRING=${CMAKE_C_FLAGS_MINSIZEREL}"
  "-DCMAKE_C_FLAGS_RELEASE:STRING=${CMAKE_C_FLAGS_RELEASE}"
  "-DCMAKE_C_FLAGS_RELWITHDEBINFO:STRING=${CMAKE_C_FLAGS_RELWITHDEBINFO}"

  "-DCMAKE_EXE_LINKER_FLAGS:STRING=${CMAKE_EXE_LINKER_FLAGS}"
  "-DCMAKE_EXE_LINKER_FLAGS_DEBUG:STRING=${CMAKE_EXE_LINKER_FLAGS_DEBUG}"
  "-DCMAKE_EXE_LINKER_FLAGS_MINSIZEREL:STRING=${CMAKE_EXE_LINKER_FLAGS_MINSIZEREL}"
  "-DCMAKE_EXE_LINKER_FLAGS_RELEASE:STRING=${CMAKE_EXE_LINKER_FLAGS_RELEASE}"
  "-DCMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO:STRING=${CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO}"

  "-DCMAKE_MODULE_LINKER_FLAGS:STRING=${CMAKE_MODULE_LINKER_FLAGS}"
  "-DCMAKE_MODULE_LINKER_FLAGS_DEBUG:STRING=${CMAKE_MODULE_LINKER_FLAGS_DEBUG}"
  "-DCMAKE_MODULE_LINKER_FLAGS_MINSIZEREL:STRING=${CMAKE_MODULE_LINKER_FLAGS_MINSIZEREL}"
  "-DCMAKE_MODULE_LINKER_FLAGS_RELEASE:STRING=${CMAKE_MODULE_LINKER_FLAGS_RELEASE}"
  "-DCMAKE_MODULE_LINKER_FLAGS_RELWITHDEBINFO:STRING=${CMAKE_MODULE_LINKER_FLAGS_RELWITHDEBINFO}"

  "-DCMAKE_SHARED_LINKER_FLAGS:STRING=${CMAKE_SHARED_LINKER_FLAGS}"
  "-DCMAKE_SHARED_LINKER_FLAGS_DEBUG:STRING=${CMAKE_SHARED_LINKER_FLAGS_DEBUG}"
  "-DCMAKE_SHARED_LINKER_FLAGS_MINSIZEREL:STRING=${CMAKE_SHARED_LINKER_FLAGS_MINSIZEREL}"
  "-DCMAKE_SHARED_LINKER_FLAGS_RELEASE:STRING=${CMAKE_SHARED_LINKER_FLAGS_RELEASE}"
  "-DCMAKE_SHARED_LINKER_FLAGS_RELWITHDEBINFO:STRING=${CMAKE_SHARED_LINKER_FLAGS_RELWITHDEBINFO}"

  "-DCMAKE_STATIC_LINKER_FLAGS:STRING=${CMAKE_STATIC_LINKER_FLAGS}"
  "-DCMAKE_STATIC_LINKER_FLAGS_DEBUG:STRING=${CMAKE_STATIC_LINKER_FLAGS_DEBUG}"
  "-DCMAKE_STATIC_LINKER_FLAGS_MINSIZEREL:STRING=${CMAKE_STATIC_LINKER_FLAGS_MINSIZEREL}"
  "-DCMAKE_STATIC_LINKER_FLAGS_RELEASE:STRING=${CMAKE_STATIC_LINKER_FLAGS_RELEASE}"
  "-DCMAKE_STATIC_LINKER_FLAGS_RELWITHDEBINFO:STRING=${CMAKE_STATIC_LINKER_FLAGS_RELWITHDEBINFO}"

  "-DCMAKE_EXPORT_COMPILE_COMMANDS:BOOL=${CMAKE_EXPORT_COMPILE_COMMANDS}"

  "-DCMAKE_INSTALL_BINDIR:PATH=${CMAKE_INSTALL_BINDIR}"
  "-DCMAKE_INSTALL_DATADIR:PATH=${CMAKE_INSTALL_DATADIR}"
  "-DCMAKE_INSTALL_DATAROOTDIR:PATH=${CMAKE_INSTALL_DATAROOTDIR}"
  "-DCMAKE_INSTALL_INCLUDEDIR:PATH=${CMAKE_INSTALL_INCLUDEDIR}"
  "-DCMAKE_INSTALL_LIBDIR:PATH=lib"
  "-DCMAKE_INSTALL_LIBEXECDIR:PATH=${CMAKE_INSTALL_LIBEXECDIR}"
  "-DCMAKE_INSTALL_LOCALSTATEDIR:PATH=${CMAKE_INSTALL_LOCALSTATEDIR}"
  "-DCMAKE_INSTALL_OLDINCLUDEDIR:PATH=${CMAKE_INSTALL_OLDINCLUDEDIR}"
  "-DCMAKE_INSTALL_SBINDIR:PATH=${CMAKE_INSTALL_SBINDIR}"
  "-DCMAKE_INSTALL_SHAREDSTATEDIR:PATH=${CMAKE_INSTALL_SHAREDSTATEDIR}"
  "-DCMAKE_INSTALL_SYSCONFDIR:PATH=${CMAKE_INSTALL_SYSCONFDIR}"

  "-DCMAKE_PREFIX_PATH:PATH=${CMAKE_PREFIX_PATH}"

  "-DCMAKE_SKIP_INSTALL_RPATH:BOOL=${CMAKE_SKIP_INSTALL_RPATH}"
  "-DCMAKE_SKIP_RPATH:BOOL=${CMAKE_SKIP_RPATH}"
  "-DCMAKE_USE_RELATIVE_PATHS:BOOL=${CMAKE_USE_RELATIVE_PATHS}"
  "-DCMAKE_VERBOSE_MAKEFILE:BOOL=${CMAKE_VERBOSE_MAKEFILE}"

  ${SUPERBUILD_OPTIONS}
)

list(APPEND OME_EP_CMAKE_CACHE_ARGS "-DCMAKE_INSTALL_PREFIX:PATH=${OME_EP_INSTALL_DIR}")

# Primarily for Windows; will need extending for non-x86 platforms if required.
if(MSVC)
  list(APPEND OME_EP_CMAKE_CACHE_ARGS
       "-DMSVC:INTERNAL=${MSVC}"
       "-DMSVC_VERSION:INTERNAL=${MSVC_VERSION}")
endif()

if(CMAKE_SIZEOF_VOID_P EQUAL 8)
  list(APPEND OME_EP_CMAKE_CACHE_ARGS
       "-DEP_PLATFORM_BITS:INTERNAL=64")
else()
  list(APPEND OME_EP_CMAKE_CACHE_ARGS
       "-DEP_PLATFORM_BITS:INTERNAL=32")
endif()

set(OME_EP_SCRIPT_ARGS
  "-DCMAKE_C_COMPILER_ID:STRING=${CMAKE_C_COMPILER_ID}"
  "-DCMAKE_CXX_COMPILER_ID:STRING=${CMAKE_CXX_COMPILER_ID}"
  "-DOME_EP_INSTALL_DIR:PATH=${OME_EP_INSTALL_DIR}"
  "-DOME_EP_TOOL_DIR:PATH=${OME_EP_TOOL_DIR}"
  "-DOME_EP_BIN_DIR:PATH=${OME_EP_BIN_DIR}"
  "-DOME_EP_INCLUDE_DIR:PATH=${OME_EP_INCLUDE_DIR}"
  "-DOME_EP_LIB_DIR:PATH=${OME_EP_LIB_DIR}"
  "-DOME_EP_BUILD_PARALLEL:BOOL=${parallel}"
  "-DGENERIC_CMAKE_ENVIRONMENT:PATH=${GENERIC_CMAKE_ENVIRONMENT}"
  "-DCMAKE_GENERATOR:PATH=${CMAKE_GENERATOR}"
)

# Create script file for use by external project scripts, where the
# command-line and cache args won't be used.
foreach(arg ${OME_EP_CMAKE_ARGS}
            ${OME_EP_CMAKE_CACHE_ARGS}
            ${OME_EP_SCRIPT_ARGS})
  if("${arg}" MATCHES "^-D(.*)")
    set(arg "${CMAKE_MATCH_1}")
    if("${arg}" MATCHES "^([^:]+):([^=]+)=(.*)$")
      set(name "${CMAKE_MATCH_1}")
      set(type "${CMAKE_MATCH_2}")
      set(value "${CMAKE_MATCH_3}")
      string(REPLACE "\"" "\\\"" value "${value}")
      set(line "set(${name} \"${value}\" CACHE ${type} \"${name} from superbuild\")")
      list(APPEND EP_SCRIPT_PARAMS "${line}")
    else()
      message(WARNING "Regex match failed for ${arg}")
    endif()
  endif()
endforeach()
string(REPLACE ";" "\n" EP_SCRIPT_PARAMS "${EP_SCRIPT_PARAMS}")
file(WRITE "${EP_SCRIPT_CONFIG}" "${EP_SCRIPT_PARAMS}")
