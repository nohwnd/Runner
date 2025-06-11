function ConvertTo-Km {
    param (
        [Parameter(Mandatory)]
        [decimal] $Mile
    )

    return $Miles * 1.60934
}