$projectRoot = Resolve-Path "${PSScriptRoot}\.."
$moduleRoot = Split-Path (Resolve-Path "${projectRoot}\**\*.psm1")
$moduleName = Split-Path $moduleRoot -Leaf

Import-Module (Join-Path $moduleRoot "${moduleName}.psm1") -Force

Describe 'New-TeamCityBlock' {
    InModuleScope $moduleName {
        Mock Write-Host { }
    
        Context 'Inside TeamCity' {
            Mock Test-TeamCity { Write-Output $true }
    
            It 'Starts a new block' {
                New-TeamCityBlock -Name 'test' -Quiet | Should Be "##teamcity[blockOpened name='test']"
            }
    
            It 'Starts a new block with description' {
                New-TeamCityBlock -Name 'test' -Description 'description' -Quiet | Should Be "##teamcity[blockOpened name='test' description='description']"
            }
        }
    
        Context 'Outside TeamCity' {
            Mock Test-TeamCity { Write-Output $false }
    
            It 'Writes message directly' {
                New-TeamCityBlock -Name 'test' | Should Be 'test'
            }
    
            It 'Ignores description' {
                New-TeamCityBlock -Name 'test' -Description 'description' | Should Be 'test'
            }
        }
    }
    
}