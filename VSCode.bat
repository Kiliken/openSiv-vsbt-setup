@echo off

for %%i in (code.cmd) do for %%j in ("%%~dp$PATH:i\..") do set "VSCODE_PARENT=%%~fj"
start "" "%VSCODE_PARENT%\Code.exe" .

exit
