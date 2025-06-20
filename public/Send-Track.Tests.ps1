Describe "Send-Track" {
    BeforeAll {
        Import-Module $PSScriptRoot\..\Runner.psm1 -Force
    }
    
    # TASK 7: introduce test drive, mock some internal functions, that should be safe to mock, or we don't have much
    # other way to test the code. Without mocking get-tempfilename we would not know where the file is, maybe we would not care
    # but let's assume we care.
    # we are mocking more edges of the module, because we don't feel like sending emails.
    It 'Sends email with attachment' {
        Mock -CommandName Get-TempFileName -MockWith { "TestDrive:\track.gpx" } -ModuleName Runner

        Mock -CommandName Get-Secret -MockWith { "password123" | ConvertTo-SecureString -AsPlainText } -ModuleName Runner

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
}