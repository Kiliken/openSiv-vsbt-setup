

$BuildProj = $Args[1]
$OpenSivVersion = $Args[2]

$OpenSivDownloadUrl = "https://siv3d.jp/downloads/Siv3D/manual/$OpenSivVersion/OpenSiv3D_SDK_$OpenSivVersion.zip"
$OpenSivTempUrl = "https://siv3d.jp/downloads/Siv3D/manual/$OpenSivVersion/OpenSiv3D_$OpenSivVersion.zip"

$wc = New-Object Net.WebClient
Add-Type -AssemblyName System.IO.Compression.FileSystem

Write-Output "[openSiv-vsbt-setup] Downloading OpenSiv3D_SDK_$OpenSivVersion..."
$wc.DownloadFile($OpenSivDownloadUrl, "$($PSScriptRoot)\OpenSiv3D.zip")

Write-Output "[openSiv-vsbt-setup] Extracting OpenSiv3D_SDK_$OpenSivVersion..."
[System.IO.Compression.ZipFile]::ExtractToDirectory("$($PSScriptRoot)\OpenSiv3D.zip", $PSScriptRoot)

if ($BuildProj -eq 1) {
	Write-Output "[openSiv-vsbt-setup] No avible project detected"
	Write-Output "[openSiv-vsbt-setup] Downloading template..."
	$wc.DownloadFile($OpenSivTempUrl, "$($PSScriptRoot)\template.zip")
	
	Write-Output "[openSiv-vsbt-setup] Extracting template..."
	[System.IO.Compression.ZipFile]::ExtractToDirectory("$($PSScriptRoot)\template.zip", $PSScriptRoot)
	
	Write-Output "[openSiv-vsbt-setup] Setting up template..."
	Add-Content -Path "$($PSScriptRoot)\.gitignore" -Value "/OpenSiv3D_SDK_$OpenSivVersion/"
	(Get-Content -Path "$($PSScriptRoot)\OpenSiv3D_$OpenSivVersion.vcxproj") -replace '<ClCompile Include="Main.cpp" />', '<ClCompile Include="src\*.cpp" />' | Set-Content -Path "$($PSScriptRoot)\OpenSiv3D_$OpenSivVersion.vcxproj"
	(Get-Content -Path "$($PSScriptRoot)\OpenSiv3D_$OpenSivVersion.vcxproj") -replace '\$\(\s*SIV3D_\d+_\d+_\d+\s*\)', "`$(SolutionDir)OpenSiv3D_SDK_$OpenSivVersion" | Set-Content -Path "$($PSScriptRoot)\OpenSiv3D_$OpenSivVersion.vcxproj"
	New-Item -ItemType Directory -Path "$($PSScriptRoot)\src"
	Move-Item -Path "$($PSScriptRoot)\Main.cpp" -Destination "$($PSScriptRoot)\src\Main.cpp"
}

<#
Template Download:
	https://siv3d.jp/downloads/Siv3D/manual/0.6.6/OpenSiv3D_0.6.6.zip
#>
return 0
