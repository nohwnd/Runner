function ConvertTo-DifficultyNumber {
    param (
        [Parameter(Mandatory)]
        [ValidateSet('Easy', 'Medium', 'Hard')]
        [string]$Difficulty
    )

    switch ($Difficulty) {
        'Easy'   { return 1 }
        'Medium' { return 2 }
        'Hard'   { return 3 }
    }
}