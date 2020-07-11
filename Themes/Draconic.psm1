#requires -Version 2 -Modules posh-git, oh-my-posh

Function Set-Stopwatch {
    $LastExecutionTimeSpan = if (@(Get-History).Count -gt 0) {
        Get-History | Select-Object -Last 1 | ForEach-Object {
            New-TimeSpan -Start $_.StartExecutionTime -End $_.EndExecutionTime
        }
    }
    else { New-TimeSpan }

    $LastExecutionShortTime = switch ($LastExecutionTimeSpan) {
        { $_.Days -gt 0 } { "$($LastExecutionTimeSpan.Days + [Math]::Round($LastExecutionTimeSpan.Hours / 24, 2))d" }
        { $_.Hours -gt 0 -and $_.TotalHours -lt 24 } { "$($LastExecutionTimeSpan.Hours + [Math]::Round($LastExecutionTimeSpan.Minutes / 60, 2))h" }
        { $_.Minutes -gt 0 -and $_.TotalMinutes -lt 60 } { "$($LastExecutionTimeSpan.Minutes + [Math]::Round($LastExecutionTimeSpan.Seconds / 60, 2))m" }
        { $_.Seconds -gt 0 -and $_.TotalSeconds -lt 60 } { "$($LastExecutionTimeSpan.Seconds + [Math]::Round($LastExecutionTimeSpan.Milliseconds / 1000, 2))s" }
        { $_.Milliseconds -gt 0 -and $_.TotalMilliseconds -lt 1000 } { "$([Math]::Round($LastExecutionTimeSpan.TotalMilliseconds, 2))ms" }
        default { "0s" }
    }
    return "[$LastExecutionShortTime]"
}

Function Get-ShortPath {
    if ($pwd.path -eq $HOME) { return $($PWD.Path.Replace(($HOME), '~')) }
    $Drive = $PWD.Drive.Name
    $Parts = $PWD -split "\\" | Where-Object { -Not [String]::IsNullOrEmpty($_) }
    $PwdPath = switch ($Parts.Count) {
        { $_ -gt 3 } {
            $ParentFolder = Split-Path -Path (Split-Path -Path $PWD -Parent) -Leaf
            $CurrentFolder = Split-Path -Path $PWD -Leaf
            "..\$ParentFolder\$CurrentFolder\"
        }
        { $_ -eq 3 } {
            $ParentFolder = Split-Path -Path (Split-Path -Path $PWD -Parent) -Leaf
            $CurrentFolder = Split-Path -Path $PWD -Leaf
            "$ParentFolder\$CurrentFolder\"
        }
        { $_ -eq 2 } { Split-Path -Path $PWD -Leaf }
        default { "" }
    }
    return "$Drive`:\$PwdPath"
}

Function Write-Theme {
    param(
        [bool]$lastCommandFailed,
        [string]$with
    )

    # Starting Symbol
    $prompt += Write-Prompt -Object $sl.PromptSymbols.StartSymbol -ForegroundColor $sl.Colors.SegmentSeparator -BackgroundColor $sl.Colors.SessionInfoBackgroundColor

    # Check the last command state and indicate if failed
    $historylog = ('{0:d4}' -f $MyInvocation.HistoryId)
    If (!$lastCommandFailed) { $prompt = Write-Prompt -Object "$historylog " -ForegroundColor $sl.Colors.HistoryForegroundColor -BackgroundColor $sl.Colors.SessionInfoBackgroundColor }
    else { $prompt = Write-Prompt -Object "$historylog " -ForegroundColor $sl.Colors.CommandFailedIconForegroundColor -BackgroundColor $sl.Colors.SessionInfoBackgroundColor }

    $prompt += Write-Prompt -Object $sl.PromptSymbols.SegmentSeparator -ForegroundColor $sl.Colors.SegmentSeparator -BackgroundColor $sl.Colors.SessionInfoBackgroundColor

    # User Session Info
    $user = [System.Environment]::UserName
    $computer = [System.Net.Dns]::GetHostName()
    if (Test-NotDefaultUser($user)) {
        If (Test-Administrator) { $user = "Admin" }
        $prompt += Write-Prompt -Object " $user" -ForegroundColor $sl.Colors.SessionInfoUsernameForegroundColor -BackgroundColor $sl.Colors.SessionInfoBackgroundColor
        $prompt += Write-Prompt -Object "@" -ForegroundColor DarkGray -BackgroundColor $sl.Colors.SessionInfoBackgroundColor
    }
    $prompt += Write-Prompt -Object "$computer " -ForegroundColor $sl.Colors.SessionInfoComputerForegroundColor -BackgroundColor $sl.Colors.SessionInfoBackgroundColor

    # Python virtual environments
    if (Test-VirtualEnv) {
        $prompt += Write-Prompt -Object $sl.PromptSymbols.SegmentSeparator -ForegroundColor $sl.Colors.SegmentSeparator -BackgroundColor $sl.Colors.SessionInfoBackgroundColor
        $prompt += Write-Prompt -Object " $(Get-VirtualEnvName) " -ForegroundColor $sl.Colors.VirtualEnvForegroundColor -BackgroundColor $sl.Colors.SessionInfoBackgroundColor
    }
    elseif ($env:CONDA_DEFAULT_ENV) {
        if ($env:CONDA_DEFAULT_ENV -eq "base" -or $env:CONDA_PREFIX.StartsWith("$HOME\.conda")) { $CondaEnvName = $env:CONDA_DEFAULT_ENV }
        else { $CondaEnvName = Split-Path (Split-Path $env:CONDA_DEFAULT_ENV -Parent) -Leaf }
        $prompt += Write-Prompt -Object $sl.PromptSymbols.SegmentSeparator -ForegroundColor $sl.Colors.SegmentSeparator -BackgroundColor $sl.Colors.SessionInfoBackgroundColor
        $prompt += Write-Prompt -Object " $($CondaEnvName) " -ForegroundColor $sl.Colors.VirtualEnvForegroundColor -BackgroundColor $sl.Colors.SessionInfoBackgroundColor
    }

    # Current Filepath
    $prompt += Write-Prompt -Object $sl.PromptSymbols.SegmentSeparator -ForegroundColor $sl.Colors.SegmentSeparator -BackgroundColor $sl.Colors.SessionInfoBackgroundColor
    $prompt += Write-Prompt -Object " $(Get-ShortPath -dir $pwd) " -ForegroundColor $sl.Colors.PathForegroundColor -BackgroundColor $sl.Colors.SessionInfoBackgroundColor

    # Version control status
    $status = Get-VCSStatus
    if ($status) {
        $prompt += Write-Prompt -Object $sl.PromptSymbols.SegmentSeparator -ForegroundColor $sl.Colors.SegmentSeparator -BackgroundColor $sl.Colors.SessionInfoBackgroundColor
        $VCSPrefix = [char]::ConvertFromUtf32(0x005B)
        $VCSSuffix = [char]::ConvertFromUtf32(0x005D)
        $VCSStatus = Get-VcsInfo -status $status
        $prompt += Write-Prompt -Object " $VCSPrefix$($VCSStatus.vcinfo)$VCSSuffix " -ForegroundColor $($VCSStatus.backgroundcolor)
    }

    # Prompt ending character
    $prompt += Write-Prompt -Object $sl.PromptSymbols.EndSymbol -ForegroundColor $sl.Colors.SegmentSeparator -BackgroundColor $sl.Colors.SessionInfoBackgroundColor

    # Command Stopwatch
    $Stopwatch = Set-Stopwatch
    $prompt += Set-CursorForRightBlockWrite -textLength ($Stopwatch.Length + 1)
    $prompt += Write-Prompt $Stopwatch -ForegroundColor $sl.Colors.PromptStopwatchColor

    $prompt += Set-Newline

    if ($with) {
        $prompt += Write-Prompt -Object "$($with.ToUpper()) " -ForegroundColor $sl.Colors.WithForegroundColor -BackgroundColor $sl.Colors.WithBackgroundColor
    }
    $prompt += Write-Prompt -Object $sl.PromptSymbols.PromptIndicator -ForegroundColor $sl.Colors.PromptSymbolColor
    $prompt += ' '
    $prompt
}

$sl = $global:ThemeSettings # Local settings
$sl.GitSymbols.BranchSymbol = ''
$sl.PromptSymbols.PromptIndicator = [char]::ConvertFromUtf32(0x003E) * 2
$sl.PromptSymbols.SegmentSeparator = [char]::ConvertFromUtf32(0x003A) * 2
$sl.PromptSymbols.StartSymbol = ''
$sl.PromptSymbols.EndSymbol = [char]::ConvertFromUtf32(0x00BB)
$sl.Colors.GitForegroundColor = [ConsoleColor]::DarkYellow
$sl.Colors.HistoryForegroundColor = [ConsoleColor]::Green
$sl.Colors.PathForegroundColor = [ConsoleColor]::Magenta
$sl.Colors.PromptBackgroundColor = [ConsoleColor]::DarkMagenta
$sl.Colors.PromptForegroundColor = [ConsoleColor]::White
$sl.Colors.PromptStopwatchColor = [ConsoleColor]::DarkGray
$sl.Colors.PromptSymbolColor = [ConsoleColor]::Gray
$sl.Colors.UserSessionInfoForegroundColor = [ConsoleColor]::Gray
$sl.Colors.SessionInfoComputerForegroundColor = [ConsoleColor]::Gray
$sl.Colors.WithBackgroundColor = [ConsoleColor]::DarkBlue
$sl.Colors.WithForegroundColor = [ConsoleColor]::DarkRed

# $sl.Colors.VirtualEnvBackgroundColor = [System.ConsoleColor]::Red
$sl.Colors.VirtualEnvForegroundColor = [System.ConsoleColor]::Yellow

if (Test-Administrator) {
    $sl.Colors.SessionInfoUsernameForegroundColor = [ConsoleColor]::DarkYellow
    $sl.Colors.SegmentSeparator = [ConsoleColor]::DarkYellow
}
else {
    $sl.Colors.SessionInfoUsernameForegroundColor = [ConsoleColor]::Blue
    $sl.Colors.SegmentSeparator = [ConsoleColor]::Blue
}
