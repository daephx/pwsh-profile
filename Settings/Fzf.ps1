if (-not (Get-Command fzf -ErrorAction Ignore)) { return }

# Export environment variables
$ENV:FZF_ALT_COMMAND = "fd -uu -t f"
$ENV:FZF_DEFAULT_COMMAND = "rg -uu --files -H"
$ENV:FZF_COMPLETION_TRIGGER = "**"

# Define fzf default options
$ENV:FZF_DEFAULT_OPTS = @"
--info=inline
--layout=reverse
--margin=0,1
--pointer='❯'
--preview-window==border-left
--prompt='❯ '
--color=dark
--color=bg+:-1
--color=bg:-1
--color=border:238
--color=fg+:15
--color=fg:8
--color=gutter:-1
--color=header:3
--color=hl+:3
--color=hl:6
--color=info:5
--color=marker:6
--color=pointer:3
--color=preview-fg:7
--color=prompt:4
--color=spinner:3
--bind='change:top'
--bind='alt-a:toggle-all'
--bind='alt-d:page-down+refresh-preview'
--bind='alt-g:ignore'
--bind='alt-h:backward-char+refresh-preview'
--bind='alt-l:forward-char+refresh-preview'
--bind='alt-p:toggle-preview'
--bind='alt-s:toggle-sort'
--bind='alt-u:page-up+refresh-preview'
--bind='alt-y:yank'
--bind='ctrl-d:half-page-down+refresh-preview'
--bind='ctrl-l:clear-screen'
--bind='ctrl-s:preview-page-up'
--bind='ctrl-u:kill-line'
--bind='ctrl-x:preview-page-down'
--bind='end:last'
--bind='home:top'
"@

# PsFzf Module options
if (Get-Module "PsFzf" -ListAvailable) {
    $Options = @{
        AltCCommand = [ScriptBlock] {
            param($Location)
            Set-Location $Location
        }
        PSReadlineChordProvider = "ctrl+f"
        PSReadlineChordReverseHistory = "ctrl+r"
        TabExpansion = $True
    }
    Set-PsFzfOption @Options
    Clear-Variable -Name Options

    Set-Alias fe    Invoke-FuzzyEdit
    Set-Alias ff    Invoke-FuzzySetLocation
    Set-Alias fgs   Invoke-FuzzyGitStatus
    Set-Alias fh    Invoke-FuzzyHistory
    Set-Alias fkill Invoke-FuzzyKillProcess
    Set-Alias fza   Set-LocationFuzzyEverything

    if (Get-Module "PSReadLine" -ListAvailable) {
        # NOTE: Issue with PsFzf that prevents tab completion from adding trailing slash for directories
        # Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }

        # Set-PSReadLineKeyHandler -Key Ctrl-r -ScriptBlock { Invoke-FuzzyHistory }
        # Set-PSReadLineKeyHandler -Key Ctrl-t -ScriptBlock { Invoke-FuzzySetLocation }
    }
}
