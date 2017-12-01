.. _pkg_python2:

Python2
-------

The Python language intepreter, version 2.

+------------------+-------------+
| System           | Package     |
+==================+=============+
| BSD Ports        | lang/python |
+------------------+-------------+
| Debian/Ubuntu    | python      |
+------------------+-------------+
| Homebrew         | python      |
+------------------+-------------+
| RedHat/CentOS    | python      |
+------------------+-------------+

**Note:** the super-build requires the *development* version of
Python, which provides the Python headers. In some systems, this is
installed as a separate package, e.g., ``python-dev`` in Debian/Ubuntu
and ``python-devel`` in CentOS.

- `Website <https://www.python.org/>`__
- `Download <https://www.python.org/downloads/release/python-2713>`__

Windows
^^^^^^^

Windows is a little more difficult to set up, particularly if the
modules require building from source.  See these links for an easier
alternative:

- `Upgrade pip on Windows <https://pip.pypa.io/en/stable/installing/>`__
- `Extra packages for Windows <http://www.lfd.uci.edu/~gohlke/pythonlibs/>`__

Either download separate wheel packages from the above link, or ``pip
install`` needed packages; ensure downloaded packages are 64-bit if
using 64-bit Python.  In either case, the :program:`pip` tool is
required to install the packages.
