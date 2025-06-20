Import-Module "$PSScriptRoot\Runner.psm1" -Force

$pesterConfiguration = New-PesterConfiguration

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

# Display missed commands for local debugging
Write-Host "=== Commands Missed ===" -ForegroundColor Yellow
$result.CodeCoverage.CommandsMissed | Select-Object -Property Command, File, Line | Format-Table -AutoSize

# Display coverage summary
Write-Host "=== Coverage Summary ===" -ForegroundColor Green
Write-Host "Commands Analyzed: $($result.CodeCoverage.CommandsAnalyzed)" -ForegroundColor White
Write-Host "Commands Executed: $($result.CodeCoverage.CommandsExecuted)" -ForegroundColor White  
Write-Host "Commands Missed: $($result.CodeCoverage.CommandsMissed.Count)" -ForegroundColor White
$coveragePercent = [math]::Round(($result.CodeCoverage.CommandsExecuted / $result.CodeCoverage.CommandsAnalyzed) * 100, 2)
Write-Host "Coverage Percentage: $coveragePercent%" -ForegroundColor $(if($coveragePercent -ge 80) { 'Green' } elseif($coveragePercent -ge 60) { 'Yellow' } else { 'Red' })

# Exit with error code if tests failed
if ($result.FailedCount -gt 0) {
    Write-Error "Tests failed: $($result.FailedCount) failed out of $($result.TotalCount)"
    exit 1
}

# Exit with error code if coverage is too low (optional)
if ($coveragePercent -lt 60) {
    Write-Warning "Code coverage is below 60% ($coveragePercent%)"
    # Uncomment the next line if you want to fail the build on low coverage
    # exit 1
}