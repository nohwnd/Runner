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