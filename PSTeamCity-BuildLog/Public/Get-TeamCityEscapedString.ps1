<#
.SYNOPSIS
    Escapes a string so that it can be used in a TeamCity message.

.LINK
    https://confluence.jetbrains.com/display/TCD9/Build+Script+Interaction+with+TeamCity
#>
Function Get-TeamCityEscapedString {
    [CmdletBinding()]
    Param (
        [Parameter(Position=0, ValueFromPipeline=$true)]
        [String]$String
    )

    if($String -eq $null) {
        Write-Output $String
    }
    else {
        $result = $String

        # Note: Unicode characters (\u####) also need to be escaped, but this doesn't do that.
        $result = $result -replace [Regex]::Escape("|"),  "||"
        $result = $result -replace [Regex]::Escape("'"),  "|'" 
        $result = $result -replace [Regex]::Escape("\r"), "|r"
        $result = $result -replace [Regex]::Escape("\n"), "|n"
        $result = $result -replace [Regex]::Escape("["),  "|["
        $result = $result -replace [Regex]::Escape("]"),  "|]"

        Write-Output $result
    }
}