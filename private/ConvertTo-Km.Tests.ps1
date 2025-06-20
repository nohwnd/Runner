Describe "ConvertTo-Km" {
    
    # TASK 01 -  START here.
    #
    # 1. Talk about the structur of the file, how we name the file and where do we put it in relation to the code file.
    # There are two main options: next to file, and in test folder using the same structure. 
    # Pester can understand both (this) is important for automatic code coverage. 
    #  
    # 2. Describe what Describe is.
    #
    # 3. Describe Before all and the little piece of code we are using to dot-source the code file.
    #
    # 4. Describe what It is. And what assertion is.

    BeforeAll {
        . $PSCommandPath.Replace('.Tests.ps1', '.ps1')
    }

    # 5. write a test without templates and without foreach first. Then refactor to templates and foreach.
    # This is a unit test, we chose this because it just looked easy to test. This test does not have much value.
    It -Name '1 mi should be 1.60934 km' {
        ConvertTo-Km -Mile 1 | Should -Be 1.60934
    }

    # 6. Then refactor to using templates and using foreach.
    It -Name '<mile> mi should be <expected> km' -ForEach @(
        @{ Mile = 1; Expected = 1.60934 },
        @{ Mile = 5; Expected = 8.0467 },
        @{ Mile = 10; Expected = 16.0934 },
        @{ Mile = 0; Expected = 0 }
    ) {
        ConvertTo-Km -Mile $Mile | Should -Be $Expected
    }
}