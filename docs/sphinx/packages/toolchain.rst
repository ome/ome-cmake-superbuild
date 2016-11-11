.. _pkg_toolchain:

Basic toolchain
---------------

A functional compiler, assembler and linker are required to build C++
code.  The C++ compiler must support the C++11 standard at a minimum,
with the C++14 standard being preferred.

+------------------+-----------------+
| System           | Package         |
+==================+=================+
| BSD Ports        | N/A*            |
+------------------+-----------------+
| Debian/Ubuntu    | build-essential |
+------------------+-----------------+
| Homebrew         | N/A†            |
+------------------+-----------------+
| RedHat/CentOS    | N/A‡            |
+------------------+-----------------+
| Windows          | N/A§            |
+------------------+-----------------+

\*
  Available by default
†
  Install :program:`Xcode` from the `Mac App Store <https://itunes.apple.com/gb/app/xcode/id497799835>`__
‡
  Run ``yum groupinstall "Development Tools"``.  For RHEL6/CentOS 6,
  you might additionally want to install `Devtoolset-4
  <https://www.softwarecollections.org/en/scls/rhscl/devtoolset-4/>`__
  to obtain a more recent compiler.
§
  Install Visual Studio 2015 or 2013.  Any of the full versions or the
  free Community edition will work.  The Community edition may be
  downloaded `here
  <https://www.visualstudio.com/en-us/downloads/download-visual-studio-vs.aspx>`__
