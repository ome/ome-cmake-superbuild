@echo off
REM Build with Jenkins CI.  This script is intended for use with the OME
REM Jenkins CI infrastructure, though it may be useful as an example for
REM how one might use various cmake options.

REM So that statements like "set" work inside nested conditionals
setlocal ENABLEDELAYEDEXPANSION
setlocal ENABLEEXTENSIONS

set "script=%0"

set "workspace=%~dp0\.."
set "sourcedir=%workspace%\source"
set "builddir=%workspace%\build"
set "installdir=%workspace%\install"
set "artefactdir=%workspace%\artefacts"
set "cachedir=%workspace%\cache"
set "cygwindir=C:\CYGWIN64\BIN"
set "qtdir=C:\Qt\5.7"

set git_branch=HEAD
set purge=none
set build_type=Debug
set build_arch=x64
set build_version=12
set build_system=MSBuild
set build_number=
set doxygen=OFF
set linkcheck=OFF
set extended_tests=OFF
set verbose=OFF
set parallel=
set parallel_opt=OFF
set build_git=OFF
set action=build
set qt=OFF
set "packages=ome-files;ome-cmake-superbuild-docs;ome-cmake-superbuild-docs-contents"

REM Parse command line options.
:loop
if NOT "%1"=="" (
    if "%1"=="-h" (
        goto usage
    )
    if "%1"=="-B" (
        set action=build
    )
    if "%1"=="-G" (
        set "build_git=ON"
    )
    if "%1"=="-q" (
        set "qt=ON"
        set "packages=%packages%;ome-qtwidgets"
    )
    if "%1"=="-d" (
        set "doxygen=ON"
    )
    if "%1"=="-L" (
        set "linkcheck=ON"
    )
    if "%1"=="-e" (
        set "extended_tests=ON"
    )
    if "%1"=="-P" (
        set "parallel_opt=ON"
    )
    if "%1"=="-v" (
        set "verbose=ON"
    )
    if "%1"=="-i" (
        set "installdir=%2"
        shift
    )
    if "%1"=="-b" (
        set "builddir=%2"
        shift
    )
    if "%1"=="-c" (
        set "cachedir=%2"
        shift
    )
    if "%1"=="-a" (
        set "artefactdir=%2"
        shift
    )
    if "%1"=="-g" (
        set "git_branch=%2"
        shift
    )
    if "%1"=="-p" (
        set "purge=%2"
        shift
    )
    if "%1"=="-A" (
        set "build_arch=%2"
        shift
    )
    if "%1"=="-V" (
        set "build_version=%2"
        shift
    )
    if "%1"=="-t" (
        set "build_type=%2"
        shift
    )
    if "%1"=="-S" (
        set "build_system=%2"
        shift
    )
    if "%1"=="-w" (
        set "workspace=%2"
        set "sourcedir=!workspace!\source"
        set "builddir=!workspace!\build"
        set "installdir=!workspace!\install"
        set "artefactdir=!workspace!\artefacts"
        set "cachedir=!workspace!\cache"
        shift
    )
    if "%1"=="-s" (
        set "sourcedir=%2"
        shift
    )
    if "%1"=="-j" (
        set "parallel=/m:%2"
        shift
    )
    if "%1"=="-N" (
        set "build_number=%2"
        shift
    )
    if "%1"=="-Y" (
        set "cygwindir=%2"
        shift
    )
    if "%1"=="-Q" (
        set "qtdir=%2"
        shift
    )

    shift
    goto :loop
)

echo workspace=%workspace%
echo sourcedir=%sourcedir%
echo builddir=%builddir%
echo installdir=%installdir%
echo artefactdir=%artefactdir%
echo cachedir=%cachedir%
echo cygwindir=%cygwindir%
echo qtdir=%qtdir%

echo git_branch=%git_branch%
echo purge=%purge%
echo build_type=%build_type%
echo build_arch=%build_arch%
echo build_version=%build_version%
echo build_system=%build_system%
echo doxygen=%doxygen%
echo linkcheck=%linkcheck%
echo extended_tests=%extended_tests%
echo verbose=%verbose%
echo parallel=%parallel%
echo build_git=%build_git%
echo qt=%qt%

goto main

:usage

call :heredoc usagetext && goto usageexit:
Usage: !script! [options]

Actions:
  -h         Display this help text
  -B         Build and install (default action)

Options:
  -w dir     Set workspace directory (sets defaults for all directory paths below)
  -s dir     Set source directory
  -b dir     Set build directory
  -i dir     Set installation directory
  -a dir     Set artefact directory
  -c dir     Set cache directory
  -Y dir     Set Cygwin directory (used for zip/unzip)
  -Q dir     Set Qt5 directory (used for ome-qtwidgets)

  -g branch  Set git branch or tag to release from
  -G         Build from git (rather than the default source release archive)
  -p mode    Purge cache (none|all|build|tools)
  -t type    Build type (Debug|Release)
  -A arch    Build architecture (x86|x64)
  -V VCver   Build with VisualC version
  -S system  Build system (MSBuild|Ninja)
  -d         Build doxygen API reference
  -L         Run sphinx link checks
  -e         Run extended tests
  -q         Build Qt interface
  -j n       Build in parallel
  -P         Enable paralellism in subsidiary builds
  -N n       Build number
  -v         Verbose build
:usageexit
exit /b

:main

REM Purge cache if required

set PURGE_SOURCE=false
set PURGE_BUILD=false

if [%purge%] == [all] set PURGE_SOURCE=true
if [%purge%] == [all] set PURGE_BUILD=true
if [%purge%] == [source] set PURGE_SOURCE=true
if [%purge%] == [build] set PURGE_BUILD=true

REM Get current tree hashes
cd "%sourcedir%"
for /f %%i in ('git log -1 "--pretty=%%T" "%git_branch%" --') do set CURRENT_TREE=%%i
echo Current tree: %CURRENT_TREE%
if exist "%cachedir%\tree" (
    set /p CACHED_TREE=<"%cachedir%\tree"
)
echo Cached tree: %CACHED_TREE%

if exist "%cachedir%\tree" (
    if [%PURGE_BUILD%] == [true] (
        echo "Requested purging of build cache"
    ) else (
        if NOT [%CURRENT_TREE%] == [%CACHED_TREE%] (
            echo "Changes made; purging build cache"
            set PURGE_BUILD=true
        ) else (
            echo "No changes; retaining build cache"
        )
    )
) else (
    echo "Build cache not present or incomplete"
)

if [%PURGE_SOURCE%] == [true] (
    if exist "%cachedir%\source" (
        rmdir /s /q "%cachedir%\source"
    )
    if exist "%cachedir%\tools" (
        rmdir /s /q "%cachedir%\tools"
    )
)

if [%PURGE_BUILD%] == [true] (
    if exist "%cachedir%\build" (
        rmdir /s /q "%cachedir%\build"
    )
    if exist "%cachedir%\tools-build" (
        rmdir /s /q "%cachedir%\tools-build"
    )
    if exist "%cachedir%\tree" (
        del "%cachedir%\tree"
    )
)

if NOT exist "%cachedir%" mkdir "%cachedir%"
if NOT exist "%cachedir%\source" mkdir "%cachedir%\source"


REM Use build cache if present; set environment so it's detected by
REM cmake and exclude cached prerequisites from build.  Note that
REM since gtest isn't installed and cached, so we still need to
REM build it.

cd "%workspace%"
if exist "build" (
    rmdir /s /q "build"
)
if exist "install" (
    rmdir /s /q "install"
)
mkdir build
mkdir install
mkdir install\stage
cd build

if exist "%cachedir%\tree" (
    set "CMAKE_PREREQS=-Dbuild-cache:PATH=%cachedir%\build -Dtool-build-cache:PATH=%cachedir%\tools-build -Dbuild-prerequisites:BOOL=OFF -Dome-cmake-superbuild_BUILD_gtest:BOOL=ON"
) else (
    set "CMAKE_PREREQS=-Dbuild-prerequisites:BOOL=ON"
)

if [%build_git%] == [ON] (
    set "GIT_OPTIONS=-Dome-model-dir=%workspace%\ome-model -Dome-files-dir=%workspace%\ome-files -Dome-common-dir=%workspace%\ome-common -Dome-qtwidgets-dir=%workspace%\ome-qtwidgets"
)

if [%qt%] == [ON] (
    if [%build_version%] == [12] (
        set "qt_root=!qtdir!\msvc2013"
    )
    if [%build_version%] == [14] (
        set "qt_root=!qtdir!\msvc2013"
    )
    if [%build_arch%] == [x86] (
        set "qt_root=!qt_root!_32"
    ) else (
        set "qt_root=!qt_root!_64"
    )
    if NOT exist "!qt_root!" (
        echo Warning: Qt5 root !qt_root! does not exist
    )
    set "CMAKE_PATH_PREFIX=!qt_root!"
    set "PATH=!qt_root!\bin;!PATH!"
)

if [%build_system%] == [MSBuild] (
    if [%build_arch%] == [x86] (
        set "ARCH="
    ) else (
        set "ARCH= Win64"
    )
    if [%build_version%] == [11] (
        set "GEN=Visual Studio 11 2012!ARCH!"
    )
    if [%build_version%] == [12] (
        set "GEN=Visual Studio 12 2013!ARCH!"
    )
    if [%build_version%] == [14] (
        set "GEN=Visual Studio 14 2015!ARCH!"
    )

    cmake -G "!GEN!" ^
      -DCMAKE_INSTALL_PREFIX:PATH=%installdir%\stage ^
      %GIT_OPTIONS% ^
      -Ddoxygen:BOOL=%doxygen% ^
      -Dextended-tests=%extended_tests% ^
      -Dbuild-packages=%packages% ^
      -Dparallel:BOOL=%parallel_opt% ^
      -Dsphinx:BOOL=ON ^
      -Dsphinx-linkcheck:BOOL=%linkcheck% ^
      -Dsource-cache:PATH=%cachedir%\source ^
      -Dtool-cache:PATH=%cachedir%\tools ^
      %CMAKE_PREREQS% ^
      %sourcedir% ^
      || exit /b

REM Make and cache prerequisites if missing
    if NOT exist "%cachedir%\tree" (
        cmake --build . --config %build_type% --target third-party-prerequisites -- %parallel% || exit /b

        if exist "%cachedir%\build" (
            rmdir /s /q "%cachedir%\build"
        )
        if exist "%cachedir%\tools-build" (
            rmdir /s /q "%cachedir%\tools-build"
        )
        (robocopy stage "%cachedir%\build" /e >nul) ^& IF %ERRORLEVEL% GTR 3 exit /b
        (robocopy tools "%cachedir%\tools-build" /e >nul) ^& IF %ERRORLEVEL% GTR 3 exit /b
        cd "%sourcedir%"
        git log -1 --pretty=%%T "%git_branch%" -- >%cachedir%\tree
        cd "%builddir%"
    )

    cmake --build . --config %build_type% -- %parallel% || exit /b
    cmake --build . --config %build_type% --target install || exit /b

    call ome-files-build\config.bat
)
if [%build_system%] == [Ninja] (
    set "PATH=C:\Tools\ninja;%PATH%"

    if [%build_version%] == [11] (
        call "%VS110COMNTOOLS%..\..\VC\vcvarsall.bat" %build_arch%
    )
    if [%build_version%] == [12] (
        call "%VS120COMNTOOLS%..\..\VC\vcvarsall.bat" %build_arch%
    )
    if [%build_version%] == [14] (
        call "%VS140COMNTOOLS%..\..\VC\vcvarsall.bat" %build_arch%
    )

    cmake -G "Ninja" ^
      -DCMAKE_VERBOSE_MAKEFILE:BOOL=%verbose% ^
      -DCMAKE_INSTALL_PREFIX:PATH=%installdir%\stage ^
      -DCMAKE_BUILD_TYPE=%build_type% ^
      %GIT_OPTIONS% ^
      -Ddoxygen:BOOL=%doxygen% ^
      -Dextended-tests=%extended_tests% ^
      -Dbuild-packages=%packages% ^
      -Dparallel:BOOL=%parallel_opt% ^
      -Dsphinx:BOOL=ON ^
      -Dsphinx-linkcheck:BOOL=%linkcheck% ^
      -Dsource-cache:PATH=%cachedir%\source ^
      -Dtool-cache:PATH=%cachedir%\tools ^
      %CMAKE_PREREQS% ^
      %sourcedir% ^
      || exit /b

REM Make and cache prerequisites if missing
    if NOT exist "%cachedir%\tree" (
        cmake --build . --config %build_type% --target third-party-prerequisites || exit /b

        if exist "%cachedir%\build" (
            rmdir /s /q "%cachedir%\build"
        )
        if exist "%cachedir%\tools-build" (
            rmdir /s /q "%cachedir%\tools-build"
        )
        (robocopy stage "%cachedir%\build" /e >nul) ^& IF %ERRORLEVEL% GTR 3 exit /b
        (robocopy tools "%cachedir%\tools-build" /e >nul) ^& IF %ERRORLEVEL% GTR 3 exit /b
        cd "%sourcedir%"
        git log -1 --pretty=%%T "%git_branch%" -- >%cachedir%\tree
        cd "%builddir%"
    )

    cmake --build . || exit /b
    cmake --build . --target install || exit /b

    call ome-files-build\config.bat
)

REM Release version
set "version_tag=ome-files-bundle-%OME_VERSION%-VC%build_version%-%build_arch%-%build_type%"
if defined build_number set "version_tag=%version_tag%-b%build_number%"
set "docs_version_tag=ome-files-bundle-docs-%OME_VERSION%"
if defined build_number set "docs_version_tag=%docs_version_tag%-b%build_number%"

echo Built and installed version %version_tag%

set "PATH=%cygwindir%;%PATH%"

cd "%installdir%"

REM Add version to archive name
echo Renaming staged install to %version_tag%
if exist "%version_tag%" rmdir /s /q "%version_tag%"
rename stage %version_tag%

mkdir "%installdir%\%docs_version_tag%"
for %%C in (ome-common,ome-model,ome-xml,ome-files,ome-qtwidgets,ome-cmake-superbuild) do (
    if exist "%builddir%\stage\share\doc\%%C" (
        echo Installing documentation for %%C
        (robocopy "%builddir%\stage\share\doc\%%C" "%installdir%\%docs_version_tag%\%%C" /e >nul) ^& IF %ERRORLEVEL% GTR 3 exit /b
    )
)
(robocopy "%builddir%\stage\share\doc"          "%installdir%\%docs_version_tag%" "*.html"       >nul) ^& IF %ERRORLEVEL% GTR 3 exit /b
(robocopy "%builddir%\stage\share\doc"          "%installdir%\%docs_version_tag%" "*.inv"        >nul) ^& IF %ERRORLEVEL% GTR 3 exit /b
(robocopy "%builddir%\stage\share\doc"          "%installdir%\%docs_version_tag%" "*.js"         >nul) ^& IF %ERRORLEVEL% GTR 3 exit /b
(robocopy "%builddir%\stage\share\doc\_static"  "%installdir%\%docs_version_tag%\_static"  /e >nul) ^& IF %ERRORLEVEL% GTR 3 exit /b
(robocopy "%builddir%\stage\share\doc\_sources" "%installdir%\%docs_version_tag%\_sources" /e >nul) ^& IF %ERRORLEVEL% GTR 3 exit /b

REM Archive builds
cd "%installdir%"

if not exist "%artefactdir%" mkdir "%artefactdir%"
if not exist "%artefactdir%\docs" mkdir "%artefactdir%\docs"
if not exist "%artefactdir%\binaries" mkdir "%artefactdir%\binaries"

echo Archiving %version_tag%.zip
if exist "%artefactdir%\binaries\%version_tag%.zip" (
  del "%artefactdir%\binaries\%version_tag%.zip"
)
zip -r "%artefactdir%\binaries\%version_tag%.zip" "%version_tag%" || exit /b

echo Archiving %docs_version_tag%.zip
if exist "%artefactdir%\%docs_version_tag%.zip" (
    del "%artefactdir%\%docs_version_tag%.zip"
)
zip -r "%artefactdir%\docs\%docs_version_tag%.zip" "%docs_version_tag%" || exit /b

REM Archive source
if not exist "%artefactdir%\sources" mkdir "%artefactdir%\sources"
echo Archiving sources
(robocopy "%cachedir%\source" "%artefactdir%\sources" /e >nul) ^& IF %ERRORLEVEL% GTR 3 exit /b
if exist "%cachedir%\tools" (
   echo Archiving tools
   if not exist "%artefactdir%\tools" mkdir "%artefactdir%\tools"
   (robocopy "%cachedir%\tools" "%artefactdir%\tools" /e >nul) ^& IF %ERRORLEVEL% GTR 3 exit /b
)

REM Test archive
:test

echo Test archive functionality
cd %workspace% || exit /b
if exist test (
    rmdir /s /q test
)
mkdir test || exit /b
cd test || exit /b

if exist "%version_tag%" (
    rmdir /s /q "%version_tag%"
)
unzip "%artefactdir%\binaries\%version_tag%.zip" || exit /b
cd %version_tag% || exit /b

set "PATH=%workspace%\test\%version_tag%\bin;%PATH%"

REM The ome-files batch file currently doesn't handle these options:

echo Test ome-files version
call ome-files --version || exit /b
echo Test ome-files usage
call ome-files --usage || exit /b
REM Help is not text-based, so don't test here
REM echo Test ome-files help
REM call ome-files --help || exit /b

echo Test ome-files info version
call ome-files info --version || exit /b
echo Test ome-files info usage
call ome-files info --usage || exit /b
REM Help is not text-based, so don't test here
REM echo Test ome-files info help
REM call ome-files info --help || exit /b

echo Complete

exit /b

REM See http://stackoverflow.com/a/15032476/2647431
:heredoc
setlocal enabledelayedexpansion
set go=
for /f "delims=" %%A in ('findstr /n "^" "%~f0"') do (
    set "line=%%A" && set "line=!line:*:=!"
    if defined go (if #!line:~1!==#!go::=! (goto :EOF) else echo(!line!)
    if "!line:~0,13!"=="call :heredoc" (
        for /f "tokens=3 delims=>^ " %%i in ("!line!") do (
            if #%%i==#%1 (
                for /f "tokens=2 delims=&" %%I in ("!line!") do (
                    for /f "tokens=2" %%x in ("%%I") do set "go=%%x"
                )
            )
        )
    )
)
goto :EOF
