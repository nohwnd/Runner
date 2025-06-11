function ConvertTo-Km {
    param (
        [Parameter(Mandatory)]
        [decimal] $Mile
    )

    return $Mile * 1.60934
}