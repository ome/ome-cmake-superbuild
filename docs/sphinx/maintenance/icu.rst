.. _maint_icu:

icu
---

Releases are approximately six-monthly to annually.  In addition to
the general steps, the Windows solution and project files require
creating for the supported versions of Visual Studio.

- delete :file:`win-vc*.diff` files under :file:`packages/icu/patches`

For each Visual Studio version:

- unpack the new ICU sources
- make a copy of the sources (:file:`icu-nn.orig`)
- make a second copy of the source (:file:`icu-nn.vcmm`)
- start the Visual Studio application
- open :file:`icu-nn.vcmm/source/allinone/allinone.sln`, and allow
  Visual Studio to upgrade the projects to the current version
- save the solution (you must Save As to overwrite the existing
  solution; Save is insufficient)
- create a diff with ``diff -urN icu-nn.orig icu-nn.vcmm >
  win-vcmm.diff``
- copy the diff to :file:`packages/icu/patches/`
- ensure the patch is included in the corresponding
  :file:`series-vcmm` file
