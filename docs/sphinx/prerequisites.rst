Prerequisites
=============

Various software packages are required to be installed in order to
build from source.  Several of these may also be built and installed
by this super-build.  However, note that the super-build cannot
provide *all* prerequisites; some will still need installing before
building, shown in the table below.

.. tabularcolumns:: |l|l|l|c|c|c|

+----------------------+--------------+--------------+--------------------------------------+
|                      |           Version           |             When required            |
+----------------------+--------------+--------------+--------------+--------------+--------+
| Package              | Recommended  | Minimum      | Source build | Client build | Deploy |
+======================+==============+==============+==============+==============+========+
| :ref:`pkg_toolchain` |              |              |    \•        | \•           |        |
+----------------------+--------------+--------------+--------------+--------------+--------+
| :ref:`pkg_cmake`     | 3.9          | 3.4          |    \•        | \•           |        |
+----------------------+--------------+--------------+--------------+--------------+--------+
| :ref:`pkg_python2`   | 2.7.13       | 2.7.x        |    \•        | \•           |        |
+----------------------+--------------+--------------+--------------+--------------+--------+
| :ref:`pkg_git`       | 2.9.x        | 1.7.x        |    ◦         | ◦            |        |
+----------------------+--------------+--------------+--------------+--------------+--------+

\•
  Required
◦
  Optional, needed only if building from a git repository

Quick start
-----------

Install the following packages to build OME-Files C++.  A subset of
these packages (or their dependencies) may be used for deployment,
where the development package headers and tools for building
documentation etc. are not required.  Run the appropriate command
below for your platform to install the build dependencies:

Install the following:

- :ref:`pkg_toolchain`
- :ref:`pkg_cmake`
- :ref:`pkg_python2`
- :ref:`pkg_git`

Examples:

BSD Ports
  ``pkg install cmake python git``
Debian/Ubuntu
  ``apt-get install build-essential cmake python python-dev git``

Homebrew and RedHat/CentOS do not provide packages for everything that
is needed. The commands listed will install *most* of the
dependencies, but further dependencies will need to be installed as
described in various sections below.

Homebrew
  Install Xcode, then ``brew install cmake python git``
RedHat/CentOS
  ``yum groupinstall "Development Tools"``, then ``yum install python python-devel git``;
  install cmake by hand, or run ``yum install epel-release`` to enable the
  `EPEL <https://fedoraproject.org/wiki/EPEL>`__ package repository, which
  contains third-party prerequisites, and then ``yum install cmake3``.
  EPEL is not needed if third-party dependencies are to be built by
  the superbuild, but provides missing libraries including xalan, glm
  and qt5.

Additional prerequisites
------------------------

The super-build is a generic framework for building C++ software
components.  Depending upon which component (or components) are
requested to be built, additional prerequisites may be required.
Additionally, the super-build may be configured with different options
to customise the build, and this may also cause additional
prerequisites to be added.

.. toctree::
    :maxdepth: 1
    :titlesonly:

    prerequisites/ome-common
    prerequisites/ome-files
    prerequisites/ome-qtwidgets
    prerequisites/ome-model
