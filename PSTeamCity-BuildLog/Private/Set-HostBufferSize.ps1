<#
.SYNOPSIS
    Prevents PowerShell from wrapping strings written to the console.

.LINK
    https://confluence.jetbrains.com/display/TCD9/PowerShell
#>
Function Set-HostBufferSize {
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Low')]
    Param(
        [Parameter()]
        [Int32]$Width = 500
    )

    if (Test-TeamCity) {
        if ($PSCmdlet.ShouldProcess((Get-Host), 'Increase host buffer size?')) {
            try {
                $rawUI = (Get-Host).UI.RawUI
                $m = $rawUI.MaxPhysicalWindowSize.Width
                $rawUI.BufferSize = New-Object Management.Automation.Host.Size ([Math]::max($m, $Width), $rawUI.BufferSize.Height)
                $rawUI.WindowSize = New-Object Management.Automation.Host.Size ($m, $rawUI.WindowSize.Height)
            } 
            catch {
                Write-Verbose "An error occurred while setting the size of the PowerShell buffer"
                $_
            }
        }
    }
}

# We want to call this function anytime the module is imported:
Set-HostBufferSize -Confirm:$false