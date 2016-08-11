# Check "remote" sphinx links

message(STATUS "Checking remote links")

file(MAKE_DIRECTORY "${SPHINX_CACHEDIR}")
file(MAKE_DIRECTORY "${SPHINX_LINKCHECKDIR}")

execute_process(COMMAND ${SPHINX_BUILD}
                        -D "release=${SPHINX_RELEASE}"
                        -D "version=${SPHINX_VERSION}"
                        -c "${SPHINX_BUILDDIR}"
                        -d "${SPHINX_CACHEDIR}"
                        -b linkcheck
                        "${SPHINX_SRCDIR}"
                        "${SPHINX_LINKCHECKDIR}"
                RESULT_VARIABLE failed
                WORKING_DIRECTORY "${SPHINX_SRCDIR}")

if(failed)
  message(WARNING "Broken links detected")
endif()
