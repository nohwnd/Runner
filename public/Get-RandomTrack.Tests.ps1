Describe "Get-RandomTrack" {
    BeforeAll {
        . $PSCommandPath.Replace('.Tests.ps1', '.ps1')
    }
    It -Name 'Get a random track' {
        Mock -CommandName Invoke-RestMethod -ParameterFilter {$Uri -like '*/tracks?*'} -MockWith {
            [pscustomobject]@{
                trackId         = 123
                trackDifficulty = 1
                length          = 9
                gpx             = "<gpx>...</gpx>"
                name            = "John's Trail"
            }
        }
        Mock -CommandName Invoke-RestMethod -ParameterFilter {$Uri -like '*/ratings?*'} -MockWith {
            [pscustomobject]@{
                trackId = 123
                rating  = 4.5
            }
        }
        Mock -CommandName Invoke-RestMethod -MockWith {throw}

        $result = Get-RandomTrack -Length 9 -Difficulty easy -Unit km
    }
}