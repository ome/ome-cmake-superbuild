.. _pkg_toolchain:

Basic toolchain
---------------

A functional compiler, assembler and linker are required to build C++
code.  The C++ compiler must support the C++14 standard at a minimum,
Boost will be used to provide equivalent functionality for missing
features, where applicable.

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
  Available by default.
†
  Install the command-line tools for :program:`Xcode` with
  ``xcode-select --install`` or the full :program:`Xcode` application
  from the `Mac App Store <https://itunes.apple.com/gb/app/xcode/id497799835>`__.
‡
  Run ``yum groupinstall "Development Tools"``.  You should additionally
  install `Devtoolset-7
  <https://www.softwarecollections.org/en/scls/rhscl/devtoolset-7/>`__
  to obtain a more recent compiler than provided by the system if running
  CentOS 6 or 7.
§
  Install Visual Studio 2015 or 2013.  Any of the full versions or the
  free Community edition will work.  The Community edition may be
  downloaded `here
  <https://www.visualstudio.com/en-us/downloads/download-visual-studio-vs.aspx>`__.
