@{

    # Script module or binary module file associated with this manifest.
    RootModule = 'Runner.psm1'

    # Version number of this module.
    ModuleVersion     = '0.0.1'

    # Supported PSEditions
    # CompatiblePSEditions = @()

    # ID used to uniquely identify this module
    GUID              = 'd3b0e00a-2c97-419b-84db-86bc6efb5dfb'

    # Author of this module
    Author            = 'nohwnd'

    # Company or vendor of this module
    CompanyName       = 'Unknown'

    # Copyright statement for this module
    Copyright         = '(c) nohwnd, All rights reserved.'

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport = @(
        'Get-RandomTrack',
        'Send-Track'
    )

    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport   = @()

    # Variables to export from this module
    VariablesToExport = @()

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    AliasesToExport   = @()

    # DSC resources to export from this module
    # DscResourcesToExport = @()

    # List of all modules packaged with this module
    # ModuleList = @()

    # List of all files packaged with this module
    # FileList = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData       = @{
        PSData = @{

            # Prerelease string of this module
            # Prerelease = 'beta1'

        }
    }
}

