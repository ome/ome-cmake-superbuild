.. _pkg_gtest:

Google Test (gtest)
-------------------

The Google C++ unit test library.

+------------------+------------------+
| System           | Package          |
+==================+==================+
| BSD Ports        | devel/googletest |
+------------------+------------------+
| Debian/Ubuntu    | libgtest-dev     |
+------------------+------------------+
| Fedora           | gtest-devel      |
+------------------+------------------+
| Homebrew         | N/A*             |
+------------------+------------------+
| RedHat/CentOS    | gtest-devel      |
+------------------+------------------+

\*
  `gtest is not available in homebrew <http://answers.ros.org/question/42335/mac-os-x-install-error-no-available-formula-for-gtest/>`__

- `Website <https://github.com/google/googletest/>`__
- `Source download <https://github.com/google/googletest/archive/release-1.7.0.tar.gz>`__
- `Git tag <https://github.com/google/googletest/releases/tag/release-1.7.0>`__

Local builds
^^^^^^^^^^^^

If using a local build of gtest, make sure that :envvar:`GTEST_ROOT`
is set in the environment, or that ``-DGTEST_ROOT=/path/to/gtest`` is
passed to :program:`cmake` and that this points to the location where
the :program:`gtest` library was installed.  If the library is located
on the default library search path, this is not necessary.

