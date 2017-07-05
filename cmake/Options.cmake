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

# Build subcomponents in parallel and run CMake tests in parallel.
# Note this does not control whether the build tool in use is building
# in parallel.  Rather, this controls whether other build tools used
# by subsidiary builds to also build in parellel (e.g. boost b2,
# msbuild).  Its purpose is to allow such additional parallelism to be
# disabled on resource-constrained systems.
option(parallel "Build subcomponents in parallel" ON)

# These are annoyingly verbose, produce false positives or don't work
# nicely with all supported compiler versions, so are disabled unless
# explicitly enabled.
option(extra-warnings "Enable extra compiler warnings" OFF)

# This will cause the compiler to fail when an error occurs.
option(fatal-warnings "Compiler warnings are errors" OFF)

# Unit tests.
option(test "Enable unit tests (requires gtest)" ON)
option(extended-tests "Enable extended tests (more comprehensive, longer run time)" OFF)

# Note that unlike in individual components, the default here is ON
# since we require it to be relocatable to move it out of the
# stage directory in the build tree.
option(relocatable-install "Install tree will be relocatable" ON)

# Default location of git repositories
set(git-dir "" CACHE STRING "Default location of local git repositories")

option(head "Force building from current git develop branch (all OME components)" OFF)

# List of packages to build
set(build-packages "ome-files" CACHE STRING "Packages to build")

option(build-prerequisites "Build third-party prerequisites" ON)

# Doxygen documentation
find_package(Doxygen)
set(DOXYGEN_DEFAULT OFF)
if (DOXYGEN_FOUND AND DOXYGEN_DOT_FOUND)
  set (DOXYGEN_DEFAULT ON)
endif (DOXYGEN_FOUND AND DOXYGEN_DOT_FOUND)
option(doxygen "Enable doxygen documentation" ${DOXYGEN_DEFAULT})
set(BUILD_DOXYGEN ${doxygen})

# Sphinx documentation generator
option(sphinx "Enable sphinx manual page and HTML documentation" ON)
option(sphinx-linkcheck "Check sphinx documentation links by default" OFF)

# C++ standard
set(default_cxx_standard 14)
if(NOT CMAKE_VERSION VERSION_LESS 3.8)
  set(default_cxx_standard 17)
endif()
set(CMAKE_CXX_STANDARD "${default_cxx_standard}" CACHE STRING "Preferred C++ standard version (will fall back to earlier versions if unavailable)")
set(CMAKE_CXX_STANDARD_REQUIRED FALSE CACHE BOOL "Force use of specified C++ standard (no fallback to earlier versions)")

set(SUPERBUILD_OPTIONS
    "-Dextra-warnings:BOOL=${extra-warnings}"
    "-Dfatal-warnings:BOOL=${fatal-warnings}"
    "-Drelocatable-install:BOOL=${relocatable-install}"
    "-Dtest:BOOL=${test}"
    "-Dextended-tests:BOOL=${extended-tests}"
    "-Ddoxygen:BOOL=${doxygen}"
    "-Dsphinx:BOOL=${sphinx}"
    "-Dsphinx-linkcheck:BOOL=${sphinx-linkcheck}")
