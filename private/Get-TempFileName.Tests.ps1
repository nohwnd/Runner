Describe 'Get-TempFileName' {

    BeforeAll {
        . $PSCommandPath.Replace('.Tests.ps1', '.ps1')
    }

    It 'Creates a temporary file with a .gpx extension' {
        $result = Get-TempFileName -Extension 'gpx'
        $tempPath = [System.IO.Path]::GetTempPath()
        
        # Test that the file ends with .gpx
        $result | Should -Match '\.gpx$'
        
        # Test that the file is in the correct temp directory
        $result | Should -BeLike "$tempPath*"
    }

    It 'Creates a temporary file without extension when no extension specified' {
        $result = Get-TempFileName
        $tempPath = [System.IO.Path]::GetTempPath()
        
        # Should end with .tmp (default temp file extension)
        $result | Should -Match '\.tmp$'
        
        # Should be in the correct temp directory
        $result | Should -BeLike "$tempPath*"
    }
}