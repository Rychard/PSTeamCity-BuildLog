<#
.SYNOPSIS
    Enable parsing of service messages in TeamCity.

.LINK
    https://confluence.jetbrains.com/display/TCD9/Build+Script+Interaction+with+TeamCity
#>
Function Enable-TeamCityServiceMessage {
    [CmdletBinding()]
    Param ()

    if (Test-TeamCity) {
        Write-Output "##teamcity[enableServiceMessages]"
    }
}