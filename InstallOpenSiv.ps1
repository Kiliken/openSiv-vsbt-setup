

$BuildProj = $Args[1]
$OpenSivVersion = $Args[2]

$OpenSivDownloadUrl = "https://siv3d.jp/downloads/Siv3D/manual/$OpenSivVersion/OpenSiv3D_SDK_$OpenSivVersion.zip"
$OpenSivTempUrl = "https://siv3d.jp/downloads/Siv3D/manual/$OpenSivVersion/OpenSiv3D_$OpenSivVersion.zip"
Invoke-WebRequest $OpenSivDownloadUrl -OutFile "$($PSScriptRoot)\OpenSiv3D.zip"
Expand-Archive -Path "$($PSScriptRoot)\OpenSiv3D.zip" -DestinationPath $PSScriptRoot

if ($BuildProj -eq 1) {
    Invoke-WebRequest $OpenSivTempUrl -OutFile "$($PSScriptRoot)\template.zip"
	Expand-Archive -Path "$($PSScriptRoot)\template.zip" -DestinationPath $PSScriptRoot
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