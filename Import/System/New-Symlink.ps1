<# 
███████╗██╗   ██╗███╗   ███╗██████╗  ██████╗ ██╗     ██╗ ██████╗ ██╗     ██╗███╗   ██╗██╗  ██╗
██╔════╝╚██╗ ██╔╝████╗ ████║██╔══██╗██╔═══██╗██║     ██║██╔════╝ ██║     ██║████╗  ██║██║ ██╔╝
███████╗ ╚████╔╝ ██╔████╔██║██████╔╝██║   ██║██║     ██║██║█████╗██║     ██║██╔██╗ ██║█████╔╝ 
╚════██║  ╚██╔╝  ██║╚██╔╝██║██╔══██╗██║   ██║██║     ██║██║╚════╝██║     ██║██║╚██╗██║██╔═██╗ 
███████║   ██║   ██║ ╚═╝ ██║██████╔╝╚██████╔╝███████╗██║╚██████╗ ███████╗██║██║ ╚████║██║  ██╗
╚══════╝   ╚═╝   ╚═╝     ╚═╝╚═════╝  ╚═════╝ ╚══════╝╚═╝ ╚═════╝ ╚══════╝╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝

* Reference:
+-----------------------+-----------------------------------------------------------+
| mklink syntax         | Powershell equivalent                                     |
+-----------------------+-----------------------------------------------------------+
| mklink Link Target    | New-Item -ItemType SymbolicLink -Name Link -Target Target |
| mklink /D Link Target | New-Item -ItemType SymbolicLink -Name Link -Target Target |
| mklink /H Link Target | New-Item -ItemType HardLink -Name Link -Target Target     |
| mklink /J Link Target | New-Item -ItemType Junction -Name Link -Target Target     |
+-----------------------+-----------------------------------------------------------+
#>

function New-Symlink
{
    param(
        [Parameter(Mandatory=$true)]
        [String]$link,
        [String]$source
    )

    if (Test-Administrator) 
    {
        $msg = '"' + $link + '"' + " ==> " + '"' + $source + '"'
        if ($PSVersionTable.PSVersion.Major -ge 5) {
            New-Item -Path "$link" -ItemType SymbolicLink -Value "$source" | Out-Null
        } else {
            $command = "cmd /c mklink /d"
            invoke-expression "$command ""$link"" ""$source""" | Out-Null
        }
        if (!$error) {
            Write-host "SymLink Created: " -ForegroundColor Green -nonewline; Write-Host $msg
        }
    }
}