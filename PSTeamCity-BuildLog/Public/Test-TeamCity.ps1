<#
.SYNOPSIS
    Determines whether or not the current script is executing on a TeamCity Build Agent.

.OUTPUTS
    Returns $true when running on a build agent; otherwise, $false
#>
Function Test-TeamCity {
    [CmdletBinding()]
    Param ()

    if (Test-Path env:TEAMCITY_VERSION) {
        Write-Verbose "Currently executing on TeamCity Build Agent" 
        Write-Output $true
    }
    else {
        Write-Verbose "Currently executing in standard PowerShell"
        Write-Output $false
    }
}