Describe "Get-RandomTrack" {
    BeforeAll {
        Import-Module $PSScriptRoot\..\Runner.psm1 -Force
    }
    
    It -Name 'Gets random provided track from the real API' {
        $actual = Get-RandomTrack -Length 10 -Difficulty easy
        
        # we call the real api, but we have randomness in the response, so we need to check only the properties
        # we really care about and that re deterministic
        $expected = @{
            Difficulty  = 1
            Length      = 10
        }
        
        $actual | Should-BeEquivalent $expected -ExcludePathsNotOnExpected
    }
}