Describe "ConvertTo-Km" {
    
    BeforeAll {
        . $PSCommandPath.Replace('.Tests.ps1', '.ps1')
    }

    It -Name '<mile> mi should be <expected> km' -ForEach @(
        @{ Mile = 1; Expected = 1.60934 },
        @{ Mile = 5; Expected = 8.0467 },
        @{ Mile = 10; Expected = 16.0934 },
        @{ Mile = 0; Expected = 0 }
    ) {
        ConvertTo-Km -Mile $Mile | Should -Be $Expected
    }
}