<#
.SYNOPSIS
    Disable parsing of service messages in TeamCity.

.LINK
    https://confluence.jetbrains.com/display/TCD9/Build+Script+Interaction+with+TeamCity
#>
Function Disable-TeamCityServiceMessage {
    [CmdletBinding()]
    Param ()

    if (Test-TeamCity) {
        Write-Output "##teamcity[disableServiceMessages]']"
    }
}