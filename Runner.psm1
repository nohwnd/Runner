function Get-RandomRoute {
    param (
        [Parameter(Mandatory)]
        [decimal]$Length,

        [ValidateSet("easy", "medium", "hard")]
        [string] $Difficulty = "easy",

        [ValidateSet("km", "mi")]
        $Unit = "km"
    )

    $url = Get-Url -Route "tracks" -Parameters @{ 
            length = $Length
            difficulty = $Difficulty
            count = 10 
        }

    if ($Unit -eq "mi") {
        $Length = ConvertTo-Km -Mile $Length
    }

    # "https://api.example.com/tracks?length=7&count=10"
    $routes = Invoke-RestMethod -Uri $url -Method GET

    $routes | Get-Random
}

function Get-Url {
    param (
        [Parameter(Mandatory)]
        [hashtable] $Parameters,

        [Parameter(Mandatory)]
        [string] $Route
    )

    $baseUrl = Get-BaseUrl
    $queryString = foreach ($p in $Parameters) { "$($p.Key)=$($p.Value)" } -join "&"
    
    return "$baseUrl/$Route?$queryString"
}

function Get-BaseUrl {
    return "https://api.example.com"
}

function ConvertTo-Km {
    param (
        [Parameter(Mandatory)]
        [decimal] $Mile
    )

    return $Miles * 1.60934
}