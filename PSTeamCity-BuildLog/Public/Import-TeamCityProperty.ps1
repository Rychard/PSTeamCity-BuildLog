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
        [Switch] $Recurse,

        [Parameter()]
        [Switch] $Quiet,

        [Parameter()]
        [Switch] $Force
    )

    if ((Test-TeamCity) -or $Force.IsPresent) {
        Write-Verbose "Loading TeamCity properties from file: ${File}"
        $File = (Resolve-Path $File).Path

        if (-not (Test-Path -Path $File)) {
            Write-Error "The specified file could not be found."
        }

        $buildPropertiesXml = New-Object System.Xml.XmlDocument

        # Force the DTD (Document Type Definition) to not be tested
        $buildPropertiesXml.XmlResolver = $null 
        $buildPropertiesXml.Load($File)

        $result = @{}

        $nodes = $buildPropertiesXml.SelectNodes("//entry")

        $nodes | ForEach-Object {
            $key = $_.key
            if(-not ([bool]($_.PSobject.Properties.name -match '#text'))) { return }
            $value = $_.'#text'
            $prefixedKey = $Prefix + $key

            if(-not $result.ContainsKey($prefixedKey)) {
                $result.Add($prefixedKey, $value)
                Set-Variable -Name $prefixedKey -Value $value
            }

            if($Recurse.IsPresent -and $key.Contains('properties.file') -and (Test-Path -Path "${value}.xml")) {
                $props = (Import-TeamCityProperty -File "${value}.xml" -Prefix $Prefix -Force)
                $props.GetEnumerator() | ForEach-Object {
                    if(-not $result.ContainsKey($_.Key)) {
                        $result.Add($_.Key, $_.Value)
                    }
                }
            }
        }

        if(-not $Quiet.IsPresent) {
            Write-Output $result
        }
    }
}