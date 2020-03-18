#  ============================================================================
#      ____                            _          _ _        ____
#    |  _ \ _____      _____ _ __ ___| |__   ___| | |      / ___|___  _ __ ___
#   | |_) / _ \ \ /\ / / _ \ '__/ __| '_ \ / _ \ | |_____| |   / _ \| '__/ _ \
#  |  __/ (_) \ V  V /  __/ |  \__ \ | | |  __/ | |_____| |__| (_) | | |  __/
# |_|   \___/ \_/\_/ \___|_|  |___/_| |_|\___|_|_|      \____\___/|_|  \___|
#                    User profile - Powershell Core v6+
#  ============================================================================

#requires -Version 6
Clear-Host
$PSDefaultParameterValues['Install-Module:Scope'] = 'CurrentUser'
$host.privatedata.ProgressBackgroundColor = "Black";	# Progress bar bg = black
$host.privatedata.ProgressForegroundColor = "Yellow";	# Progress bar fg = yellow

#  ============================================================================

#region # * Import Modules
Import-Module Get-ChildItemColor
Import-Module posh-git # Ensure posh-git is loaded
Import-Module oh-my-posh ; # Ensure oh-my-posh is loaded

if (Get-Module oh-my-posh) {
    $ThemeSettings.MyThemesLocation = (Split-Path $profile) + '\Themes'
    # Set-Theme tehrob
    # Set-Theme Paradox
    Set-Theme Draconic
}
Import-Module PoShFuck # When you type a command incorrectly, don't say 'fuck', type it!
#endregion

#region # * SSH-Agent
$sshAgentStopped = 'Stopped' -eq (Get-Service -Name 'ssh-agent' -ErrorAction SilentlyContinue).status
Write-Verbose -Message ('SSH Agent Status is stopped: {0}' -f $sshAgentStopped)

# Start SshAgent if not already
if ($sshAgentStopped) {
    Write-Verbose -Message 'Stating SSh Agent'
    Start-Service -Name 'ssh-agent'
}
#endregion

#region # * Helper Configs
function Set-UserProfile { Set-Location ~ }
Set-Alias ~ Set-UserProfile -Option AllScope
function Set-DriveRoot { Set-Location "$($PWD.Drive.Name):\" }
Set-Alias \ Set-DriveRoot -Option AllScope
Set-Alias / Set-DriveRoot -Option AllScope

Function Invoke-Explorer { param($Path) Switch ($Path) { "" { Explorer $PWD } Default { Explorer $Path } } }
Set-Alias e Invoke-Explorer -Option AllScope

Function Invoke-Help { param($Command)Get-Help $Command -ShowWindow }
Set-Alias h Invoke-Help -Option AllScope

# AHK Simplistic Bypass
Function Invoke-AutoHotkey { & 'C:\Program Files\AutoHotkey\AutoHotkey.exe' $args }
Set-Alias ahk Invoke-AutoHotkey

# Unix-Like ^D to close active terminal
Set-PSReadLineKeyHandler -Key ctrl+d -Function ViExit
#endregion

#region # * Script Importer
$Importer = $True
if ($Importer) { $ImportFiles = Get-ChildItem "$PSScriptRoot\Import\" -Recurse -Filter *.ps1 }
For ($i = 1; $i -le $ImportFiles.count; $i++) {
    $FilePath = $ImportFiles[$i].fullname
    $PercentComplete = ($i / $ImportFiles.count * 100)
    if ($FilePath) {
        Write-Progress -Activity "Importing files:" -status $FilePath -PercentComplete $PercentComplete
        . $FilePath
    }
}

#region # * Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
}
#endregion

#region # !! Contents within this block are managed by 'conda init' !!
if (Get-Command conda.exe -erroraction 'Ignore' ) {
    (& "$((Get-Command conda.exe).source)" "shell.powershell" "hook") | Out-String | Invoke-Expression
}
#endregion

#  ============================================================================
