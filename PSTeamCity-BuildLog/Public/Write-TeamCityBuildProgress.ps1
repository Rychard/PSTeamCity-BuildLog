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
        [String]$Message
    )

    if (Test-TeamCity) {
        $escaped = $Message | Get-TeamCityEscapedString
        $formatted = "##teamcity[progressMessage '$($escaped)']"
        Write-Host $formatted
    } else {
        Write-Host $Message
    }
}