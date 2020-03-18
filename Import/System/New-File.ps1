<# 
██╗   ██╗███╗   ██╗██╗██╗  ██╗     ██╗     ██╗██╗  ██╗███████╗
██║   ██║████╗  ██║██║╚██╗██╔╝     ██║     ██║██║ ██╔╝██╔════╝
██║   ██║██╔██╗ ██║██║ ╚███╔╝█████╗██║     ██║█████╔╝ █████╗  
██║   ██║██║╚██╗██║██║ ██╔██╗╚════╝██║     ██║██╔═██╗ ██╔══╝  
╚██████╔╝██║ ╚████║██║██╔╝ ██╗     ███████╗██║██║  ██╗███████╗
 ╚═════╝ ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝     ╚══════╝╚═╝╚═╝  ╚═╝╚══════╝
#>

Function New-File {
    [CmdletBinding()] 
    [Alias('touch')]
    PARAM ($file)
    Switch ($file) {
        $null { throw "No filename supplied" } # Argument required
        { Test-Path $_ } { (Get-ChildItem $_).LastWriteTime = Get-Date } # Refresh filedate
        Default { New-Item -Type File -Path $_ ; exit } # UTF8NoBOM Complient
        # Default { echo $null > $_; exit } # Original Encoding
    }
}
