# Bio-Formats CMake super-build

This package provides a CMake super-build for the
[Bio-Formats](http://github.com/openmicroscopy/bioformats) C++
library.


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

- Microsoft Windows with Visual Studio 2012 or 2013
- RHEL 6 and 7
- CentOS 6 and 7
- Ubuntu 12.04 and 14.04
- FreeBSD 10.2

More information
----------------

For more information, see the [Bio-Formats C++
documentation](http://www.openmicroscopy.org/site/support/bio-formats5.1/developers/cpp/overview.html).
