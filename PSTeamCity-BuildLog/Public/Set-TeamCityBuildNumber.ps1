<#
.SYNOPSIS
    Sets a custom build number in TeamCity.
    In the new value, {build.number} will be substituted for the current build number automatically generated by TeamCity.

.LINK
    https://confluence.jetbrains.com/display/TCD9/Build+Script+Interaction+with+TeamCity
#>
Function Set-TeamCityBuildNumber {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true, Position=0)]
        [ValidateNotNullOrEmpty()]
        [String]$BuildNumber
    )

    if (Test-TeamCity) {
        $escapedBuildNumber = $Name | Get-TeamCityEscapedString

        Write-Output "##teamcity[buildNumber '${escapedBuildNumber}']"
    }
}