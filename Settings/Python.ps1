# Python environment settings
if (-not (Get-Command python -ErrorAction Ignore)) { return }

# Disable environment prompt for conda
$ENV:CONDA_AUTO_ACTIVATE_BASE = $false
$ENV:VIRTUAL_ENV_DISABLE_PROMPT = $true

function Global:Invoke-Python { & (Get-Command "python").source @args }
Set-Alias py Invoke-Python

function global:Enable-PythonVenv {
    <#
    .SYNOPSIS
        Search for valid python virtual environment in the current directory;
        run the activation script "activate.ps1".
    #>
    [CmdletBinding()]
    param (
        [Parameter()]
        [String]
        $EnvFolder = ".venv"
    )
    if (-not $env:VIRTUAL_ENV) {
        if (Test-Path $EnvFolder) {
            $Splat = @{
                Path = [IO.Path]::Combine($PWD, $EnvFolder, "Scripts", "activate.ps1")
                Resolve = $true
                ErrorAction = "SilentlyContinue"
            }
            try { Invoke-Expression -Command (Join-Path $Path @Splat) }
            catch { continue }
        }
    }
    # Check that virtual environment has been enabled
    if (-not $env:VIRTUAL_ENV) {
        Write-Error "Unable to locate Python virtual environment could be located in this directory."
    }
}
Set-Alias activate Enable-PythonVenv
