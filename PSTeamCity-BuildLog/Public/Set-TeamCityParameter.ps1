<#
.SYNOPSIS
    Sets the value of a TeamCity build parameter.
    The specified parameter must be defined in the parameters section of the build configuration.

.LINK
    https://confluence.jetbrains.com/display/TCD9/Build+Script+Interaction+with+TeamCity
#>
Function Set-TeamCityParameter {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true, Position=0)]
        [ValidateNotNullOrEmpty()]
        [String]$Name,

        [Parameter(Mandatory=$true, Position=1)]
        [String]$Value
    )

    if (Test-TeamCity) {
        $escapedName = $Name | Get-TeamCityEscapedString
        $escapedValue = $Value | Get-TeamCityEscapedString

        Write-Output "##teamcity[setParameter name='${escapedName}' value='${escapedValue}']"
    }
}