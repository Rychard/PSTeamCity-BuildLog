<#
.SYNOPSIS
    Opens a new TeamCity service message block.
    Blocks are used to group several messages in the build log.
    When ran in a non-TeamCity build environment, pipelining will work, but no output is produced.

.LINK
    https://confluence.jetbrains.com/display/TCD9/Build+Script+Interaction+with+TeamCity
#>
Function New-TeamCityBlock {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$Name,

        [Parameter(Mandatory=$false, Position=1)]
        [String]$Description,

        [Parameter(Mandatory=$false, Position=2)]
        [Switch]$Quiet
    )

    if (Test-TeamCity) {
        $escapedName = $Name | Get-TeamCityEscapedString

        if([String]::IsNullOrWhiteSpace($Description)) {
            $formatted = "##teamcity[blockOpened name='$($escapedName)']"
        }
        else {
            $escapedDescription = $Description | Get-TeamCityEscapedString
            $formatted = "##teamcity[blockOpened name='$($escapedName)' description='$($escapedDescription)']"
        }
        
        if ($Quiet.IsPresent) {
            Write-Output $formatted
        }
        else {
            Write-Host $formatted
        }
    }
    
    # In the interest of semantics, we return the name parameter to the pipeline.
    # This allows the return value to be stored in a variable.
    # The variable can be piped to Remove-TeamCityBlock to close the block.
    # This may be easier to read than typing it out multiple times in your scripts.
    if (-not $Quiet.IsPresent) {
        Write-Output $Name
    }
}