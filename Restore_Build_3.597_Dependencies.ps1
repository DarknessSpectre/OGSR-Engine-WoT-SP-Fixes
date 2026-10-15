$ErrorActionPreference = 'Stop'
Set-Location -LiteralPath $PSScriptRoot
$manifest = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'Build_3.597_dependencies.json') -Raw | ConvertFrom-Json
$repoRoot = [System.IO.Path]::GetFullPath($PSScriptRoot).TrimEnd('\') + '\'

foreach ($dependency in $manifest.dependencies) {
    $targetPath = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot $dependency.path))
    if (-not $targetPath.StartsWith($repoRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
        throw "Dependency path is outside the source tree: $($dependency.path)"
    }
    if (Test-Path -LiteralPath $targetPath) {
        if (-not (Test-Path -LiteralPath (Join-Path $targetPath '.git'))) {
            throw "An existing non-Git directory must be moved aside first: $targetPath"
        }
        $dirtyFiles = & git -C $targetPath status --porcelain --untracked-files=no
        if ($LASTEXITCODE -ne 0 -or $dirtyFiles) {
            throw "Dependency has local changes: $targetPath"
        }
    }
    else {
        & git init --quiet $targetPath
        if ($LASTEXITCODE -ne 0) { throw "Cannot initialize $targetPath" }
        & git -C $targetPath remote add origin $dependency.url
        if ($LASTEXITCODE -ne 0) { throw "Cannot configure origin for $targetPath" }
    }

    & git -C $targetPath config core.longpaths true
    if ($LASTEXITCODE -ne 0) { throw "Cannot enable long paths for $targetPath" }
    $currentRevision = & git -C $targetPath rev-parse --verify --quiet HEAD
    if ($currentRevision -eq $dependency.commit) { continue }

    & git -C $targetPath fetch --depth 1 origin $dependency.commit
    if ($LASTEXITCODE -ne 0) { throw "Cannot fetch $($dependency.path)" }
    & git -C $targetPath checkout --detach FETCH_HEAD
    if ($LASTEXITCODE -ne 0) { throw "Cannot check out $($dependency.path)" }
}

Write-Host 'All dependencies match the versions used for build 3.597.'
