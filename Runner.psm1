# Fake functions to simulate the behavior of other modules.
function Get-Secret { 
    param (
        [Parameter(Mandatory)]
        [string] $Name,
        [Parameter(Mandatory)]
        [string] $Vault
    )

    "aaaa" 
}
function Send-EmaileMessage {
    param (
        [Parameter(Mandatory)]
        [hashtable] $From,

        [Parameter(Mandatory)]
        [string] $To,

        [Parameter(Mandatory)]
        [string] $Server,

        [Parameter(Mandatory)]
        [string] $HTML,

        [Parameter(Mandatory)]
        [string] $Subject,

        [Parameter(Mandatory)]
        [string] $Attachment,

        [Parameter(Mandatory)]
        [SecureString] $Password
    )

    # nop
}


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
        length     = $Length
        difficulty = $Difficulty
        count      = 10 
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
        TrackId    = $route.trackId
        Difficulty = $route.trackDifficulty
        Length     = $route.length
        Gpx        = $route.gpx
        Name       = $route.name

        Rating     = $rating.rating
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

function Send-Track {
    param(
        [Parameter(Mandatory)]
        [hashtable] $Track
    )

    // https://github.com/EvotecIT/Mailozaurr/blob/v2-speedygonzales/Tests/Send-EmailMessage.Tests.ps1

    if ($null -eq $Track.Gpx) {
        throw "Track.Gpx cannot be null."
    }

    $tempFile = Get-TempFileName -Extension ".gpx"

    $sendEmailMessageSplat = @{
        From       = @{ 
            Name  = $configuration.Name
            Email = $configuration.Email
        }
        To         = $configuration.Email
        Server     = 'smtp.office365.com'
        HTML       = "<B>Your next journey awaits!</B><br/>"
        Subject    = 'Here is your run for today!'
        Attachment = $tempFile
        Password   = Get-Secret -Name 'MailozaurrPassword' -Vault 'CredMan'
    }

    Send-EmailMessage @sendEmailMessageSplat -ErrorAction Stop
}

function Get-TempFileName {
    param (
        [string] $Extension
    )

    $tempFile = [System.IO.Path]::GetTempFileName()
    if ($Extension) {
        $tempFile = [System.IO.Path]::ChangeExtension($tempFile, $Extension)
    }

    return $tempFile
}