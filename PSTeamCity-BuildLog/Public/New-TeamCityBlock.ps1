<#
.SYNOPSIS
    Opens a new TeamCity service message block.
    Blocks are used to group several messages in the build log.
    When ran in a non-TeamCity build environment, pipelining will work, but no output is produced.

.LINK
    https://confluence.jetbrains.com/display/TCD9/Build+Script+Interaction+with+TeamCity
#>
Function New-TeamCityBlock {
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Low')]
    Param (
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$Name,

        [Parameter(Mandatory=$false, Position=1)]
        [String]$Description,

        [Parameter(Mandatory=$false, Position=2)]
        [Switch]$Force
    )

    if(-not $Name) {
        return
    }

    if ((Test-TeamCity) -or $Force.IsPresent) {
        $escapedName = $Name | Get-TeamCityEscapedString

        if([String]::IsNullOrWhiteSpace($Description)) {
            $formatted = "##teamcity[blockOpened name='$($escapedName)']"
        }
        else {
            $escapedDescription = $Description | Get-TeamCityEscapedString
            $formatted = "##teamcity[blockOpened name='$($escapedName)' description='$($escapedDescription)']"
        }

        if ($PSCmdlet.ShouldProcess($escapedName, 'Create new TeamCity block')) {
            Write-Output $formatted
        }
    }
}