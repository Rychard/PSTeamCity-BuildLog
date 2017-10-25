[CmdletBinding(PositionalBinding=$false)]
Param(
    [Parameter(Mandatory=$true)]
    [String]$ApiKey,

    [Parameter(Mandatory=$true)]
    [String]$Version,

    [Parameter()]
    [Switch]$NoPublish
)

$ModuleGuid = 'cf6e692e-886d-4ae1-aa4f-8a5cab45ad87'
$Path = $PSScriptRoot
$ModuleName = 'PSTeamcity-BuildLog'
$Author = 'Joshua Shearer'
$Description = 'PowerShell module that facilitates build script interaction with TeamCity Build Agents'
$PowerShellVersion = 5.0.0
$Author = "Joshua Shearer"
$Tags = @( 'PowerShell', 'TeamCity' )

$pathManifest = "${Path}\${ModuleName}\${ModuleName}.psd1"
$pathModule = "${ModuleName}.psm1"

try {
    New-ModuleManifest -Path $pathManifest `
    -RootModule $pathModule `
    -Guid $ModuleGuid `
    -Tags $Tags `
    -Description $Description `
    -PowerShellVersion $PowerShellVersion `
    -Author $Author `
    -ModuleVersion $Version `

    if($NoPublish.IsPresent) {
        Write-Verbose "Skipping publish"
        return
    }
    
    $pathPublishSource = "${Path}\${ModuleName}"
    Publish-Module -Path $pathPublishSource -NuGetApiKey $ApiKey
}
catch {
    write-output $_
    ##teamcity[buildStatus status='FAILURE' ]
    exit 1
}