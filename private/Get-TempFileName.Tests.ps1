Describe "Get-TempFileName" {

    BeforeAll {
        . $PSCommandPath.Replace('.Tests.ps1', '.ps1')
    }

    It "Creates a temporary file with a .gpx extension" {
        $result = Get-TempFileName -Extension 'gpx'
        
        $result | Should -BeLike "$env:TEMP*.gpx"
    }
}