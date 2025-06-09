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

    # @{
    #     trackId = 123
    #     trackDifficulty = 1
    #     length = 9
    #     gpx = "<gpx>...</gpx>"
    #     name = "John's Trail"
    # }
    
    $route = $routes | Get-Random

    $ratingUrl = Get-Url -Route "ratings" -Parameters @{ trackId = $route.trackId }

    # @{
    #     trackId = 123
    #     rating = 4.5
    # }
    $rating = Invoke-RestMethod -Uri $ratingUrl -Method GET

    return @{
        TrackId = $route.trackId
        Difficulty = $route.trackDifficulty
        Length = $route.length
        Gpx = $route.gpx
        Name = $route.name

        Rating = $rating.rating
    }
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