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

function Send-EmailMessage {
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

    Write-Host "Sending email to: $To with attachment: $Attachment"
}