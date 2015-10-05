# #%L
# Bio-Formats C++ libraries (cmake super-build infrastructure)
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

list(APPEND CMAKE_MODULE_PATH
     "${CMAKE_CURRENT_LIST_DIR}/cmake")

# Options to pass through to main Bio-Formats build.
include("${CMAKE_CURRENT_LIST_DIR}/Options.cmake")

project(bioformats-superbuild)

message(STATUS "Configuring Bio-Formats Super-Build")

include(GNUInstallDirs)
include(ExternalProject)

# Helper functions and variables used by the following external projects.
include("${CMAKE_CURRENT_LIST_DIR}/ExternalProjectHelpers.cmake")

# External projects.
set(PREREQUISITES
    zlib
    bzip2
    png
    tiff
    icu
    boost
    xerces
    py-setuptools
    py-genshi
    py-markupsafe
    py-jinja2
    py-docutils
    py-pygments
    py-sphinx)
add_package(${PREREQUISITES} bioformats)

# Single target to build all prerequisites
add_custom_target(prerequisites
                  DEPENDS ${PREREQUISITES})

install(DIRECTORY ${BIOFORMATS_EP_INSTALL_DIR}/
        DESTINATION ${CMAKE_INSTALL_PREFIX}
        USE_SOURCE_PERMISSIONS)
