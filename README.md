# PowerShell Profile

This repository contains my PowerShell profile designed to work with Windows
PowerShell 5.1 and PowerShell Core 6+. The profile is organized into separate
scripts for modular settings.

## Installation

To install this profile:

1. Clone the repository to the appropriate directory based on your PowerShell
   version:

- For PowerShell Core 6+, clone to `$HOME\Documents\PowerShell`
- For Windows PowerShell 5.1, clone to `$HOME\Documents\WindowsPowerShell`

```bash
git clone https://github.com/daephx/pwsh-profile <destination-directory>
```

1. After cloning, restart your PowerShell session to apply the changes.

## Optimizing Your Profile

To optimize and debug performance issues with your profile, use the following
script:

```powershell
Install-Module PSProfiler
Import-Module PSProfiler
Measure-Script -Path $PROFILE.CurrentUserAllHosts
```

This script will help identify and improve performance bottlenecks in your
PowerShell profile.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
