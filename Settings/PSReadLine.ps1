# Define default options
$PSReadLineOptions = @{
    BellStyle = "None" # Remove the annoying bell sound
    ContinuationPrompt = " ❯ "
    EditMode = "Vi" # Emacs | Vi | Windows
    HistoryNoDuplicates = $True
    HistorySearchCursorMovesToEnd = $True
    MaximumHistoryCount = 4000
    PredictionSource = "History"
    Colors = @{
        Command = "Green"
        Comment = "DarkGray"
        ContinuationPrompt = "DarkGray"
        InlinePrediction = "DarkGray"
        Keyword = "Magenta"
        Member = "Cyan"
        Number = "Magenta"
        Operator = "White"
        Parameter = "White"
        String = "Yellow"
        Type = "Cyan"
        Variable = "Green"
    }
}

# Apply options
Set-PSReadLineOption @PSReadLineOptions

# Set vi mode cursor
$ESC = "$([char]0x1b)" # Required for PowerShell 5.1
Write-Host -NoNewline "$ESC[5 q" # Start with line cursor
$OnViModeChange = [scriptblock] {
    # Set the cursor to a blinking block.
    if ($args[0] -eq "Command") { Write-Host -NoNewline "$ESC[1 q" }
    # Set the cursor to a blinking bar.
    else { Write-Host -NoNewline "$ESC[5 q" }
}

# Enable vi mode
Set-PSReadLineOption -ViModeIndicator Script -ViModeChangeHandler $OnViModeChange

# Allow ctrl-[ to escape vi command mode
# See: https://github.com/PowerShell/PSReadLine/issues/906
Set-PSReadLineKeyHandler -Key "Ctrl+Oem4" -Function ViCommandMode

# Prevent accidental deletion of lines
Set-PSReadLineKeyHandler -key Escape -Function ViCommandMode

# Search history arrow-completion
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

# Bash similarities
Set-PSReadLineKeyHandler -Key Ctrl+d -Function ViExit
Set-PSReadLineKeyHandler -Key Ctrl+k -Function KillWord
Set-PSReadLineKeyHandler -Key Ctrl+u -Function DeleteLine
Set-PSReadLineKeyHandler -Key Ctrl+w -Function BackwardKillWord

# Copy current directory to clipboard
$Splat = @{
    Chord = "Alt+c"
    BriefDescription = "CopyPathToClipboard"
    LongDescription = "Copies the current path to the clipboard"
    ScriptBlock = { (Resolve-Path -LiteralPath $PWD).ProviderPath.Trim() | clip }
}
Set-PSReadLineKeyHandler @Splat
Clear-Variable -Name Splat
