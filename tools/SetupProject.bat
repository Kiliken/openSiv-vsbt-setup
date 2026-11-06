@echo off

set sivVersion=0.6.16
set buildAll=0

cd %~dp0..

if not exist "%cd%/App" set buildAll=1
if exist "%cd%/OpenSiv3D" goto ExitProgram


:SetupProject
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0psScripts/InstallOpenSiv.ps1" -Command %buildAll% "%sivVersion%"
echo Project Setup completed...
pause
exit

:ExitProgram
echo Project is already installed...
pause
exit
