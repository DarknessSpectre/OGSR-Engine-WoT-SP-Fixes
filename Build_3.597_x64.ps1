$ErrorActionPreference = 'Stop'
Set-Location -LiteralPath $PSScriptRoot

$vsLocator = Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio\Installer\vswhere.exe'
if (-not (Test-Path -LiteralPath $vsLocator)) {
    throw 'Visual Studio Installer (vswhere.exe) was not found.'
}
$msbuildPath = & $vsLocator -latest -products '*' -requires Microsoft.Component.MSBuild -find 'MSBuild\**\Bin\amd64\MSBuild.exe' | Select-Object -First 1
if (-not $msbuildPath) {
    throw 'MSBuild with the Desktop C++ workload was not found.'
}

$env:APPVEYOR_BUILD_VERSION = '3.597'
$env:APPVEYOR_REPO_NAME = 'WoT&SP Fixes'
$env:CONFIGURATION_GA = 'Release'

& $msbuildPath 'Engine.sln' /t:Rebuild /p:Configuration=Release /p:Platform=x64 /m:2 /p:CL_MPCount=2 /v:minimal /nologo
$buildResult = $LASTEXITCODE
if ($buildResult -ne 0) { exit $buildResult }

$vsInstallPath = & $vsLocator -latest -products '*' -requires Microsoft.Component.MSBuild -property installationPath
$openMpDll = Get-ChildItem -LiteralPath (Join-Path $vsInstallPath 'VC\Redist\MSVC') -Filter vcomp140.dll -Recurse |
    Where-Object { $_.FullName -match '\\x64\\Microsoft\.VC[0-9]+\.OpenMP\\' -and $_.FullName -notmatch '\\onecore\\' } |
    Sort-Object FullName -Descending | Select-Object -First 1
if (-not $openMpDll) { throw 'The x64 OpenMP redistributable vcomp140.dll was not found.' }
Copy-Item -LiteralPath $openMpDll.FullName -Destination (Join-Path $PSScriptRoot 'bin_x64\vcomp140.dll') -Force
exit 0
