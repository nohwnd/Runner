

. $PSScriptRoot\Fakes.ps1

$export = @()

foreach ($script in Get-ChildItem $PSScriptRoot\public\*.ps1) {
    if ($script -notlike "*.Tests.ps1") {
        . $script

        $export += $script.BaseName
    }
}

foreach ($script in Get-ChildItem $PSScriptRoot\private\*.ps1) {
    if ($script -notlike "*.Tests.ps1") {
        . $script
    }
}

Export-ModuleMember -Function $export