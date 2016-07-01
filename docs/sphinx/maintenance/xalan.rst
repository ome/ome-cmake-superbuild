.. _maint_xalan:

xalan
-----

Releases are infrequent.  In addition to the general steps, the
Windows solution and project files require creating for the supported
versions of Visual Studio.  Also, the project files at the time of
writing have broken ICU support and require special patching to
function.  See the patch collection under
:file:`packages/xalan/patches`.  Each patch will require re-diffing
against the new release (see :ref:`maint_rediff`), with the exception
of the Windows VC patches, which need regenerating as follows:

- delete :file:`win-vc*.diff` files under :file:`packages/xalan/patches`

For each Visual Studio version:

- unpack the new xalan-c sources
- make a copy of the sources (:file:`xalan-c-nn.orig`)
- make a second copy of the source (:file:`xalan-c-nn.vcmm`)
- copy :file:`xalan-c-nn.vcmm/c/Projects/Win32/VC10/Xalan.sln` to
  :file:`xalan-c-nn.vcmm/c/Projects/Win32/VCmm/Xalan.sln`
- start the Visual Studio application
- open :file:`xalan-c-nn.vcmm/c/Projects/Win32/VCmm/Xalan.sln`, and
  allow Visual Studio to upgrade the projects to the current version
- save the solution (you must Save As to overwrite the existing
  solution; Save is insufficient)

- apply this change to :file:`XalanExe.vcxproj` (shown here for
  VC12)::

    --- a/VC12/XalanExe/XalanExe.vcxproj
    +++ b/VC12/XalanExe/XalanExe.vcxproj
    @@ -546,11 +546,11 @@
         <ClCompile Include="..\..\..\..\src\xalanc\XalanExe\XalanExe.cpp" />
       </ItemGroup>
       <ItemGroup>
    -    <ProjectReference Include="..\AllInOne\AllInOne.vcxproj">
    +    <ProjectReference Include="..\AllInOne\AllInOne.vcxproj" Condition="'$(Configuration)'=='Debug' Or '$(Configuration)'=='Release'">
           <Project>{e1d6306e-4ff8-474a-be7f-45dcba4888b6}</Project>
           <ReferenceOutputAssembly>false</ReferenceOutputAssembly>
         </ProjectReference>
    -    <ProjectReference Include="..\AllInOne\AllInOneWithICU.vcxproj">
    +    <ProjectReference Include="..\AllInOne\AllInOneWithICU.vcxproj" Condition="'$(Configuration)'=='Debug with ICU' Or '$(Configuration)'=='Release with ICU'">
           <Project>{755ad11c-80b9-4e33-9d3d-9a68884a3ec8}</Project>
           <ReferenceOutputAssembly>false</ReferenceOutputAssembly>
         </ProjectReference>

- create a diff with ``diff -urN xalan-c-nn.orig xalan-c-nn.vcmm >
  win-vcmm.diff``
- copy the diff to :file:`packages/xalan/patches/`
- ensure the patch is included in the :file:`series` file
