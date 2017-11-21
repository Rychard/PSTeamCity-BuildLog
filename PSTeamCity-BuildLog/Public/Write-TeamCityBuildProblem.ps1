<#
.SYNOPSIS
    Writes a message to the TeamCity build log indicating a problem with the build.
    Produces no output if not ran in a TeamCity build environment.

.PARAMETER Identity
    A unique problem id. 
    Different problems must have different identity, same problems - same identity.
    The identity should not change throughout builds if the same problem occurs
    It should be a valid Java id up to 60 characters.

.PARAMETER Description
    A human-readable plain text describing the build problem.
    The description appears in the build status text and in the list of build's problems.
    The text is limited to 4000 symbols, and will be truncated if the limit is exceeded.

.LINK
    https://confluence.jetbrains.com/display/TCD9/Build+Script+Interaction+with+TeamCity
#>
Function Write-TeamCityBuildProblem {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$Identity,

        [Parameter(Mandatory=$true, Position=1)]
        [ValidateNotNullOrEmpty()]
        [String]$Description,

        [Parameter(Mandatory=$false, Position=2)]
        [Switch]$Force
    )

    $formatted = $Description

    if ((Test-TeamCity) -or $Force.IsPresent) {
        $escapedIdentity = $Identity | Get-TeamCityEscapedString
        $escapedDescription = $Description | Get-TeamCityEscapedString

        $formatted = "##teamcity[buildProblem identity='$($escapedIdentity)' description='$($escapedDescription)']"
        Write-Output $formatted
    }
}