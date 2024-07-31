@{
    # Use Severity when you want to limit the generated diagnostic records to a
    # subset of: Error, Warning and Information.
    # Uncomment the following line if you only want Errors and Warnings but
    # not Information diagnostic records.
    Severity = @("Error", "Warning")

    # Enable default rules in the PSScriptAnalyzer configuration.
    IncludeDefaultRules = $true

    # Use IncludeRules when you want to run only a subset of the default rule set.
    IncludeRules = @(
        "PSAvoidLongLines",
        "PSAvoidTrailingWhitespace",
        "PSPlaceOpenBrace",
        "PSUseCompatibleCmdlets",
        "PSUseCompatibleSyntax",
        "PSUseConsistentIndentation",
        "PSUseConsistentWhitespace"
    )

    # Use ExcludeRules when you want to run most of the default set of rules except
    # for a few rules you wish to "exclude".  Note: if a rule is in both IncludeRules
    # and ExcludeRules, the rule will be excluded.
    ExcludeRules = @(
        "PSAvoidUsingWriteHost",
        "PSMissingModuleManifestField"
    )

    # You can use the following entry to supply parameters to rules that take parameters.
    # For instance, the PSAvoidUsingCmdletAliases rule takes a whitelist for aliases you
    # want to allow.
    Rules = @{
        # Ensures syntax compatibility with specified PowerShell versions.
        PSUseCompatibleSyntax = @{
            Enable = $true
            TargetVersions = @( "5.1", "7.4")
        }

        # Enforces compatibility of cmdlets across specified PowerShell versions and platforms
        PSUseCompatibleCmdlets = @{
            compatibility = @(
                "core-6.1.0-linux",
                "core-6.1.0-macos",
                "core-6.1.0-windows",
                "desktop-5.1.14393.206-windows"
            )
        }

        # Enforces a maximum line length for readability.
        PSAvoidLongLines = @{
            Enable = $true
            MaximumLineLength = 120
        }

        # Configures brace placement for consistency.
        PSPlaceOpenBrace = @{
            Enable = $true
            IgnoreOneLineBlock = $true
            OnSameLine = $true
        }

        # Enforces consistent indentation.
        PSUseConsistentIndentation = @{
            Enable = $true
        }

        # Ensures consistent whitespace usage in the script.
        PSUseConsistentWhitespace = @{
            Enable = $true
            CheckInnerBrace = $true
            CheckOpenBrace = $true
            CheckOpenParen = $true
            CheckOperator = $true
            CheckParameter = $true
            CheckPipe = $true
            CheckPipeForRedundantWhitespace = $false
            CheckSeparator = $true
            IgnoreAssignmentOperatorInsideHashTable = $false
        }
    }
}
