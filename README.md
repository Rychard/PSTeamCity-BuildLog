# PSTeamCity-BuildLog

A PowerShell module that facilitates build script interaction with TeamCity Build Agents

## Installation

> Note: Before proceeding, ensure you have the following pre-requisites:
> - [PowerShell 5.1](https://docs.microsoft.com/en-us/powershell/wmf/5.1/install-configure)
> - [PowerShellGet](https://docs.microsoft.com/en-us/powershell/gallery/psget/get_psget_module)

Open a PowerShell prompt and run the command below to install the module from the PowerShell Gallery:

```PowerShell
Install-Module `
    -Name PSTeamCity-BuildLog `
    -Scope CurrentUser `

Import-Module PSTeamCity-BuildLog
```

## Installation (Local Development)

For local development, clone the repository and and import the module folder into a PowerShell session directly:

``` PowerShell
Import-Module 'C:\path\to\repository\src\PSTeamCity-BuildLog'
```

## Cmdlets

> These Cmdlets will only produce output when running as part of a TeamCity build, unless otherwise noted.
>
> Use the `Test-TeamCity` Cmdlet to determine if the current script is running within a TeamCity environment.

### `Test-TeamCity`

Returns `$true` or `$false`, based on whether the current scope is believed to be running on a TeamCity Build Agent.

Example Usage:

``` PowerShell
if (Test-TeamCity) {
    # Execute TeamCity-specific logic here
}
```

### `Get-TeamCityEscapedString`

Escapes strings so that they can be safely used in other Cmdlets without breaking integration with the TeamCity build log.

### `Write-TeamCityMessage`

Writes an informational message to the build log.  TeamCity treats these messages differently than normal output.

### `Write-TeamCityBuildProblem`

Writes a message to the build log that indicates a problem with the build.  TeamCity treats these messages differently than normal output.

### `New-TeamCityBlock`

Writes a message to the build log indicating the beginning of a new block.  Capturing the return value will allow the block to be closed when piped to `Remove-TeamCityBlock`.

- Any output that is emitted between `New-TeamCityBlock` and `Remove-TeamCityBlock` is considered to be as contents of the block.
- The contents of a block can be collapsed in the TeamCity build log.
- Blocks can be nested within other blocks by specifying unique values for the `-Name` parameter.

``` PowerShell
$blockOuter = New-TeamCityBlock -Name "Outer"
Write-Host "This message is part of the outer block!"
$blockInner = New-TeamCityBlock -Name "Inner"
Write-Host "This message is contained in a nested block!"
$blockInner | Remove-TeamCityBlock
Write-Host "Now we're back to the outer block again!"
$blockOuter | Remove-TeamCityBlock
```

### `Remove-TeamCityBlock`

Writes a message to the build log indicating the ending of an existing block.

> Closing a block will close any nested blocks as well.