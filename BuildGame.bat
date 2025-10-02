@echo off

:: make configuration switch based on vs licence
if exist "%programfiles%\Microsoft Visual Studio\2022\Professional\MSBuild\Current\Bin\MSBuild.exe" (
	set compiler="%programfiles%\Microsoft Visual Studio\2022\Professional\MSBuild\Current\Bin\MSBuild.exe"
	set configuration=Release
)
if exist "%programfiles%\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe" (
	set compiler="%programfiles%\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe"
	set configuration=Release
)

set projname=OpenSiv3D_0.6.14

if exist "%projname%.vcxproj" goto BuildProject
goto BuildError

:BuildProject
cd %cd%\App
%compiler% ..\%projname%.vcxproj /p:Configuration=%configuration% /p:Platform=x64
if %ERRORLEVEL% equ 0 goto BuildSucceeded

:BuildError
echo Build failed!
exit

:BuildSucceeded
echo Build succeeded. Launching game...
cd "%cd%\Intermediate\%projname%\Release\"
start %projname%.exe
exit

