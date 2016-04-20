# Install patch
include("${EP_SCRIPT_CONFIG}")
include("${GENERIC_CMAKE_ENVIRONMENT}")

if(WIN32)

  # Windows thinks any program with "patch" in the name
  # requires administrative privileges (which is wrong).
  # Work around by creating a manifest file.  See
  # https://sourceforge.net/p/gnuwin32/bugs/540/
  file(MAKE_DIRECTORY "${OME_EP_TOOL_DIR}/bin")
  file(WRITE "${OME_EP_TOOL_DIR}/bin/patch.exe.manifest"
"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>
<assembly xmlns=\"urn:schemas-microsoft-com:asm.v1\" manifestVersion=\"1.0\">
<trustInfo xmlns=\"urn:schemas-microsoft-com:asm.v3\">
<security>
<requestedPrivileges>
<requestedExecutionLevel level=\"asInvoker\" uiAccess=\"false\"/>
</requestedPrivileges>
</security>
</trustInfo>
</assembly>")

  file(COPY ${SOURCE_DIR}/bin/patch.exe
       DESTINATION "${OME_EP_TOOL_DIR}/bin")

endif()


