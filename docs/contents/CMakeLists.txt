# #%L
# OME Files C++ libraries (cmake build infrastructure)
# %%
# Copyright © 2015 Open Microscopy Environment:
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

# Add our own modules to the include path
list(APPEND CMAKE_MODULE_PATH
     "${CMAKE_CURRENT_LIST_DIR}/../../cmake")

project(ome-cmake-superbuild)

include(GNUInstallDirs)
include("${CMAKE_CURRENT_LIST_DIR}/../../Options.cmake")
include(Sphinx)

find_program(SPHINX_BUILD sphinx-build)
if (BUILD_SPHINX AND SPHINX_BUILD)
  message(STATUS "Checking manual page dependencies")

  set(docdir "${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_DATAROOTDIR}/doc")
  file(GLOB manuals RELATIVE "${docdir}" "${docdir}/ome-*/manual/html/index.html")
  file(GLOB apirefs RELATIVE "${docdir}" "${docdir}/ome-*/api/html/index.html")
  list(SORT manuals)
  list(SORT apirefs)

  foreach(man IN LISTS manuals)
    string(REGEX REPLACE "^([^/]+)/.*" "\\1" man_name "${man}")
    set(manual_links "${manual_links}
- `${man_name} <${man}>`__")
  endforeach()

  foreach(api IN LISTS apirefs)
    string(REGEX REPLACE "^([^/]+)/.*" "\\1" api_name "${api}")
    set(apiref_links "${apiref_links}
- `${api_name} <${api}>`__")
  endforeach()

  # Create build directory and generate sources
  set(sphinx_srcdir "${PROJECT_BINARY_DIR}")
  set(sphinx_builddir "${PROJECT_BINARY_DIR}")
  file(MAKE_DIRECTORY "${sphinx_builddir}")
  configure_file("${PROJECT_SOURCE_DIR}/conf.py.in"
                 "${sphinx_builddir}/conf.py"
                 @ONLY)
  configure_file("${PROJECT_SOURCE_DIR}/index.rst.in"
                 "${sphinx_builddir}/index.rst"
                 @ONLY)
  file(COPY "${PROJECT_SOURCE_DIR}/../sphinx/images"
       DESTINATION "${sphinx_builddir}")
  file(COPY "${PROJECT_SOURCE_DIR}/../sphinx/_templates"
       DESTINATION "${sphinx_builddir}")

  # Generate and install HTML manual

  add_custom_command(OUTPUT "${sphinx_builddir}/html/index.html"
                     COMMAND ${CMAKE_COMMAND} -E make_directory "${sphinx_builddir}/cache"
                     COMMAND ${CMAKE_COMMAND} -E make_directory "${sphinx_builddir}/html"
                     COMMAND ${SPHINX_BUILD}
                             -D "release=${DOC_VERSION_MAJOR}.${DOC_VERSION_MINOR}.${DOC_VERSION_PATCH}${DOC_VERSION_DEV}"
                             -D "version=${DOC_VERSION_MAJOR}.${DOC_VERSION_MINOR}${DOC_VERSION_DEV}"
                             -c "${sphinx_builddir}"
                             -d "${sphinx_builddir}/cache"
                             -b html
                             "${sphinx_srcdir}" "${sphinx_builddir}/html"
                     WORKING_DIRECTORY "${sphinx_srcdir}"
                     DEPENDS ${SPHINX_DEPENDENCIES})

  add_custom_target(doc-html ALL DEPENDS "${sphinx_builddir}/html/index.html")

  install(DIRECTORY "${sphinx_builddir}/html/"
          DESTINATION "${docdir}")
else()
  message(WARNING "Manual pages and HTML manual will not be generated or installed")
endif()
