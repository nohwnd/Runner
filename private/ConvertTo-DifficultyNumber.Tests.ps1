Describe "ConvertTo-DifficultyNumber" {
    BeforeAll {
        . $PSCommandPath.Replace('.Tests.ps1', '.ps1')
    }

    # TASK 2 
    #
    # 1. Start from asking the audience to write the positive conversion code using what they just learned. 
    # We convert easy -> 1, medium -> 2, hard -> 3.
    It "converts difficulty string to number" -ForEach @(
        @{ Value = 'Easy'; Expected = 1 }
        @{ Value = 'Medium'; Expected = 2 }
        @{ Value = 'Hard'; Expected = 3 } 
    ) {
        
        ConvertTo-DifficultyNumber $Value | Should -Be $Expected
    }


    # 2. Show Should -Throw.
    It "Fails for `$null" {
        { ConvertTo-DifficultyNumber -Difficulty $null } | Should -Throw "Cannot validate argument on parameter 'Difficulty'.*"
    }

    # 3. the audience will now rewrite the test to be data driven, and will provide more examples for failed test.
    # We want at least 3 examples but they can provide infinite number of them.
    It "Fails for unknown difficulty '<difficulty>'" -ForEach @(
        @{ Difficulty = $null },
        @{ Difficulty = 0 },
        @{ Difficulty = 'very hard' }
    ) {
        { ConvertTo-DifficultyNumber -Difficulty $Difficulty } | Should -Throw "Cannot validate argument on parameter 'Difficulty'.*"
    }
}