Import-Module "$PSScriptRoot\Runner.psm1" -Force
$pesterConfiguration = New-PesterConfiguration

$pesterConfiguration.CodeCoverage.Enabled = $true
$pesterConfiguration.CodeCoverage.Path = @(
    "$PSScriptRoot\public",
    "$PSScriptRoot\private",
    "$PSScriptRoot\Runner.psm1"
)
$pesterConfiguration.Run.PassThru = $true

$result = Invoke-Pester -Configuration $pesterConfiguration

$result.CodeCoverage.CommandsMissed  | Select-Object -Property Command, File, Line