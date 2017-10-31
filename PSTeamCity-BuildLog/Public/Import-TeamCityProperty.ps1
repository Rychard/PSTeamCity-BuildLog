<#
.SYNOPSIS
    Imports build properties from TeamCity into the scope of the caller
    Unless forced, doesn't do anything if not running under TeamCity

.PARAMETER Prefix
    The string that will be prepended to the beginning of each variable.

.OUTPUTS
    Writes each property to the pipeline as key-value pairs.

.LINK
    Based on https://gist.github.com/piers7/6432985
#>
Function Import-TeamCityProperty {
    [CmdletBinding(PositionalBinding=$false)]
    Param(
        [Parameter()]
        [String]$Prefix = 'TeamCity.',

        [Parameter()]
        [String]$File = $Env:TEAMCITY_BUILD_PROPERTIES_FILE + ".xml",

        [Parameter()]
        [Switch] $Quiet,

        [Parameter()]
        [Switch] $Force
    )

    $runningInTeamCity = (![String]::IsNullOrEmpty($Env:TEAMCITY_VERSION))

    if ($runningInTeamCity -or $Force.IsPresent) {
        Write-Verbose "Loading TeamCity properties from file: ${File}"
        $File = (Resolve-Path $File).Path

        if (-not (Test-Path -Path $File)) {
            Write-Error "The specified file could not be found."
        }

        $buildPropertiesXml = New-Object System.Xml.XmlDocument

        # Force the DTD (Document Type Definition) to not be tested
        $buildPropertiesXml.XmlResolver = $null 
        $buildPropertiesXml.Load($File)

        $nodes = $buildPropertiesXml.SelectNodes("//entry")
        $nodes | ForEach-Object {
            $key = $_.key
            $value = $_.'#text'
            $key = $Prefix + $key

            Write-Verbose "TeamCity Variable: ${key}=${value}"

             # Load variables into the parent scope
             # https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/set-variable?view=powershell-5.1
            Set-Variable -Name $key -Value $value -Scope 1

            if (-not ($Quiet.IsPresent)) {
                $result = @{ 
                    "$key" = $value;
                }
                Write-Output $result
            }
        }
    }
}