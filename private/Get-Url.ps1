function Get-Url {
    param (
        [Parameter(Mandatory)]
        [hashtable] $Parameters,

        [Parameter(Mandatory)]
        [string] $Route
    )

    $baseUrl = Get-BaseUrl
    $queryString = $(foreach ($p in $Parameters.GetEnumerator()) { "$($p.Key)=$($p.Value)" }) -join "&"
    
    return "$baseUrl/${Route}?$queryString"
}