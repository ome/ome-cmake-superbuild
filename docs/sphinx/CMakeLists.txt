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

include(Options)
include(GNUInstallDirs)
include(Sphinx)

find_program(SPHINX_BUILD sphinx-build)
if (BUILD_SPHINX AND SPHINX_BUILD)
  message(STATUS "Checking manual page dependencies")

  # Create build directory and conf.py
  set(sphinx_srcdir "${PROJECT_SOURCE_DIR}")
  set(sphinx_builddir "${PROJECT_BINARY_DIR}")
  file(MAKE_DIRECTORY "${sphinx_builddir}")
  configure_file("${sphinx_srcdir}/conf.py.in"
                 "${sphinx_builddir}/conf.py"
                 @ONLY)

  sphinx_dependencies("${sphinx_srcdir}" SPHINX_DEPENDENCIES)

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

  install(DIRECTORY "${sphinx_builddir}/html"
          DESTINATION "${CMAKE_INSTALL_DOCDIR}/manual")

  if(sphinx-linkcheck)
    set(sphinx_linkcheck_all ALL)
  endif()

  add_custom_target(doc-remotelinkcheck ${sphinx_linkcheck_all}
                    COMMAND ${CMAKE_COMMAND}
                            "-DSPHINX_BUILD=${SPHINX_BUILD}"
                            "-DSPHINX_SRCDIR=${sphinx_srcdir}"
                            "-DSPHINX_BUILDDIR=${sphinx_builddir}"
                            "-DSPHINX_CACHEDIR=${sphinx_builddir}/cache"
                            "-DSPHINX_LINKCHECKDIR=${sphinx_builddir}/linkcheck"
                            "-DSPHINX_RELEASE=${DOC_VERSION_MAJOR}.${DOC_VERSION_MINOR}.${DOC_VERSION_PATCH}${DOC_VERSION_DEV}"
                            "-DSPHINX_VERSION=${DOC_VERSION_MAJOR}.${DOC_VERSION_MINOR}${DOC_VERSION_DEV}"
                            "-DSPHINX_INSTALL_PATH=${PROJECT_NAME}/manual/html"
                            -P "${CMAKE_CURRENT_LIST_DIR}/../../cmake/SphinxCheckRemoteLinks.cmake"
                     COMMENT "Checking remote links in sphinx documentation"
                     WORKING_DIRECTORY "${sphinx_srcdir}"
                     DEPENDS ${SPHINX_DEPENDENCIES})

  add_custom_target(doc-locallinkcheck ${sphinx_linkcheck_all}
                    COMMAND ${CMAKE_COMMAND}
                            "-DOUTPUT=${sphinx_builddir}/linkcheck/output.txt"
                            "-DSPHINX_INSTALL_PATH=${PROJECT_NAME}/manual/html"
                            "-DINTERNAL_REFERENCE=${sphinx_builddir}/html"
                            "-DEXTERNAL_REFERENCE=${CMAKE_INSTALL_FULL_DATAROOTDIR}/doc"
                            "-DDOXYGEN_REFERENCE="
                            "-DDOXYGEN_INSTALL_PATH="
                            -P "${CMAKE_CURRENT_LIST_DIR}/../../cmake/SphinxCheckInternalLinks.cmake"
                     COMMENT "Checking local links in sphinx documentation"
                     WORKING_DIRECTORY "${sphinx_srcdir}"
                     DEPENDS doc-remotelinkcheck)
else()
  message(WARNING "Manual pages and HTML manual will not be generated or installed")
endif()
