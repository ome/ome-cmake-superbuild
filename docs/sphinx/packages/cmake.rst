.. _pkg_cmake:

CMake
-----

CMake is a meta-build system used to generate the build files for a
chosen build tool or IDE.  It is currently used for all OME C++
components and is required for building them.

+------------------+-------------+
| System           | Package     |
+==================+=============+
| BSD Ports        | devel/cmake |
+------------------+-------------+
| Debian/Ubuntu    | cmake       |
+------------------+-------------+
| Homebrew         | cmake       |
+------------------+-------------+
| RedHat/CentOS    | cmake3*     |
+------------------+-------------+

\*
  From EPEL.  Note that the commands have a ``3`` suffix, and and are
  named :program:`cmake3`, :program:`ctest3` etc.

- `Website <https://cmake.org/>`__
- `Download <https://cmake.org/download/>`__
