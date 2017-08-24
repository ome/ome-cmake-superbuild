# #%L
# OME C++ libraries (cmake super-build infrastructure)
# %%
# Copyright © 2013 - 2015 Open Microscopy Environment:
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

cmake_minimum_required(VERSION 3.2.0)

# Default policy is from 3.2.0
cmake_policy(VERSION 3.2.0)

# For MSVC
enable_language(CXX)
enable_language(C)

# Add our own modules to the include path
list(APPEND CMAKE_MODULE_PATH
     "${CMAKE_CURRENT_LIST_DIR}/cmake")

if(NOT MSVC)
  # Get the path for the "make" command; note it's set to the
  # native build tool by default so this overrides it.  The
  # native tools is also set in CMAKE_BUILD_TOOL.  Note: this
  # duplicates CMakeUnixFindMake using a different variable.
  find_program(OME_MAKE_PROGRAM NAMES gmake make smake)
  mark_as_advanced(OME_MAKE_PROGRAM)

  # Look for a make tool provided by Xcode
  if(NOT OME_MAKE_PROGRAM AND CMAKE_HOST_APPLE)
    execute_process(COMMAND xcrun --find make
      OUTPUT_VARIABLE _xcrun_out OUTPUT_STRIP_TRAILING_WHITESPACE
      ERROR_VARIABLE _xcrun_err)
    if(_xcrun_out)
      set_property(CACHE OME_MAKE_PROGRAM PROPERTY VALUE "${_xcrun_out}")
    endif()
  endif()
endif()

set(release-name "ome-cmake-superbuild")
set(release-version "0.4.0")
project("${release-name}"
  VERSION "${release-version}"
  LANGUAGES CXX)

include(Version)
git_version_info("OME CMake Super-Build" "${CMAKE_CURRENT_SOURCE_DIR}")

if("${PROJECT_SOURCE_DIR}" STREQUAL "${PROJECT_BINARY_DIR}")
  message(FATAL_ERROR "In-tree builds are not supported; please run cmake from a separate build directory.")
endif("${PROJECT_SOURCE_DIR}" STREQUAL "${PROJECT_BINARY_DIR}")

include(cmake/SourceArchive.cmake)
source_archive("${release-name}" "${PROJECT_VERSION}${OME_VCS_DEV}")

# Options to pass through to subsidiary builds.
include(Options)
include(GNUInstallDirs)
include(ExternalProject)

# Helper functions and variables used by the following external projects.
include(ExternalProjectHelpers)

# External projects to build (will resolve dependencies recursively).
foreach(package ${build-packages})
  ome_add_package("${package}")
endforeach()

# Install cached build if needed
if(OME_EP_BUILD_CACHE)
  install(DIRECTORY ${OME_EP_BUILD_CACHE}/
          DESTINATION ${CMAKE_INSTALL_PREFIX}
          USE_SOURCE_PERMISSIONS)
endif()

# Install superbuild
install(DIRECTORY ${OME_EP_INSTALL_DIR}/
        DESTINATION ${CMAKE_INSTALL_PREFIX}
        USE_SOURCE_PERMISSIONS)
