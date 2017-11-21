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
        [String]$Message,

        [Parameter(Mandatory=$false, Position=1)]
        [Switch]$Force
    )

    if ((Test-TeamCity) -or $Force.IsPresent) {
        $escaped = $Message | Get-TeamCityEscapedString
        $formatted = "##teamcity[message text='$($escaped)']"
        Write-Output $formatted
    }
}