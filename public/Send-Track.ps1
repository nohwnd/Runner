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