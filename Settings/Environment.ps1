# Export environment variables

# Add scripts directory to path for better discoverability
# Set the delimiter, on windows it's semicolon ';', nix is ':' colon
# Get the parent of the first entry in modulepath because there is no var for
# : $HOME\Documents\Powershell\Scripts || $HOME/.local/powershell/scripts
# This makes them discoverable via the 'cmd -c ExternalScript' command.
if ($IsLinux -or $IsMacOS) { $script:Delimiter = ':' }
else { $script:Delimiter = ';' }
$LocalPath = Split-Path -Parent ($ENV:PSModulePath -split $script:Delimiter)[0]
$ENV:PATH += "$Delimiter$(Join-Path $LocalPath 'Scripts')"

# Opt out of dotnet features
$ENV:DOTNET_CLI_TELEMETRY_OPTOUT = $true
$ENV:DOTNET_NOLOGO = $true

# Pager configuration
$env:PAGER = 'less'
$env:LESS = "-QRiFSMn~ --mouse --incsearch"
$env:LESSCHARSET = 'utf-8'
$env:LESSHISTFILE = "-"
$env:LESSEDIT = 'nvim -RM ?lm+%lm. %f'

$e = [char]0x1b
$env:LESS_TERMCAP_mb = "$e[33m" # begin blink - yellow
$env:LESS_TERMCAP_md = "$e[34m" # begin bold - blue
$env:LESS_TERMCAP_me = "$e[0m"  # reset bold/blink
$env:LESS_TERMCAP_se = "$e[0m"  # reset standout
$env:LESS_TERMCAP_so = "$e[33m" # enter standout - yellow
$env:LESS_TERMCAP_ue = "$e[0m"  # reset underline
$env:LESS_TERMCAP_us = "$e[36m" # begin underline - cyan

# GCC Color warnings and errors
$env:GCC_COLORS = @(
    'error=01;31'
    'warning=01;35'
    'note=01;36'
    'caret=01;32'
    'locus=01'
    'quote=01'
) -Join ':'

# Exa color definitions
# https://the.exa.website/docs/colour-themes
$env:EXA_COLORS = @(
    'da=38;5;240'
    'gr=34'
    'gw=35'
    'gx=32'
    'sb=32'
    'sn=32'
    'tr=34'
    'tw=35'
    'tx=32'
    'ue=32'
    'ue=36'
    'un=33'
    'ur=34'
    'uu=36'
    'uw=35'
    'ux=32'
    'xa=36'
) -Join ':'
