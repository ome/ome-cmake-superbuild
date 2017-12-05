# OME CMake super-build

This package provides a CMake super-build for the
[OME Files C++](http://github.com/ome/ome-files-cpp)
library, and other additional libraries.

Links
-----

- [Documentation](https://docs.openmicroscopy.org/latest/ome-files-cpp/ome-cmake-superbuild/manual/html/index.html)

Purpose
-------

Building all the prerequisite libraries on platforms not providing a
package manager can be quite painful.  This includes platforms such as
Microsoft Windows, or on older platforms without all the required
dependencies available via the package manager (such as CentOS 6/RHEL
6).  This package automates the building and installation of all
prerequisites, as well as Bio-Formats itself.


Supported platforms
-------------------

- Microsoft Windows with Visual Studio 2013 or 2015
- RHEL 6 and 7
- CentOS 6 and 7
- Ubuntu 14.04 and 16.04
- FreeBSD 11

More information
----------------

For more information, see the [documentation](https://docs.openmicroscopy.org/latest/ome-files-cpp/ome-cmake-superbuild/manual/html/index.html).
