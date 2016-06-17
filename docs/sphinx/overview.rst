Overview
========

The OME CMake Super-Build provides a framework for building a
selection of OME C++ software components, and optionally their
dependencies.  This is intended to allow building of the entire
collection with a minimum of difficulty using any common operating
system, to provide an integrated collection of binary-compatible
libraries and tools.  The super-build currently targets UNIX-like
systems (FreeBSD, Linux, MacOS X) and Microsoft Windows.

Windows systems in particular make building software difficult, due to
the lack of support for obtaining copies of library dependencies built
for the specific C++ runtime required.  The super-build ensures that
all the libraries and programs built use the same runtime, as well as
the same compiler options, to ensure that all the libraries and
programs are compatible.

When building for a system which includes a package manager with a
comprehensive set of packages it may be desirable to disable building
of the third-party dependencies provided by the package manager.  This
is supported.  However, when building for older distributions with
outdated dependencies, it can be used to create a self-contained set
of newer libraries which won't conflict with the base platform.

The super-build can not provide *every* dependency.  Some very large
and complex packages are required to be installed using a package
manager or by hand when it is simply not practical to include them,
for example TeX Live or Qt5.

The super-build is entirely optional.  The individual packages may be
built completely by hand if desired.  The super-build provides
convenience and consistency across all the platforms it supports.
