function Send-Track {
    param(
        [Parameter(Mandatory)]
        $Track
    )

    # https://github.com/EvotecIT/Mailozaurr/blob/v2-speedygonzales/Tests/Send-EmailMessage.Tests.ps1

    if ($null -eq $Track.Gpx) {
        throw "Track.Gpx cannot be null."
    }

    $tempFile = Get-TempFileName -Extension ".gpx"

    Set-Content -Path $tempFile -Value $Track.Gpx -Encoding UTF8

    $sendEmailMessageSplat = @{
        From       = @{ 
            Name  = "Track Runner"
            Email = "jakub@jakub.com"
        }
        To         = "jakub@jakub.com"
        Server     = 'smtp.office365.com'
        HTML       = "<B>Your next journey awaits!</B><br/>"
        Subject    = 'Here is your run for today!'
        Attachment = $tempFile
        Password   = Get-Secret -Name 'MailozaurrPassword' -Vault 'CredMan'
    }

    Send-EmailMessage @sendEmailMessageSplat -ErrorAction Stop
}