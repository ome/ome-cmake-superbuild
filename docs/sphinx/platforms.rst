Supported platforms
===================

The OME C++ software components are written using portable,
cross-platform C++.  The components and their dependencies are tested
on a daily basis and are proven to work on a set of core platforms
(they build without error and pass their unit and integration tests).
Builds are provided for each release for these platforms.  The support
status for these is as follows:

+---------------+--------------+--------------+--------------+-------------+
|               |           Version           |         Build type         |
+---------------+--------------+--------------+--------------+-------------+
| System        | Recommended  | Minimum      | Platform     | Super-Build |
+===============+==============+==============+==============+=============+
| CentOS        | 7            | 6            | Unsupported* | Supported   |
+---------------+--------------+--------------+--------------+-------------+
| Debian        | 8            | 7            | Unsupported  | Unsupported |
+---------------+--------------+--------------+--------------+-------------+
| FreeBSD       | 11           | 10           | Supported†   | Supported   |
+---------------+--------------+--------------+--------------+-------------+
| MacOS X       | 10.11        | 10.9         | Supported‡   | Supported   |
+---------------+--------------+--------------+--------------+-------------+
| Ubuntu        | 16.04        | 14.04        | Supported    | Supported   |
+---------------+--------------+--------------+--------------+-------------+
| Windows       | VS2015       | VS2013       | Unsupported§ | Supported   |
+---------------+--------------+--------------+--------------+-------------+

\*
  CentOS does not provide all the prequired libraries; CentOS 6
  provides a broken version of Boost and an obsolete libtiff, so using
  the Super-Build or building new versions of the needed libraries is
  a requirement.

†
  With 11 only; 10 may work with ports built with a newer toolchain.

‡
  Supported via homebrew.

§
  Windows does not have a package manager or provide any third-party
  libraries for a given Visual Studio version; either use the
  Super-Build or build the needed libraries yourself.

"Platform" builds are builds of the OME C++ components with
third-party library and tool dependencies provided by the platform,
i.e. the operating system's package manager.  Systems without a
package manager, or with missing or outdated packages, can not support
these builds.  "Super-Build" builds are builds of the OME C++
components with all third-party dependencies built at the same time,
and are supported by all platforms irrespective of whether the
platform also provides the needed packages.  Both of these build types
are tested by the OME continuous integration infrastructure.

Note that *unsupported* does not mean that the software will not build
or run on these platforms.  It means that it has not been tested and
proven to work on the OME continuous integration infrastructure.  If
you are using a platform not included in the above table, please do
give it a try and let us know.  This also includes older versions of
the above platforms with versions less than the minimum supported
version.  If there is demand for additional platforms, we can look
into including them in our supported set providing we have the
resources to do so.
