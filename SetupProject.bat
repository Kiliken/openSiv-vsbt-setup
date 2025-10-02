@echo off

set sivVersion=0.6.14
set buildAll=1

if exist "%cd%/src" set buildAll=0
if exist "%cd%/OpenSiv3D.zip" goto ExitProgram


:SetupProject
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0InstallOpenSiv.ps1" -Command %buildAll% "%sivVersion%"
echo Project Setup completed...
pause
exit

:ExitProgram
echo Project is already installed...
pause
exit
