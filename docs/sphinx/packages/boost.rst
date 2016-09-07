.. _pkg_boost:

Boost
-----

The Boost libraries provide a wide range of functionality.  These are
used to supplement functionality not in the Standard Library or for
portability reasons.

+------------------+-------------------+
| System           | Package           |
+==================+===================+
| BSD Ports        | devel/boost-all   |
+------------------+-------------------+
| Debian/Ubuntu    | libboost-all-dev* |
+------------------+-------------------+
| Homebrew         | boost             |
+------------------+-------------------+
| RedHat/CentOS    | boost-devel†      |
+------------------+-------------------+

\*
  Ubuntu 14.04 users should install ``libboost1.55-all-dev`` rather
  than the generic package, to build with Boost 1.55 rather than the
  default 1.54 version.

†
  RHEL/CentOS 6 users should build a more recent Boost release.

Considerations:

- 1.48 or later needed for Boost.Geometry
- 1.54 or later needed for Boost.Geometry spatial indexes.
