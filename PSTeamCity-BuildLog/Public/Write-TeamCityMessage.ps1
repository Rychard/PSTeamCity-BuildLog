<#
.SYNOPSIS
    Writes a message to the TeamCity build log.
    Writes the message directly if not ran in a TeamCity build environment.

.LINK
    https://confluence.jetbrains.com/display/TCD9/Build+Script+Interaction+with+TeamCity
#>
Function Write-TeamCityMessage {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$Message
    )

    if (Test-TeamCity) {
        $escaped = $Message | Get-TeamCityEscapedString
        $formatted = "##teamcity[message text='$($escaped)']"
        Write-Host $formatted
    } else {
        Write-Host $Message
    }
}