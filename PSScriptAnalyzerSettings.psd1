@{
    # Use Severity when you want to limit the generated diagnostic records to a
    # subset of: Error, Warning and Information.
    # Uncomment the following line if you only want Errors and Warnings but
    # not Information diagnostic records.
    Severity = @("Error", "Warning")

    # Use IncludeRules when you want to run only a subset of the default rule set.
    IncludeRules = @("PSPlaceOpenBrace", "PSUseConsistentIndentation")
    Rules = @{
        PSUseCompatibleSyntax = @{
            Enable = $true
            # List the targeted versions of PowerShell here
            TargetVersions = @( "5.1", "6.2", "7.0")
        }

    # Use ExcludeRules when you want to run most of the default set of rules except
    # for a few rules you wish to "exclude".  Note: if a rule is in both IncludeRules
    # and ExcludeRules, the rule will be excluded.
    ExcludeRules = @(
        "PSAvoidUsingWriteHost",
        "PSMissingModuleManifestField"
    )

    # You can use the following entry to supply parameters to rules that take parameters.
    # For instance, the PSAvoidUsingCmdletAliases rule takes a whitelist for aliases you
    # want to allow

    # Check if your script uses cmdlets that are compatible on PowerShell Core,
    # PSUseCompatibleCmdlets = @{Compatibility = @("core-6.0.0-alpha-linux")}

        PSPlaceOpenBrace = @{
            Enable = $true
            IgnoreOneLineBlock = $true
            OnSameLine = $true
        }
        PSUseConsistentIndentation = @{
            Enable = $true
        }
    }
}
