# Aliases and functions
function .. { Set-Location ".." }
function ... { Set-Location "..\.." }
function .... { Set-Location "..\..\.." }
function ..... { Set-Location "..\..\..\.." }

function Set-LocationHome { Set-Location "~" }
Set-Alias -Name ~ -Value Set-LocationHome

function Set-DriveRoot { Set-Location "$($PWD.Drive.Root)" }
Set-Alias -Name / -Value Set-DriveRoot
Set-Alias -Name \ -Value Set-DriveRoot

Set-Alias -Name edit -Value Edit-File
Set-Alias -Name which -Value where.exe

function Exit-PSInstance { exit }
Set-Alias -Value Exit-PSInstance -Name "q"
Set-Alias -Value Exit-PSInstance -Name "wq"
Set-Alias -Value Exit-PSInstance -Name ":q"
Set-Alias -Value Exit-PSInstance -Name ":wq"

# Restart powershell session
function Restart-Powershell {
    switch ($PSVersionTable.PSVersion.Major) {
        { $_ -ge 6 } { $cmd = "pwsh" }
        default { $cmd = "powershell" }
    }
    Invoke-Command -NoNewScope -ScriptBlock { & "$cmd"; exit }
}
Set-Alias -Name reload -Value Restart-Powershell

# Restart file explorer
function Restart-Explorer { cmd /c taskkill /F /IM explorer.exe; Start-Process "explorer.exe" }

# Quickly edit windows hosts files
function Edit-HostsFile {
    $HostsFilePath = "$env:windir\system32\drivers\etc\hosts"
    Start-Process -FilePath $EDITOR -ArgumentList $HostsFilePath -Verb runas
}

# Compute file hashes - useful for checking successful downloads
function md5 { Get-FileHash -Algorithm MD5 @args }
function sha1 { Get-FileHash -Algorithm SHA1 @args }
function sha256 { Get-FileHash -Algorithm SHA256 @args }

# Replace default list directory utility
if (Get-Command "eza" -ErrorAction Ignore) {

    $defaults = @(
        "--classify"
        "--group-directories-first"
        "--icons=auto"
        "--time-style=long-iso"
    )

    Remove-Item Alias:ls
    function global:l  { eza $defaults -l @args }
    function global:la { eza $defaults -al @args }
    function global:ls { eza $defaults --icons=never @args }
    function global:lt { eza $defaults --tree -L2 @args }
}
else {
    function global:l { Get-ChildItem @args }
    function global:la { Get-ChildItem -Force @args }
    function global:lt { tree @args }
}

# Editor settings
$env:EDITOR = "nvim"
$env:GIT_EDITOR = "nvim"
function vi { & nvim @args }
function vs { & devenv @args }

# Override git editor for VSCode integrated terminal
if ($env:TERM_PROGRAM -eq "vscode") {
    $env:GIT_EDITOR = "code --wait"
}

# Git aliases
Remove-Item -Force Alias:gl
Set-Alias -Name g -Value "git"
Set-Alias -Name gti -Value "git"
function gd { git diff @args }
function gds { git diff --staged @args }
function gl { git log --oneline @args }
function gs { git status @args }

# Quick AutoHotkey script invocation
$AutoHotkey = "C:\Program Files\AutoHotkey\autohotkey.exe"
if (Test-Path $AutoHotkey -ErrorAction 'Ignore') {
    function Global:Invoke-AutoHotkey { & $AutoHotkey @args }
    Set-Alias ahk Invoke-AutoHotkey
}
