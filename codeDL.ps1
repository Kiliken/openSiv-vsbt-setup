
# Download
curl.exe -L "https://github.com/Kiliken/openSiv-vsbt-setup/archive/refs/heads/main.tar.gz" -o "$($PSScriptRoot)\main.tar.gz" --progress-bar

# Extract
tar -xzf "$($PSScriptRoot)\main.tar.gz" -C "$($PSScriptRoot)"

# Install
Move-Item "$($PSScriptRoot)\openSiv-vsbt-setup-main\*" $PSScriptRoot -Force
Remove-Item "$($PSScriptRoot)\openSiv-vsbt-setup-main" -Recurse -Force
Remove-Item "$($PSScriptRoot)\main.tar.gz" -Force

# Kill the Installer
Start-Process cmd.exe -ArgumentList "/c timeout /t 2 /nobreak > nul & del `"$PSCommandPath`"" -WindowStyle Hidden
