Describe "ConvertTo-DifficultyNumber" {
    BeforeAll {
        . $PSCommandPath.Replace('.Tests.ps1', '.ps1')
    }

    It "Fails for unknown difficulty '<difficulty>'" -ForEach @(
        @{ Difficulty = $null },
        @{ Difficulty = 0},
        @{ Difficulty = 'very hard'}
    ){
        { ConvertTo-DifficultyNumber -Difficulty $null } | Should -Throw "Cannot validate argument on parameter 'Difficulty'.*"
    }

    It 'Returns 1 for "easy"' {
        ConvertTo-DifficultyNumber -Difficulty 'easy' | Should -Be 1
    }

    It 'Returns 2 for "medium"' {
        ConvertTo-DifficultyNumber -Difficulty 'medium' | Should -Be 2
    }

    It 'Returns 3 for "hard"' {
        ConvertTo-DifficultyNumber -Difficulty 'hard' | Should -Be 3
    }
}