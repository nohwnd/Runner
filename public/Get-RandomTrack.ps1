function Get-RandomTrack {
    param (
        [Parameter(Mandatory)]
        [decimal]$Length,

        [ValidateSet("easy", "medium", "hard")]
        [string] $Difficulty = "easy",

        [ValidateSet("km", "mi")]
        $Unit = "km"
    )

    $url = Get-Url -Route "tracks" -Parameters @{ 
        length     = $Length
        trackDifficulty = ConvertTo-DifficultyNumber $Difficulty
    }

    if ($Unit -eq "mi") {
        $Length = ConvertTo-Km -Mile $Length
    }

    # "https://api.example.com/tracks?length=7"
    $routes = Invoke-RestMethod -Uri $url -Method GET

    # @{
    #     trackId = 123
    #     trackDifficulty = 1
    #     length = 9
    #     gpx = "<gpx>...</gpx>"
    #     name = "John's Trail"
    # }
    
    $route = $routes | Get-Random

    if (-not $route) {
        throw "No routes found matching the criteria."
    }

    $ratingUrl = Get-Url -Route "ratings" -Parameters @{ trackId = $route.trackId }

    # @{
    #     trackId = 123
    #     rating = 4.5
    # }
    $rating = Invoke-RestMethod -Uri $ratingUrl -Method GET

    return @{
        TrackId    = $route.trackId
        Difficulty = $route.trackDifficulty
        Length     = $route.length
        Gpx        = $route.gpx
        Name       = $route.name

        Rating     = $rating.rating
    }
}