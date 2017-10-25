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
        [ValidateNotNullOrEmpty()]
        [String]$Description
    )

    if (Test-TeamCity) {
        $escapedName = $Name | Get-TeamCityEscapedString

        if($Description -ne $null) {
            $escapedDescription = $Description | Get-TeamCityEscapedString
            $formatted = "##teamcity[blockOpened name='$($escapedName)' description='$($escapedDescription)']"
        } else {
            $formatted = "##teamcity[blockOpened name='$($escapedName)']"
        }
        
        Write-Host $formatted
    }
    
    # In the interest of semantics, we return the name parameter to the pipeline.
    # This allows the return value to be stored in a variable.
    # The variable can be piped to Remove-TeamCityBlock to close the block.
    # This may be easier to read than typing it out multiple times in your scripts.
    Write-Output $Name
}