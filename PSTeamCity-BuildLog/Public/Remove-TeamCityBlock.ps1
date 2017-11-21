<#
.SYNOPSIS
    Closes an existing TeamCity service message block.
    When a block is closed, any inner blocks are closed automatically.
    When ran in a non-TeamCity build environment, pipelining will work, but no output is produced.

.LINK
    https://confluence.jetbrains.com/display/TCD9/Build+Script+Interaction+with+TeamCity
#>
Function Remove-TeamCityBlock {
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Low')]
    Param (
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true)]
        [String]$Name,

        [Parameter(Mandatory=$false, Position=1)]
        [Switch]$Force
    )

    if(-not $Name) {
        return
    }

    if ((Test-TeamCity) -or $Force.IsPresent) {
        $escapedName = $Name | Get-TeamCityEscapedString
        $message = "##teamcity[blockClosed name='$($escapedName)']"

        if ($PSCmdlet.ShouldProcess($escapedName, 'Remove TeamCity block')) {
            Write-Output $message
        }
    }
}