#Requires -Version 5

function Invoke-PowerShell {
    powershell -nologo
    Invoke-PowerShell
}

function Restart-PowerShell {
    if ($host.Name -eq 'ConsoleHost') {
        $parentProcessId = (Get-WmiObject Win32_Process -Filter "ProcessId=$PID").ParentProcessId
        $parentProcessName = (Get-WmiObject Win32_Process -Filter "ProcessId=$parentProcessId").ProcessName

        Write-Host $parentProcessId
        Write-Host $parentProcessName

        if ($host.Name -eq 'ConsoleHost') {
            if (-not($parentProcessName -eq 'powershell.exe')) {
                powershell -nologo
            }
        }
        exit
    }
    else {
        Write-Warning 'Only usable while in the PowerShell console host'
    }
}

Set-Alias -Name 'reload' -Value 'Restart-PowerShell'