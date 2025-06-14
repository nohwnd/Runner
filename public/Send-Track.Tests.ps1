Describe "Send-Track" {
    BeforeAll {
        Import-Module $PSScriptRoot\..\Runner.psm1 -Force
    }
    
    It 'Throws when gpx is null' {
        {
            Send-Track -Track @{
                TrackId    = 123
                Difficulty = 1
                Length     = 9
                Gpx        = $null
                Name       = "John's Trail"
            } 
        } | Should -Throw "Track.Gpx cannot be null."
    }       

    It 'Sends email with attachment' {
        Mock -CommandName Get-TempFileName -MockWith { "TestDrive:\track.gpx" } -ModuleName Runner

        Mock -CommandName Get-Secret -MockWith {  "password123" | ConvertTo-SecureString -AsPlainText } -ModuleName Runner

        Mock -CommandName Send-EmailMessage -MockWith { } -ModuleName Runner

        $track = @{
            TrackId    = 123
            Difficulty = 1
            Length     = 9
            Gpx        = "<gpx>...</gpx>"
            Name       = "John's Trail"
        }

        # -- act
        Send-Track -Track $track

        # -- assert
        "TestDrive:\track.gpx" | Should -FileContentMatchMultiline $track.Gpx
        Should -Invoke -CommandName Send-EmailMessage -Exactly 1 -ModuleName Runner -ParameterFilter {
            $Attachment -eq "TestDrive:\track.gpx" -and $Subject -eq 'Here is your run for today!'
        }
    }
}