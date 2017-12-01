.. _pkg_python_sphinx:

Python2 Sphinx
--------------

The :program:`sphinx-build` and related tools, used to generate
documentation from restructured text markup in several formats,
including HTML and PDF.

+------------------+---------------------+
| System           | Package             |
+==================+=====================+
| BSD Ports        | textproc/py-sphinx* |
+------------------+---------------------+
| Debian/Ubuntu    | python-sphinx       |
+------------------+---------------------+
| Fedora           | python-sphinx       |
+------------------+---------------------+
| Homebrew         | N/A (use pip)       |
+------------------+---------------------+
| RedHat/CentOS    | python-sphinx†      |
+------------------+---------------------+

\*
  If using :program:`pkg`, install ``py27-sphinx``.
†
  From EPEL.

Use ``pip install sphinx`` if a packaged version is not available, or
if you want a current version.
