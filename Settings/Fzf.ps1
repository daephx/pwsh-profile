# Fzf: A command-line fuzzy finder
# https://github.com/junegunn/fzf
if (-not (Get-Command fzf -ErrorAction Ignore)) { return }

# Set default options for FZF
$ENV:FZF_ALT_COMMAND = "fd -uu -t f"
$ENV:FZF_COMPLETION_TRIGGER = "**"
$ENV:FZF_DEFAULT_COMMAND = "rg -uu --files -H"
$ENV:FZF_DEFAULT_OPTS = @"
--height=60%
--info=inline-right
--layout=reverse
--margin=0,1,0,0
--marker='⦿'
--padding 0,1
--pointer='❯'
--preview-window=border-left
--prompt='❯ '
--separator=''
--color=dark
--color=bg+:234
--color=bg:-1
--color=border:8
--color=fg+:15
--color=fg:8
--color=gutter:-1
--color=header:3
--color=hl+:3
--color=hl:6
--color=info:3
--color=marker:6
--color=pointer:3
--color=preview-fg:7
--color=prompt:4
--color=spinner:3
--bind='change:top'
--bind='alt-a:toggle-all'
--bind='alt-g:ignore'
--bind='alt-p:toggle-preview'
--bind='alt-s:toggle-sort'
--bind='alt-y:yank'
--bind='ctrl-b:preview-page-up'
--bind='ctrl-d:preview-half-page-down'
--bind='ctrl-l:clear-screen'
--bind='ctrl-u:unix-line-discard'
--bind='end:last'
--bind='home:first'
--bind='pgdn:half-page-down+refresh-preview'
--bind='pgup:half-page-up+refresh-preview'
--bind='tab:down,btab:up'
"@

# Ctrl-p | Toggle small preview window to see the full command
# Ctrl-y | Copy the command into clipboard using xclip
$ENV:FZF_CTRL_R_OPTS = @"
--header 'Press CTRL-Y to copy command into clipboard'
--bind 'alt-p:toggle-preview'
--bind 'ctrl-y:execute-silent(echo -n {2..} | xclip)+abort'
--preview 'echo {}' --preview-window up:3:hidden:wrap
"@

# PsFzf Module options
if (Get-Module "PsFzf" -ListAvailable) {
    $Options = @{
        AltCCommand = [ScriptBlock] {
            param($Location)
            Set-Location $Location
        }
        PSReadlineChordProvider = "Ctrl+t"
        PSReadlineChordReverseHistory = "Ctrl+r"
        TabExpansion = $True
    }
    Set-PsFzfOption @Options
    Clear-Variable -Name Options

    Set-Alias -Name fe -Value Invoke-FuzzyEdit
    Set-Alias -Name ff -Value Invoke-FuzzySetLocation
    Set-Alias -Name fgs -Value Invoke-FuzzyGitStatus
    Set-Alias -Name fh -Value Invoke-FuzzyHistory
    Set-Alias -Name fkill -Value Invoke-FuzzyKillProcess
    Set-Alias -Name fza -Value Set-LocationFuzzyEverything

    if (Get-Module "PSReadLine" -ListAvailable) {
        # NOTE: Issue with PsFzf that prevents tab completion from adding trailing slash for directories
        # Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }

        # Set-PSReadLineKeyHandler -Key Ctrl-r -ScriptBlock { Invoke-FuzzyHistory }
        # Set-PSReadLineKeyHandler -Key Ctrl-t -ScriptBlock { Invoke-FuzzySetLocation }
    }
}
