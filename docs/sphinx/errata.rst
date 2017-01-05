.. _errata:

Errata
======

Boost
-----

``apply_visitor`` and ``const`` references
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``apply_visitor`` fails to compile using ``const`` references with
using Boost 1.58 and a C++14 compiler.  This affects all platforms
using a C++14 compiler, but is most likely to affect Ubuntu 16.04
users, since the system provides Boost 1.58.  See the `trac ticket
<https://svn.boost.org/trac/boost/ticket/11285>`__ for further
information.

Solutions:

- Run cmake with ``-DCMAKE_CXX_STANDARD=11`` to force the use of C++11
- Use the newer version of Boost provided by the superbuild

Windows
-------

msbuild
^^^^^^^

Support for building on Windows with msbuild is currently
non-functional.

Solution:

- Run cmake with ``-G Ninja`` to use the Ninja generator.

``ome-files`` command
^^^^^^^^^^^^^^^^^^^^^

On Windows, ``ome-files info`` will display an error if run from a
directory containing a space in it.

Solutions:

- Move to a location without spaces in the path.
- Run ``libexec/ome-files/info.exe`` directly as a workaround.
