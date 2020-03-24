# ==========================================================
#     ____              __ _ _            _   _
#    |  _ \ _ __ ___  / _(_) | ___      | | | |___  ___ _ __
#   | |_) | '__/ _ \| |_| | |/ _ \_____| | | / __|/ _ \ '__|
#  |  __/| | | (_) |  _| | |  __/_____| |_| \__ \  __/ |
# |_|   |_|  \___/|_| |_|_|\___|      \___/|___/\___|_|
#           User profile - Powershell Core v6+
# ==========================================================

Clear-Host
#requires -Version 6
$PSDefaultParameterValues['Install-Module:Scope'] = 'CurrentUser'
$host.privatedata.ProgressForegroundColor = "DarkYellow"
$host.privatedata.ProgressBackgroundColor = "Black"

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
Import-Module PSquire # Custom Powershell module
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

Function Invoke-Explorer { param($Path) Switch ($Path) { "" { explorer $PWD } Default { explorer $Path } } }
Set-Alias e Invoke-Explorer -Option AllScope

# AHK Simplistic Bypass
Function Invoke-AutoHotkey { & 'C:\Program Files\AutoHotkey\AutoHotkey.exe' $args }
Set-Alias ahk Invoke-AutoHotkey

# Unix-Like ^D to close active terminal
Set-PSReadLineKeyHandler -Key ctrl+d -Function ViExit
#endregion

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
