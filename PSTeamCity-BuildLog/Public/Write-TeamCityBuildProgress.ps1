<#
.SYNOPSIS
    Writes a progress message tothe TeamCity build log, indicating a long-running parts of the build.  
    Writes the message directly if not ran in a TeamCity build environment.
    These messages will be shown on the projects dashboard, as well as the Build Results page.

.LINK
    https://confluence.jetbrains.com/display/TCD9/Build+Script+Interaction+with+TeamCity
#>
Function Write-TeamCityBuildProgress {
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
        $formatted = "##teamcity[progressMessage '$($escaped)']"

        Write-Output $formatted
    }
}