.. _maint_boost:

Boost
-----

Boost releases are approximately every six months.  In addition to the
general steps:

- update `FindBoost.cmake
  <https://gitlab.kitware.com/cmake/cmake/blob/master/Modules/FindBoost.cmake>`__
  (also on `GitHub
  <https://github.com/Kitware/CMake/blob/master/Modules/FindBoost.cmake>`__;
  this includes the supported versions and the dependency information;
  instructions are in the comments in :file:`FindBoost.cmake`
- open a PR against `cmake.git
  <https://gitlab.kitware.com/cmake/cmake>`__ and send the patch to
  the `mailing list
  <https://cmake.org/mailman/listinfo/cmake-developers>`__ (also on
  `GitHub <https://github.com/Kitware/CMake>`__
- update the embedded copy of :file:`FindBoost.cmake` in all OME
  components so that they can detect and use the new Boost version

Updating the upstream version is needed to keep our code in sync with
the canonical version.  It is also a necessary requirement for
end-users to be able to use our exported dependency information in
their projects.  It may be the case that the Boost project will
provide CMake configuration files in the future, containing the
dependency information; at this point the embedded
:file:`FindBoost.cmake` may be dropped entirely.
