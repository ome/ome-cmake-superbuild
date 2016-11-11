.. _ome-files-maint:

Maintenance
===========

This section describes various tasks which are performed on a periodic
basis to keep the codebase up to date with various third-party
packages.  This includes the versions used for the superbuild, and
ensuring that the code will compile against various upstream releases,
from the latest stable release to the versions in common use over a
range of platforms.  It also includes keeping the codebase usable as
the toolchains on the supported platforms are updated.

General package maintenance
---------------------------

Keep up to date with all new upstream releases of third-party
packages, in particular for security updates.  ``zlib`` and ``png``
are notable here, but this applies to all packages.  Check all
packages are the current stable version before making a new release.
In the case of a security vulnerability, it is possible to release and
provide builds with just the vulnerable package updated.

In the simple case of a package which requires no special additional
patching, for example ``png`` or ``zlib``, updating is as simple as
editing :file:`packages/<package>/superbuild.cmake`:

- update the source URL
- update the source hash

For a point release, this is typically sufficient.  For a major
release, also:

- check for any changes in the package prerequisites
- add or update missing prerequisites if required
- update the prerequisites if required

.. _maint_rediff:

Regenerating patches
--------------------

For packages containing patches under
:file:`packages/<package>/patches`, each patch will require
individually applying and re-diffing in sequence to regenerate them
against the new source release.

- download and unpack the source release
- make a copy of the source directory with a :file:`.orig` extension

For each patch in the order they are listed in the
`packages/<package>/patches/series` file:

- :program:`cd` to the source directory
- apply the patch with ``patch -p1 < <patchfile>``
- note any rejected hunks and apply these changes by hand as necessary
- delete any stray patch :file:`.orig` and :file:`.rej` files, and
  also any editor backup files e.g. :file`*~`
- :program:`cd` to the parent directory
- regenerate the diff with ``diff -urN <source>.orig <source> >
  <patchfile>`` and copy it back to the patch directory after checking
  it
- delete or rename the :file:`<source>.orig` directory, and then copy
  the source directory to :file:`<source>.orig`; this is to ensure
  that patches are applied on top of each other to avoid conflicts

This process can be managed with tools like :program:`quilt` if
preferred.

Note that the line ending style used in patch files matters.  It must
match the type used in the original source files or else it won't
apply.  The :file:`.gitattributes` should help on committing and
checking out files, but you do need to make sure you create the diff
on the correct operating system; i.e. don't diff Unix sources on
Windows, and double-check the line ending style of the patch matches
what was already committed.  If this is done incorrectly, the patch
will apply only on Unix or only on Windows.

Packages with specific requirements
-----------------------------------

The following packages require special care when upgrading or
maintaining.  Please follow the instructions exactly to avoid breakage
when upgrading to a new upstream version, and also refer to them when
making any other changes.

.. toctree::
    :maxdepth: 1
    :titlesonly:

    maintenance/boost
    maintenance/bzip2
    maintenance/icu
    maintenance/xalan
    maintenance/xerces

Toolchain support and standards conformance
-------------------------------------------

Currently the code is built and tested on several platforms,
including:

- FreeBSD with clang++ 3.4
- Linux with GCC 4.8 to 5.2
- MacOS X with clang++ (non-standard Mac LLVM/clang++ versions)
- Windows with VC12 and VC14 (Visual Studio 2013 and 2015)

Testing on a range of version combinations of compilers and platforms
is helpful in picking up bugs which would otherwise go undiagnosed
until encountered by an end-user.  For example, the FreeBSD builds
pick up problems which are not noticed on MacOS X by default, though
they could still occur in practice (e.g. since MacOS X has a
non-standard clang++ and libc++ which have a number of odd quirks).
There are also differences between compiler versions e.g. GCC on Linux
and clang++ on MacOS, making testing multiple versions useful to pick
up portability issues as early as practical.  We cannot test every
compiler and OS version, along with all the different versions of
third-party libraries we depend upon, so we make a best effort to test
as wide a range of what is in common use as possible.  Inevitably,
some issues will remain undiscovered if they are only seen with an
untested set of combinations.

Over time, OS releases will reach their end of life, and new
replacements will appear.  The test matrix will require adjusting to
add new platforms and drop old ones.  This should be straightforward,
but if the platform is new or significantly changed then it may
require code changes to correct any exposed portability issue or
latent bug which might break the CI builds.  It may also require
special-casing support for the platform; there are portability headers
in ome-common for this purpose, as well as CMake platform checks,
which may be updated as required to add support.

Feature testing and compatibility code
--------------------------------------

Currently, we support and test two separate sets of third-party
library versions for each supported platform:

- the libraries provided by the distribution's package management
  system, where applicable (includes homebrew on MacOS X)
- the libraries provided by the superbuild

The first ensures compatibility of our libraries and headers with the
system as a whole; this is necessary to allow use of our libraries
with all the libraries provided by the system.  The second ensures
that the current version of each library is buildable and usable
across all the supported platforms, and this allows for the use of
current libraries on older systems such as enterprise Linux
distributions.  This also means we test up to several versions of each
library, increasing our test coverage for portability and correctness
purposes.

Over time, portability workarounds we have put in place may be
dropped.  Examples include:

- dropping functionality checks and workarounds for functionality and
  behavior differences, e.g. missing filesystem functions and
  geometry and endian libraries in older Boost releases
- using the standard implementation of various functions,
  e.g. :cpp:class:`std::regex` in C++11, :cpp:func:`std::make_unique`
  in C++14, ``filesystem`` functions in C++17, where the Boost
  equivalents are currently used; this will reduce our dependency upon
  Boost over time, once the set of platforms we support all support
  the functionality we require; note that having the functionality
  does not make it usable, e.g. GCC has :cpp:class:`std::regex` but it
  is broken until 5.1 meaning that we need to use
  :cpp:class:`boost::regex` for the time being; use CMake feature
  tests to test that each feature is functional as well as present

Such changes should be safe to make with the existing test coverage we
have in place.
