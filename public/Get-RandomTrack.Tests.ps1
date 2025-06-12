Describe "Get-RandomTrack" {
    BeforeAll {
        # . $PSCommandPath.Replace('.Tests.ps1', '.ps1')

        Import-Module $PSScriptRoot\..\Runner.psm1 -Force
    }
    
    It -Name 'Gets the provided track when there is just one' {
        Mock -CommandName Invoke-RestMethod -MockWith { throw "This is a default mock." } -ModuleName Runner

        Mock -CommandName Invoke-RestMethod -ParameterFilter { $Uri -like '*/tracks?*' } -MockWith {
            [PSCustomObject] @{
                trackId         = 123
                trackDifficulty = 1
                length          = 9
                gpx             = "<gpx>...</gpx>"
                name            = "John's Trail"
            }
        } -ModuleName Runner


        Mock -CommandName Invoke-RestMethod -ParameterFilter { $Uri -like '*/ratings?*' } -MockWith {
            [PSCustomObject] @{
                trackId = 123
                rating  = 4.5
            }
        } -ModuleName Runner
        
        $actual = Get-RandomTrack -Length 9 -Difficulty easy
        
        $actual.Name | Should -Be "John's Trail"
        $actual.TrackId | Should -Be 123
        $actual.Difficulty | Should -Be 1
        $actual.Length | Should -Be 9
        $actual.Gpx | Should -Be "<gpx>...</gpx>"
        $actual.Rating | Should -Be 4.5
    }

    It -Name 'Gets random track when there are multiple tracks (option 1)' {
        # Mocks that make sure the module works
        Mock -CommandName Invoke-RestMethod -MockWith { throw "This is a default mock." } -ModuleName Runner

        Mock -CommandName Invoke-RestMethod -ParameterFilter { $Uri -like '*/tracks?*' } -MockWith {
            [PSCustomObject] @{
                trackId         = 123
                trackDifficulty = 1
                length          = 9
                gpx             = "<gpx>...</gpx>"
                name            = "John's Trail"
            }
        } -ModuleName Runner

        Mock -CommandName Invoke-RestMethod -ParameterFilter { $Uri -like '*/ratings?*' } -MockWith {
            [PSCustomObject] @{
                trackId = 123
                rating  = 4.5
            }
        } -ModuleName Runner

        # Mock that we test
        Mock -CommandName Get-Random -MockWith {
            $InputObject
        } -ModuleName Runner

        $actual = Get-RandomTrack -Length 9 -Difficulty easy
        $actual.Name | Should -Be "John's Trail"

        Should -Invoke -CommandName Get-Random -Exactly 1 -ModuleName Runner -ParameterFilter { $InputObject.TrackId -eq 123 }
    }

    It -Name 'Gets random track when there are multiple tracks' {
        Mock -CommandName Invoke-RestMethod -MockWith { throw "This is a default mock." } -ModuleName Runner
        
        $exampleTrack = @(
            @{
                trackId         = 123
                trackDifficulty = 1
                length          = 9
                gpx             = "<gpx>...</gpx>"
                name            = "John's Trail"
            }
            @{
                trackId         = 124
                trackDifficulty = 1
                length          = 9
                gpx             = "<gpx>...</gpx>"
                name            = "John's Trail 2"
            }
            @{
                trackId         = 125
                trackDifficulty = 1
                length          = 9
                gpx             = "<gpx>...</gpx>"
                name            = "John's Trail 3"
            }
        )

        Mock -CommandName Invoke-RestMethod -ParameterFilter { $Uri -like '*/tracks?*' } -MockWith {
            [PSCustomObject] $exampleTrack
        } -ModuleName Runner


        $exampleRating = @(
            @{
                trackId = 123
                rating  = 4.5
            }
            @{
                trackId = 124
                rating  = 4.5
            }
            @{
                trackId = 125
                rating  = 4.5
            }
        )

        Mock -CommandName Invoke-RestMethod -ParameterFilter { $Uri -like '*/ratings?*' } -MockWith {
            [PSCustomObject] $exampleRating
        } -ModuleName Runner
        
        $actual = 1..20 | ForEach-Object { 
            Get-RandomTrack -Length 9 -Difficulty easy 
        } | Select-Object -ExpandProperty TrackId | Sort-Object -Unique

        Write-Host "Actual: $($actual -join ', ')"
        $actual.Count | Should -Be 3 -Because "we are getting random tracks, and with enough tries we should see all our example tracks being randomly selected"
    }
}