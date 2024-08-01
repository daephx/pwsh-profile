# profile.ps1: PowerShell User Profile Configuration
# This script sets up custom aliases, functions, and environment settings.

# Find out if the current user identity is elevated (has admin rights)
$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal $identity
$Global:isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
Remove-Variable identity
Remove-Variable principal

# Set proper encoding for command output
$OutputEncoding = [Console]::InputEncoding = [Console]::OutputEncoding = [Text.Encoding]::UTF8

# $VerbosePreference = "Continue" # Uncomment to debug profile
$PSDefaultParameterValues["Install-Module:Scope"] = "CurrentUser"

# Main window colors
$Host.PrivateData.ProgressBackgroundColor = "Black"
$Host.PrivateData.ProgressForegroundColor = "DarkYellow"
$Host.UI.RawUI.BackgroundColor = "Black"
$Host.UI.RawUI.ForegroundColor = "White"

$Host.UI.RawUI.WindowTitle = "PowerShell {0}" -f $PSVersionTable.PSVersion.ToString()
$Host.UI.RawUI.WindowTitle += If ($isAdmin) { " [ADMIN]" } Else { "" }

# Error, warning and debug colors
$Host.PrivateData.DebugBackgroundColor = "Black"
$Host.PrivateData.DebugForegroundColor = "Gray"
$Host.PrivateData.ErrorBackgroundColor = "Black"
$Host.PrivateData.ErrorForegroundColor = "Red"
$Host.PrivateData.VerboseBackgroundColor = "Black"
$Host.PrivateData.VerboseForegroundColor = "Gray"
$Host.PrivateData.WarningBackgroundColor = "Black"
$Host.PrivateData.WarningForegroundColor = "Yellow"

# Set powershell style options
if ($PSStyle) {
    $PSStyle.FileInfo.Directory = $PSStyle.Foreground.Blue
}

$env:POSH_GIT_ENABLED = $false

# Determine powershell version for prompt
if ($PSVersionTable.PSVersion.Major -ge 6) { $CurrentShell = "pwsh" }
else { $CurrentShell = "powershell" }

# Set prompt command
if (Get-Command "oh-my-posh" -ErrorAction Ignore) {
    $ENV:POSH_THEME = "$ENV:POSH_THEMES_PATH\skellum.omp.toml"
    oh-my-posh init $CurrentShell | Invoke-Expression
}
elseif (Get-Command "starship" -ErrorAction SilentlyContinue) {
    $env:STARSHIP_CONFIG = $PSScriptRoot | Split-Path | Join-Path -ChildPath starship.toml
    $ENV:STARSHIP_CACHE = "$ENV:TEMP\starship"
    starship init powershell --print-full-init | Out-String | Invoke-Expression
}
else {
    # Fallback to default prompt
    function Global:prompt {
        if ($?) { $ErrorIndicator = "Green" }
        else { $ErrorIndicator = "Red" }
        $SegmentSeparator = " " + [char]::ConvertFromUtf32(0xE0B1) + " "
        $WindowsIcon = " " + [char]::ConvertFromUtf32(0xF17A)
        $UserName = [System.Environment]::UserName
        $HostName = [System.Net.Dns]::GetHostName()
        $PathString = "$(($pwd -split "\\")[0])\…\$(($pwd -split "\\")[-1] -join "\")"
        Write-Host $([char]::ConvertFromUtf32(0x250C)) -NoNewline -ForegroundColor DarkGray
        Write-Host $WindowsIcon -NoNewline -ForegroundColor Cyan
        Write-Host $SegmentSeparator -NoNewline -ForegroundColor DarkGray
        Write-Host $UserName -NoNewline -ForegroundColor Cyan
        Write-Host $([char]::ConvertFromUtf32(0xF0065) + "`b") -NoNewline -ForegroundColor DarkGray
        Write-Host $HostName -NoNewline -ForegroundColor DarkCyan
        Write-Host $SegmentSeparator -NoNewline -ForegroundColor DarkGray
        Write-Host $PathString -NoNewline -ForegroundColor Blue
        Write-Host ""
        Write-Host $([char]::ConvertFromUtf32(0x2514)) -NoNewline -ForegroundColor DarkGray
        Write-Host $([char]::ConvertFromUtf32(0x276F)) -NoNewline -ForegroundColor:$ErrorIndicator
        return " "
    }
}
Remove-Variable CurrentShell

# Load modules
# Import-Module -Name posh-git
# Import-Module -Name Terminal-Icons
# Import-Module -Name PSFzf

# Enable chocolaty helper module if available
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) { Import-Module "$ChocolateyProfile" }
Remove-Variable ChocolateyProfile

# Source local profile configuration scripts
$Settings = (Join-Path ($PROFILE | Split-Path -Parent) -ChildPath "Settings")

. "$Settings/Aliases.ps1"
. "$Settings/Completion.ps1"
. "$Settings/Environment.ps1"
. "$Settings/Fzf.ps1"
. "$Settings/PSReadLine.ps1"
. "$Settings/Python.ps1"

# Cleanup temporary variables
Remove-Variable Settings

# Change for and enable the ssh-agent service on windows.
# NOTE: This is only wrapped in a function because Diagnostics suppression wont work otherwise...
function Enable-SshAgent {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseCompatibleCmdlets", "")]
    param()
    # Ensure ssh-agent process is available for the user
    if ($isWindows) {
        $SshAgentStatus = (Get-Service -Name "ssh-agent" -ErrorAction SilentlyContinue).Status
        if ($SshAgentStatus -eq "Stopped") { Start-Service -Name "ssh-agent" }
    }
}
Enable-SshAgent

# Initialize zoxide compatibility
Invoke-Expression (& { (zoxide init powershell | Out-String) }) -ErrorAction SilentlyContinue
function zri() {
    zoxide query -i -- "$args" | ForEach-Object {
        $_zoxide_result = $_ -split " ", 2
        zoxide remove "$_zoxide_result"
    }
}

# Set hook for scoop-search
# Improves search performance for the scoop package manager
# https://github.com/ScoopInstaller/Scoop/issues/4239
Invoke-Expression (& scoop-search --hook) -ErrorAction SilentlyContinue
