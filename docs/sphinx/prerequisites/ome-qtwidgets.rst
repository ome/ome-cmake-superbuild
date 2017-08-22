.. _prereq_ome_qtwidgets:

OME QtWidgets
=============

Various software packages are required to be installed in order to
build from source.  Several of these may also be built and installed
by this super-build.  However, note that the super-build cannot
provide *all* prerequisites; some will still need installing before
building, shown in the table below.

.. tabularcolumns:: |l|l|l|c|c|c|c|

+---------------+--------------+--------------+--------------------------------------------------+
|               |           Version           |                   When required                  |
+---------------+--------------+--------------+----------+---------------+--------------+--------+
| Package       | Recommended  | Minimum      | build    | superbuild    | client build | Deploy |
+===============+==============+==============+==========+===============+==============+========+
| OME Files     | 0.3.0        | 0.3.0        |    \•    |               | \•           | \•     |
+---------------+--------------+--------------+----------+---------------+--------------+--------+
| GLM           | 0.9.6        | 0.9.5        |    \•    | \•            | \•           |        |
+---------------+--------------+--------------+----------+---------------+--------------+--------+
| Qt5           | 5.2          | 5.0          |    \•    | \•            | \•           | \•     |
+---------------+--------------+--------------+----------+---------------+--------------+--------+
| Doxygen       | 1.8          | 1.6          |    †     | †             |              |        |
+---------------+--------------+--------------+----------+---------------+--------------+--------+
| Graphviz      | 2.x          | 1.8.10       |    †     | †             |              |        |
+---------------+--------------+--------------+----------+---------------+--------------+--------+

\•
  Required
◦
  Optional
†
  Optional, needed to build the API reference
