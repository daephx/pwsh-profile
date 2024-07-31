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
        "PSPlaceOpenBrace",
        "PSUseConsistentIndentation"
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
            TargetVersions = @( "5.1", "6.2", "7.0")
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
    }
}
