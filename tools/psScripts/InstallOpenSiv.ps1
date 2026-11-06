
$BuildProj = $Args[1]
$OpenSivVersion = $Args[2]

if (-not $OpenSivVersion) {
    Write-Error "[openSiv-vsbt-setup] Error: Please provide the OpenSiv3D version (e.g., v0.6.14)"
    exit 1
}

$OpenSivDownloadUrl = "https://siv3d.jp/downloads/Siv3D/manual/$OpenSivVersion/OpenSiv3D_SDK_$OpenSivVersion.zip"
$OpenSivTempUrl = "https://siv3d.jp/downloads/Siv3D/manual/$OpenSivVersion/OpenSiv3D_$OpenSivVersion.zip"


$ProjectRoot = "$PSScriptRoot\..\.."
$DwnldDir = "$PSScriptRoot\..\dwnld"

# Safely create the download directory if it doesn't exist
if (-not (Test-Path $DwnldDir)) {
    New-Item -Path $DwnldDir -ItemType Directory -Force | Out-Null
}

Add-Type -AssemblyName System.IO.Compression.FileSystem

$ZipPath = "$DwnldDir\OpenSiv3D.zip"

if ( -not (Test-Path $ZipPath)){
	Write-Output "[openSiv-vsbt-setup] Downloading OpenSiv3D_SDK_$OpenSivVersion..."
	curl.exe -L "$OpenSivDownloadUrl" -o "$ZipPath" --progress-bar
}

$TargetExtractDir = "$ProjectRoot\OpenSiv3D_SDK_$OpenSivVersion"
if (Test-Path $TargetExtractDir) {
    Write-Output "[openSiv-vsbt-setup] Removing existing folder $TargetExtractDir..."
    Remove-Item -Recurse -Force $TargetExtractDir
}

Write-Output "[openSiv-vsbt-setup] Extracting OpenSiv3D_SDK_$OpenSivVersion..."
[System.IO.Compression.ZipFile]::ExtractToDirectory("$ZipPath", "$ProjectRoot")

if ($BuildProj -eq 1) {
	Write-Output "[openSiv-vsbt-setup] No avible project detected"
	Write-Output "[openSiv-vsbt-setup] Downloading template..."
	curl.exe -L "$OpenSivTempUrl" -o "$DwnldDir\template.zip" --progress-bar
	
	Write-Output "[openSiv-vsbt-setup] Extracting template..."
	[System.IO.Compression.ZipFile]::ExtractToDirectory("$DwnldDir\template.zip", $ProjectRoot)
	
	Write-Output "[openSiv-vsbt-setup] Setting up template..."
	Add-Content -Path "$ProjectRoot\.gitignore" -Value "/OpenSiv3D_SDK_$OpenSivVersion/"
	New-Item -ItemType Directory -Path "$ProjectRoot\src"
	Move-Item -Path "$ProjectRoot\Main.cpp" -Destination "$ProjectRoot\src\Main.cpp"
	
	$vcxprojPath = "$ProjectRoot\OpenSiv3D_$OpenSivVersion.vcxproj"
	$lines = [System.Collections.Generic.List[string]](Get-Content -Path $vcxprojPath)
	
	$lines[59] = '<IncludePath>$(SolutionDir)OpenSiv3D_SDK_0.6.16\include;$(SolutionDir)OpenSiv3D_SDK_0.6.16\include\ThirdParty;$(IncludePath)</IncludePath>'
    $lines[60] = '<LibraryPath>$(SolutionDir)OpenSiv3D_SDK_0.6.16\lib\Windows;$(LibraryPath)</LibraryPath>'
	$lines.Insert(61, '<IncludePath>$(ProjectDir)src;$(IncludePath)</IncludePath>')
	$lines[118] = '<ClCompile Include="src\**\*.cpp" />'
	
	$lines | Set-Content -Path $vcxprojPath
}

return 0
