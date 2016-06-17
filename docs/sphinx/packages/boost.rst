.. _pkg_boost:

Boost
-----

The Boost libraries provide a wide range of functionality.  These are
used to supplement functionality not in the Standard Library or for
portability reasons.

+------------------+------------------+
| System           | Package          |
+==================+==================+
| BSD Ports        | devel/boost-all  |
+------------------+------------------+
| Debian/Ubuntu    | libboost-all-dev |
+------------------+------------------+
| Homebrew         | boost            |
+------------------+------------------+
| RedHat/CentOS    | boost-devel*     |
+------------------+------------------+

\*
  RHEL/CentOS 6 users might want to look at the `Boost 1.48 SCL
  <https://www.softwarecollections.org/en/scls/denisarnaud/boost148/>`_
  or build a more recent Boost release.

Considerations:

- 1.48 or later needed for Boost.Geometry
- 1.54 or later needed for Boost.Geometry spatial indexes.
