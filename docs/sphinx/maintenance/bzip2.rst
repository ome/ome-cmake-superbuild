.. _maint_bzip2:

bzip2
-----

Not released very frequently.  In addition to the general steps, we
patch the source to add a custom CMake build
(:file:`packages/bzip2/patches/cmake.diff`) which requires updating:

- update the release version and shared library version in
  :file:`CMakeLists.txt`
- check that the source file list in :file:`CMakeLists.txt` is
  up to date (a diff of the old and new bzip2 sources will show the
  changes in the upstream build files)
