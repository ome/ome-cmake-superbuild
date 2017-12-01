.. _pkg_python_virtualenv:

Python2 Virtualenv
------------------

The Python2 virtual environment module.  The super-build will
create a virtualenv to install and use needed Python modules.

+------------------+----------------------+
| System           | Package              |
+==================+======================+
| BSD Ports        | devel/py-virtualenv* |
+------------------+----------------------+
| Debian/Ubuntu    | python-virtualenv†   |
+------------------+----------------------+
| Fedora           | python-virtualenv    |
+------------------+----------------------+
| Homebrew         | N/A (use pip‡)       |
+------------------+----------------------+
| RedHat/CentOS    | python-virtualenv    |
+------------------+----------------------+

\*
  If using :program:`pkg`, install ``py27-virtualenv``.
†
  Do not confuse with the ``virtualenv`` package, which is the
  :program:`virtualenv` command, not the Python module, and will not
  be sufficient.
‡
  Run ``/usr/local/bin/python2 -m pip install virtualenv``.

Use ``pip install virtualenv`` if a packaged version is not
available, or if you want a current version.
