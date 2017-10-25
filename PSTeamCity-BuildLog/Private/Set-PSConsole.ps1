<#
.SYNOPSIS
    Prevents PowerShell from wrapping strings written to the console.

.LINK
    https://confluence.jetbrains.com/display/TCD9/PowerShell
#>
Function Set-PSConsole {
    [CmdletBinding()]
    Param()

    if (Test-TeamCity) {
        try {
            $rawUI = (Get-Host).UI.RawUI
            $m = $rawUI.MaxPhysicalWindowSize.Width
            $rawUI.BufferSize = New-Object Management.Automation.Host.Size ([Math]::max($m, 500), $rawUI.BufferSize.Height)
            $rawUI.WindowSize = New-Object Management.Automation.Host.Size ($m, $rawUI.WindowSize.Height)
        } catch {}
    }
}

# Note: This function is defined last because we always want to call it; as below.
Set-PSConsole