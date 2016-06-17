.. _maint_xerces:

xerces
------

Releases are infrequent.  In addition to the general steps, the
Windows solution and project files require creating for the supported
versions of Visual Studio.  Also, the project files at the time of
writing have broken ICU support and require manual fixing; the ICU
libraries are either missing entirely or the debug and release
variants are mixed up.  See the patch collection under
:file:`packages/xalan/patches`.  Each patch will require re-diffing
against the new release (see :ref:`maint_rediff`), with the exception
of the Windows VC patches, which need regenerating as follows:

- delete :file:`win-vc*.diff` files under :file:`packages/xerces/patches`

For each Visual Studio version:

- unpack the new xalan-c sources
- make a copy of the sources (:file:`xalan-c-nn.orig`)
- make a second copy of the source (:file:`xalan-c-nn.vcmm`)
- copy :file:`xalan-c-nn.vcmm/c/Projects/Win32/VC10/Xalan.sln` to
  :file:`xalan-c-nn.vcmm/c/Projects/Win32/VCmm/Xalan.sln`
- apply the following patch, shown here for VC11 but applies to all
  versions; if your version does not exist, make this change to the
  VC12 version::

    --- a/projects/Win32/VC11/xerces-all/XercesLib/XercesLib.vcxproj
    +++ b/projects/Win32/VC11/xerces-all/XercesLib/XercesLib.vcxproj
    @@ -538,7 +538,7 @@
         </ResourceCompile>
         <Link>
           <AdditionalOptions>%(AdditionalOptions)</AdditionalOptions>
    -      <AdditionalDependencies>ws2_32.lib;advapi32.lib;icuuc.lib;%(AdditionalDependencies)</AdditionalDependencies>
    +      <AdditionalDependencies>ws2_32.lib;advapi32.lib;icuucd.lib;%(AdditionalDependencies)</AdditionalDependencies>
           <OutputFile>$(TargetPath)</OutputFile>
           <AdditionalLibraryDirectories>%(AdditionalLibraryDirectories)</AdditionalLibraryDirectories>
           <GenerateDebugInformation>true</GenerateDebugInformation>
    @@ -578,7 +578,7 @@
           <Culture>0x0409</Culture>
         </ResourceCompile>
         <Link>
    -      <AdditionalDependencies>ws2_32.lib;advapi32.lib;%(AdditionalDependencies)</AdditionalDependencies>
    +      <AdditionalDependencies>ws2_32.lib;advapi32.lib;icuucd.lib;%(AdditionalDependencies)</AdditionalDependencies>
           <OutputFile>$(TargetPath)</OutputFile>
           <AdditionalLibraryDirectories>%(AdditionalLibraryDirectories)</AdditionalLibraryDirectories>
           <GenerateDebugInformation>true</GenerateDebugInformation>
    @@ -669,7 +669,7 @@
           <Culture>0x0409</Culture>
         </ResourceCompile>
         <Link>
    -      <AdditionalDependencies>ws2_32.lib;advapi32.lib;%(AdditionalDependencies)</AdditionalDependencies>
    +      <AdditionalDependencies>ws2_32.lib;advapi32.lib;icuuc.lib;%(AdditionalDependencies)</AdditionalDependencies>
           <OutputFile>$(TargetPath)</OutputFile>
           <AdditionalLibraryDirectories>%(AdditionalLibraryDirectories)</AdditionalLibraryDirectories>
           <GenerateDebugInformation>true</GenerateDebugInformation>

- check for a supported set of project files under
  :file:`projects/Win32/VC<ver>`; if a suitable version does not
  exist:

  - copy :file:`projects/Win32/VC12` (the latest at the time of
    writing) to :file:`projects/Win32/VC<ver>`; make sure you applied
    the patch in the previous step beforehand
  - start the Visual Studio application
  - open :file:`projects/Win32/VC<ver>/xerces-all/xerces-all.sln`, and
    allow Visual Studio to upgrade the projects to the current version
  - save the solution (you must Save As to overwrite the existing
    solution; Save is insufficient)

- create a diff with ``diff -urN xerces-c-nn.orig xerces-c-nn.vcmm >
  win-vcmm.diff``
- copy the diff to :file:`packages/xerces/patches/`
- ensure the patch is included in the :file:`series` file
