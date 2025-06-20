Import-Module "$PSScriptRoot\Runner.psm1" -Force

$pesterConfiguration = New-PesterConfiguration

$pesterconfiguration.Output.Verbosity = 'Detailed'

# Enable code coverage
$pesterConfiguration.CodeCoverage.Enabled = $true
$pesterConfiguration.CodeCoverage.Path = @(
    "$PSScriptRoot\public",
    "$PSScriptRoot\private", 
    "$PSScriptRoot\Runner.psm1"
)

# Set output formats for different coverage tools
$pesterConfiguration.CodeCoverage.OutputFormat = 'CoverageGutters'
$pesterConfiguration.CodeCoverage.OutputPath = 'coverage.xml'

# Enable XML output for CI/CD
$pesterConfiguration.TestResult.Enabled = $true
$pesterConfiguration.TestResult.OutputFormat = 'NUnitXml'
$pesterConfiguration.TestResult.OutputPath = 'testresults.xml'

$pesterConfiguration.Run.PassThru = $true
# $pesterConfiguration.Run.TestExtension = "IntegrationTests.ps1"

# Run the tests
$result = Invoke-Pester -Configuration $pesterConfiguration

# Exit with error code if tests failed
if ($result.FailedCount -gt 0) {
    Write-Error "Tests failed: $($result.FailedCount) failed out of $($result.TotalCount)"
    exit 1
}