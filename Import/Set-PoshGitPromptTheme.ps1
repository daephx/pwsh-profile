
# Posh-git prompt theming

function Set-Stopwatch {
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

# $GitPromptSettings.DefaultPromptPath.ForegroundColor = 'Orange'
# $GitPromptSettings.DefaultPromptPrefix.Text = '$(Get-Date -f "MM-dd HH:mm:ss") '

$GitPromptSettings.DefaultForegroundColor = "Magenta"
$GitPromptSettings.DefaultPromptAbbreviateHomeDirectory = $True
$GitPromptSettings.DefaultPromptSuffix = $(' >> ' * ($nestedPromptLevel + 1))