[CmdletBinding()]
param()
$ErrorActionPreference = 'Stop'
$projectRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../..'))
Push-Location $projectRoot
try {
    foreach ($required in @('pyproject.toml', 'uv.lock', 'webui/Main.py')) {
        if (-not (Test-Path -LiteralPath $required)) { throw "Missing source file: $required. Clone the full repository first." }
    }
    $uvCommand = Get-Command uv -ErrorAction SilentlyContinue
    if ($uvCommand) {
        $uvExe = $uvCommand.Source
    } else {
        $bootstrapPython = $null
        $bootstrapArgs = @()
        foreach ($candidate in @('py', 'python')) {
            $candidateCommand = Get-Command $candidate -ErrorAction SilentlyContinue
            if (-not $candidateCommand) { continue }
            $candidateArgs = @()
            if ($candidate -eq 'py') { $candidateArgs = @('-3.11') }
            & $candidateCommand.Source @candidateArgs -c 'import sys; sys.exit(0 if sys.version_info >= (3,11) else 1)'
            if ($LASTEXITCODE -eq 0) {
                $bootstrapPython = $candidateCommand.Source
                $bootstrapArgs = $candidateArgs
                break
            }
        }
        if (-not $bootstrapPython) {
            throw 'Python 3.11+ or uv is required. Install Python from https://www.python.org/downloads/windows/ or uv from https://docs.astral.sh/uv/getting-started/installation/ then run this script again.'
        }
        $bootstrapDir = Join-Path $projectRoot 'storage/khanh-hiep-bootstrap'
        $bootstrapExe = Join-Path $bootstrapDir 'Scripts/python.exe'
        if (-not (Test-Path -LiteralPath $bootstrapExe)) {
            & $bootstrapPython @bootstrapArgs -m venv $bootstrapDir
            if ($LASTEXITCODE -ne 0) { throw 'Cannot create bootstrap venv.' }
        }
        & $bootstrapExe -m pip install uv
        if ($LASTEXITCODE -ne 0) { throw 'Cannot install uv. Check allowed network access to PyPI.' }
        $uvExe = Join-Path $bootstrapDir 'Scripts/uv.exe'
    }
    & $uvExe sync --frozen --python 3.11
    if ($LASTEXITCODE -ne 0) { throw 'Dependency installation failed; environment is NOT ready.' }
    if (-not (Test-Path -LiteralPath 'config.toml')) {
        Copy-Item -LiteralPath 'khanh_hiep/config.local.example.toml' -Destination 'config.toml'
    } else {
        Write-Host 'Existing config.toml preserved. Review providers before any generation.'
    }
    & '.\.venv\Scripts\python.exe' -X utf8 'khanh_hiep/scripts/smoke.py'
    if ($LASTEXITCODE -ne 0) { throw 'Smoke checks failed; environment is NOT ready.' }
    Write-Host 'Core environment checks passed. MASTER PROMPT implementation has not started.'
} finally {
    Pop-Location
}
