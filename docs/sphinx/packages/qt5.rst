.. _pkg_qt5:

Qt5
---

The Qt library collection, version 5.  This is a collection of several
cross-platform libraries, primarily oriented around a GUI toolkit.
Used for cross-platform OpenGL rendering.

+------------------+----------------------------------------------+
| System           | Package                                      |
+==================+==============================================+
| BSD Ports        | devel/qt5                                    |
+------------------+----------------------------------------------+
| Debian/Ubuntu    | qt5-default libqt5opengl5-dev libqt5svg5-dev |
+------------------+----------------------------------------------+
| Homebrew         | qt5*                                         |
+------------------+----------------------------------------------+
| RedHat/CentOS    | N/A                                          |
+------------------+----------------------------------------------+

\*
  Add :file:`/usr/local/opt/qt5/bin` to :envvar:`PATH`

- `Website <http://www.qt.io/>`__
- `Download <http://www.qt.io/download/>`__

MacOS X homebrew
^^^^^^^^^^^^^^^^

If ``qt5`` is installed, for building the :ref:`prereq_ome_qtwidgets`
component, ensure that :file:`/usr/local/opt/qt5/bin` is on the
:envvar:`PATH` to allow Qt to be autodetected by :program:`cmake`.
