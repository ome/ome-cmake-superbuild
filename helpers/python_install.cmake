# Generic python installation
include("${EP_SCRIPT_CONFIG}")
include("${GENERIC_CMAKE_ENVIRONMENT}")

# Force use of setuptools even if distutils is in use.
set(shim
"import setuptools, tokenize
__file__ = 'setup.py'
exec(compile(getattr(tokenize, 'open', open)(__file__).read()
  .replace('\\r\\n', '\\n'), __file__, 'exec'))
")

file(TO_NATIVE_PATH "${BIOFORMATS_EP_PYTHON_DIR}" NATIVE_PYTHON_DIR)

execute_process(COMMAND python -c "${shim}" --no-user-cfg install "--prefix=${NATIVE_PYTHON_DIR}" --single-version-externally-managed --record=installed.txt
                WORKING_DIRECTORY "${SOURCE_DIR}"
                RESULT_VARIABLE install_result)

if(install_result)
  message(FATAL_ERROR "cmake: Install failed")
endif()
