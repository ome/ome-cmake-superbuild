.. _errata:

Errata
======

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
